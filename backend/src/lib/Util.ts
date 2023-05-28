import { createHash, randomBytes } from 'crypto';
import { App } from '../app';

const [SLASH, COLON] = [47, 58];

/**
 * Verify if the input is a function.
 * @param input The function to verify
 */
export function isFunction(input: unknown): input is Function {
	return typeof input === 'function';
}

/**
 * Verify if the input is a class constructor.
 * @param input The function to verify
 */
export function isClass(input: unknown): boolean {
	return typeof input === 'function' &&
		typeof input.prototype === 'object' &&
		input.toString().substring(0, 5) === 'class';
}

/**
 * Verify if the input is an object literal (or class).
 * @param input The object to verify
 */
export function isObject(input: unknown): input is Record<PropertyKey, unknown> | object {
	return typeof input === 'object' && input ? input.constructor === Object : false;
}

/**
 * Verify if the input is an object literal (or class).
 * @param input The object to verify
 */
export function isObjectBool(input: unknown): boolean {
	return typeof input === 'object' && input ? input.constructor === Object : false;
}

/**
 * Verify if a number is a finite number.
 * @param input The number to verify
 */
export function isNumber(input: unknown): input is number {
	return typeof input === 'number' && !isNaN(input) && Number.isFinite(input);
}

/**
 * Check whether a value is a primitive
 * @param input The value to check
 */
export function isPrimitive(input: unknown): input is (string | number | boolean | bigint) {
	return PRIMITIVE_TYPES.includes(typeof input);
}

/**
 * Verify if an object is a promise.
 * @param input The promise to verify
 */
export function isThenable(input: unknown): input is Thenable {
	if (typeof input !== 'object' || input === null) return false;
	return (input instanceof Promise) ||
		(input !== Promise.prototype && hasThen(input) && hasCatch(input));
}

/**
 * Sets default properties on an object that aren't already specified.
 * @param defaults Default properties
 * @param given Object to assign defaults to
 */
export function mergeDefault<A extends NonNullObject, B extends Partial<A>>(defaults: A, given?: B): DeepRequired<A & B> {
	if (!given) return deepClone(defaults) as DeepRequired<A & B>;
	for (const [key, value] of Object.entries(defaults)) {
		const givenValue = Reflect.get(given, key);
		if (typeof givenValue === 'undefined') {
			Reflect.set(given, key, deepClone(value));
		} else if (isObject(givenValue)) {
			Reflect.set(given, key, mergeDefault(value as NonNullObject, givenValue));
		}
	}

	return given as DeepRequired<A & B>;
}

/**
 * Merges two objects
 * @param objTarget The object to be merged
 * @param objSource The object to merge
 */
export function mergeObjects<A extends object, B extends object>(objTarget: A, objSource: Readonly<B>): A & B {
	for (const [key, value] of Object.entries(objSource)) {
		const targetValue = Reflect.get(objTarget, key);
		if (isObject(value)) {
			Reflect.set(objTarget, key, isObject(targetValue) ? mergeObjects(targetValue, value as object) : value);
		} else if (!isObject(targetValue)) {
			Reflect.set(objTarget, key, value);
		}
	}

	return objTarget as A & B;
}

/**
 * Deep clone a value
 * @param {*} source The object to clone
 * @returns {*}
 */
export function deepClone<T>(source: T): T {
	// Check if it's a primitive (with exception of function and null, which is typeof object)
	if (source === null || isPrimitive(source)) return source;
	if (Array.isArray(source)) {
		const output = [] as unknown as T & T extends (infer S)[] ? S[] : never;
		for (const value of source) output.push(deepClone(value));
		return output as unknown as T;
	}
	if (isObjectBool(source)) {
		const output = {} as Record<PropertyKey, unknown>;
		for (const [key, value] of Object.entries(source as object)) output[key] = deepClone(value);
		return output as unknown as T;
	}
	if (source instanceof Map) {
		const output = new (source.constructor as MapConstructor)() as unknown as T & T extends Map<infer K, infer V> ? Map<K, V> : never;
		for (const [key, value] of source.entries()) output.set(key, deepClone(value));
		return output as unknown as T;
	}
	if (source instanceof Set) {
		const output = new (source.constructor as SetConstructor)() as unknown as T & T extends Set<infer K> ? Set<K> : never;
		for (const value of source.values()) output.add(deepClone(value));
		return output as unknown as T;
	}
	return source;
}

/**
 * Parses a url part
 * @param value The string part to parse
 */
export function parsePart(value: string): ParsedPart {
	const type = Number(value.charCodeAt(0) === COLON);
	if (type) value = value.substring(1);
	return { value, type };
}

/**
 * Splits a url into it's parts
 * @param url The url to split
 */
export function split(url: string): string[] {
	if (url.length === 1 && url.charCodeAt(0) === SLASH) return [url];
	else if (url.charCodeAt(0) === SLASH) url = url.substring(1);
	return url.split('/');
}

/**
 * Splits and parses a url into it's parts
 * @param url The url to split and parse
 */
export function parse(url: string): ParsedPart[] {
	return split(url).map(parsePart);
}

/**
 * Generates a random token with the given length
 * @param length The length of the token
 */
export function generateToken(length = 32): string {
	return randomBytes(length).toString('hex');
}

/**
 * Checks if a token is already in use
 * @param app The App instance
 * @param token The token to check
 */
export async function tokenIsValid(app: App, token: string): Promise<boolean> {
	const user = await app.db.exec?.collection('users').findOne({ token });
	return !user;
}

/**
 * Generates a valid token
 * @param app The App instance
 */
export async function generateValidToken(app: App): Promise<string> {
	let token = generateToken();
	while (!await tokenIsValid(app, token)) token = generateToken();
	return token;
}

/**
 * Encrypts a string to sha256
 * @param str The string to encrypt
 */
export function encrypt(str: string): string {
	return createHash('sha256').update(str).digest('hex');
}

export const PRIMITIVE_TYPES = ['string', 'bigint', 'number', 'boolean'];

export interface ParsedPart {
	value: string;
	type: number;
}

export interface Thenable {
	then: Function;
	catch: Function;
}

export function hasThen(input: { then?: Function }): boolean {
	return Reflect.has(input, 'then') && isFunction(input.then);
}

export function hasCatch(input: { catch?: Function }): boolean {
	return Reflect.has(input, 'catch') && isFunction(input.catch);
}

export type NonNullObject = {};

export type Primitive = string | number | boolean | bigint | symbol | undefined | null;
export type Builtin = Primitive | Function | Date | Error | RegExp;

export type DeepRequired<T> = T extends Builtin
	? NonNullable<T>
	: T extends Map<infer K, infer V>
		? Map<DeepRequired<K>, DeepRequired<V>>
		: T extends ReadonlyMap<infer K, infer V>
			? ReadonlyMap<DeepRequired<K>, DeepRequired<V>>
			: T extends WeakMap<infer K, infer V>
				? WeakMap<DeepRequired<K>, DeepRequired<V>>
				: T extends Set<infer U>
					? Set<DeepRequired<U>>
					: T extends ReadonlySet<infer U>
						? ReadonlySet<DeepRequired<U>>
						: T extends WeakSet<infer U>
							? WeakSet<DeepRequired<U>>
							: T extends Promise<infer U>
								? Promise<DeepRequired<U>>
								: T extends {}
									? { [K in keyof T]-?: DeepRequired<T[K]> }
									: NonNullable<T>;