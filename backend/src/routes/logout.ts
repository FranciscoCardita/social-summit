import { Request, Response } from 'express';
import { App } from '../app';
import { Route } from '../lib/Route';

export default class extends Route {

	constructor(app: App, file: readonly string[]) {
		super(app, file, { route: 'oauth/logout', authenticated: true });
	}

	public async post(request: Request, response: Response): Promise<Response> {
		const token = request.headers.authorization;
		if (!token) return response.status(400).json({ message: 'Token is required!' });

		// Find user with token
		const user = await this.app.db.exec
			?.collection('users')
			.findOne({ token });

		if (!user) return response.status(404).json({ message: 'Invalid token.' });

		// Clear token
		await this.app.db.update('users', user.id, { token: undefined });

		return response.json({ message: 'Logged out successfully.' });
	}

}