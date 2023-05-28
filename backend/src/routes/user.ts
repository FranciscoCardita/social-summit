import { Request, Response } from 'express';
import { App } from '../app';
import { Route } from '../lib/Route';

export default class extends Route {

	constructor(app: App, file: readonly string[]) {
		super(app, file, { route: 'users/:userID', authenticated: true });
	}

	public async get(request: Request, response: Response): Promise<Response> {
		const { userID } = request.params;

		const user = await this.app.db.get('users', userID);
		if (!user) return response.status(404).json({ message: 'User not found' });

		return response.json(user);
	}

}