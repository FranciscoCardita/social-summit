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
	startDate: number;
	endDate: number;
	location: string;
	image: string;
	type: EventType;
}

export interface User {
	id: string;
	name: string;
	email: string;
	password: string;
	birthDate: number;
	phone: string;
	wallet: Wallet;
	group: Group;
	localization: Localization;
	events: string[];
	token?: string;
}

export interface Seller extends User {
	machineId: number;
}