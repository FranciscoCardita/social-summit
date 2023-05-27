import { basename, extname } from 'path';
import { ParsedPart, parse } from './Util';
import { App } from '../app';

export interface RouteOptions {
	name?: string;
	route?: string;
}

export type ParsedRoute = ParsedPart[];

export class Route {

	/**
	 * The App that manages this Route instance
	 */
	public app: App;

	/**
	 * The name of the route.
	 */
	public name: string;

	/**
	 * The route path.
	 */
	public route: string;

	/**
	 * Stored parsed route.
	 */
	public parsed: ParsedRoute;

	/**
	 * @param app The App that manages this Route instance
	 * @param options Optional Route settings
	 */
	public constructor(app: App, file: readonly string[], options: RouteOptions) {
		this.app = app;
		this.name = options.name ?? basename(file[file.length - 1], extname(file[file.length - 1]));
		this.route = 'api/' + options.route;
		this.parsed = parse(this.route);
	}

	/**
	 * If this route matches a provided url.
	 * @param split the url to check
	 */
	public matches(split: string[]): boolean {
		if (split.length !== this.parsed.length) return false;
		for (let i = 0; i < this.parsed.length; i++) if (this.parsed[i].type === 0 && this.parsed[i].value !== split[i]) return false;
		return true;
	}

	/**
	 * Extracts the params from a provided url.
	 * @param split the url
	 */
	public execute(split: string[]): Record<string, string> {
		const params: Record<string, string> = {};
		for (let i = 0; i < this.parsed.length; i++) if (this.parsed[i].type === 1) params[this.parsed[i].value] = split[i];
		return params;
	}

}