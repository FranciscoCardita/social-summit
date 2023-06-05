import { Group } from './Group';
import { Wallet } from './Wallet';

export interface Localization {
	latitude: number;
	longitude: number;
}

export interface User {
	id: string;
	name: string;
	email: string;
	password: string;
	birthDate: number;
	phone: string;
	avatar?: string;
	wallet: Wallet;
	group: Group;
	localization: Localization;
	events: string[];
	token?: string;
}

export interface Seller extends User {
	machineId: number;
}