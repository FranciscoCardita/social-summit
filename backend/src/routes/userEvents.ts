import { Request, Response } from 'express';
import { App } from '../app';
import { Route } from '../lib/Route';
import { User } from '../lib/User';

export default class extends Route {

	constructor(app: App, file: readonly string[]) {
		super(app, file, { route: 'events', authenticated: true });
	}

	public async get(request: Request, response: Response): Promise<Response> {
		const token = request.headers.authorization;
		if (!token) return response.status(400).json({ message: 'Token is required!' });

		// Find user with token
		const user = await this.app.db.exec
			?.collection('users')
			.findOne({ token }) as User | null;

		if (!user) return response.status(404).json({ message: 'Invalid token.' });

		const events = await this.app.db.exec?.collection('events').find({ id: { $in: user.events } }).toArray();

		// @ts-ignore
		events?.map(event => delete event._id);

		return response.json(events);
	}

}