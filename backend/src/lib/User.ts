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
	birthDate: Date;
	nif: string;
	phone: string;
	address: string;
	wallet: Wallet;
	group: Group;
	localization: Localization;
	token?: string;
}

export interface Seller extends User {
	machineId: number;
}