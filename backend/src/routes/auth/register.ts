import { Request, Response } from 'express';
import { App } from '../../app';
import { Route } from '../../lib/Route';
import { SocialSummitSnowflake } from '../../lib/Snowflake';
import { User } from '../../lib/User';
import { encrypt, generateValidToken } from '../../lib/Util';

export default class extends Route {

	constructor(app: App, file: readonly string[]) {
		super(app, file, { route: 'auth/register', authenticated: false });
	}

	public async post(request: Request, response: Response): Promise<Response> {
		const { name, email, password, birthDate, phone } = request.body;

		if (!name) return response.status(400).json({ message: 'Name is required!' });
		if (!email) return response.status(400).json({ message: 'Email is required!' });
		if (!password) return response.status(400).json({ message: 'Password is required!' });
		if (!birthDate) return response.status(400).json({ message: 'Birth date is required!' });
		if (!phone) return response.status(400).json({ message: 'Phone is required!' });

		// Check if email is already in use
		const userWithEmail = await this.app.db.exec
			?.collection('users')
			.findOne({ email });

		if (userWithEmail) return response.status(400).json({ message: 'Email is already in use.' });

		const user: User = {
			id: SocialSummitSnowflake.generate().toString(),
			name,
			email,
			password: encrypt(password),
			birthDate: new Date(birthDate).getTime(),
			phone,
			wallet: {
				id: SocialSummitSnowflake.generate().toString(),
				balance: 0,
				transactions: []
			},
			group: {
				users: [],
				notifications: []
			},
			localization: {
				latitude: 0,
				longitude: 0
			},
			events: ['53622671572733952', '53622671572733953'],
			token: await generateValidToken(this.app)
		};

		await this.app.db.create('users', user.id, user);

		return response.json({ token: user.token });
	}

}