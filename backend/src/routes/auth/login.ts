import { Request, Response } from 'express';
import { App } from '../../app';
import { Route } from '../../lib/Route';
import { encrypt, generateValidToken } from '../../lib/Util';

export default class extends Route {

	constructor(app: App, file: readonly string[]) {
		super(app, file, { route: 'auth/login' });
	}

	public async post(request: Request, response: Response): Promise<Response> {
		const { email, password } = request.body;

		if (!email) return response.status(400).json({ message: 'Email is required!' });
		if (!password) return response.status(400).json({ message: 'Password is required!' });

		// Find user with email and password
		const user = await this.app.db.exec
			?.collection('users')
			.findOne({ email, password: encrypt(password) });

		if (!user) return response.status(400).json({ message: 'Invalid email or password.' });
		
		// Generate token
		const token = await generateValidToken(this.app);
		await this.app.db.update('users', user.id, { token });

		return response.json({ token });
	}

}