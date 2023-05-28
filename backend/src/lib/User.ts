import { Group } from './Group';
import { Wallet } from './Wallet';

export interface Localization {
	latitude: number;
	longitude: number;
}

export enum EventType {
	GENERAL_ADMISSION = 'GENERAL_ADMISSION',
	DAILY = 'DAILY',
}

export interface Event {
	id: string;
	name: string;
	startDate: Date;
	endDate: Date;
	location: string;
	image: string;
	type: EventType;
}

export interface User {
	id: string;
	name: string;
	email: string;
	password: string;
	birthDate: Date;
	nif: string;
	phone: string;
	address: string;
	wallet: Wallet;
	group: Group;
	localization: Localization;
	events: string[];
	token?: string;
}

export interface Seller extends User {
	machineId: number;
}