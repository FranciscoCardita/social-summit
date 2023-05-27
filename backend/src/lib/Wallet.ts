import { Snowflake } from '@sapphire/snowflake';

export enum TransactionType {
	PAYMENT = 'PAYMENT',
	TOPUP = 'TOPUP'
}

export interface Transaction {
	id: Snowflake;
	type: TransactionType;
	date: Date;
	amount: number;
	description: string;
}

export interface Wallet {
	id: Snowflake;
	balance: number;
	transactions: Transaction[];
}