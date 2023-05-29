import { Request, Response } from 'express';
import { App } from '../app';
import { Route } from '../lib/Route';
import { SocialSummitSnowflake } from '../lib/Snowflake';
import { User } from '../lib/User';
import { Transaction, TransactionType } from '../lib/Wallet';

export default class extends Route {

	constructor(app: App, file: readonly string[]) {
		super(app, file, { route: 'wallet/transaction', authenticated: true });
	}

	public async post(request: Request, response: Response): Promise<Response> {
		const token = request.headers.authorization;
		if (!token) return response.status(400).json({ message: 'Token is required!' });

		// Find user with token
		const user = await this.app.db.exec
			?.collection('users')
			.findOne({ token }) as User | null;

		if (!user) return response.status(404).json({ message: 'Invalid token.' });

		const { amount, type, description } = request.body;

		if (!amount || !type) return response.status(400).json({ message: 'Amount and type are required!' });
		if (!(type in TransactionType)) return response.status(400).json({ message: 'Invalid type. Valid types: ' + Object.values(TransactionType).join(', ') });
		if (type === TransactionType.PAYMENT && !description) return response.status(400).json({ message: 'Description is required for payment transactions.' });

		const transaction: Transaction = {
			id: SocialSummitSnowflake.generate().toString(),
			amount,
			type,
			date: +new Date(),
			description: type === TransactionType.TOPUP ? 'Top Up' : description,
		};

		const balance = user.wallet.balance + (type === TransactionType.TOPUP ? amount : -amount);

		if (balance < 0) return response.status(400).json({ message: 'Insufficient funds.' });

		await this.app.db.update('users', user.id, {
			wallet: {
				id: user.wallet.id,
				balance,
				transactions: [
					...user.wallet.transactions,
					transaction
				],
			}
		});

		return response.json(transaction);
	}

}