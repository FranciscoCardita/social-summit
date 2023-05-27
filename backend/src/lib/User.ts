import { Snowflake } from '@sapphire/snowflake';
import { Group } from './Group';
import { Wallet } from './Wallet';

export interface Localization {
	latitude: number;
	longitude: number;
}

export interface User {
	id: Snowflake;
	name: string;
	email: string;
	birthDate: Date;
	nif: string;
	phone: string;
	address: string;
	wallet: Wallet;
	group: Group;
	localization: Localization;
}

export interface Seller extends User {
	machineId: number;
}