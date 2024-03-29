export enum TransactionType {
	PAYMENT = 'PAYMENT',
	TOPUP = 'TOPUP'
}

export interface Transaction {
	id: string;
	type: TransactionType;
	date: number;
	amount: number;
	description: string;
}

export interface Wallet {
	id: string;
	balance: number;
	transactions: Transaction[];
}