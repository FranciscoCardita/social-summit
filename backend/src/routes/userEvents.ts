import { Request, Response } from 'express';
import { App } from '../app';
import { Route } from '../lib/Route';
import { User } from '../lib/User';

export default class extends Route {

	constructor(app: App, file: readonly string[]) {
		super(app, file, { route: 'users/:userID/events', authenticated: true });
	}

	public async get(request: Request, response: Response): Promise<Response> {
		const token = request.headers.authorization;
		const { userID } = request.params;

		const user = await this.app.db.get('users', userID) as User | null;
		if (!user) return response.status(404).json({ message: 'User not found' });
		if (user.token !== token) return response.status(401).json({ message: 'Access restricted.' });

		const events = await this.app.db.exec?.collection('events').find({ id: { $in: user.events } }).toArray();

		// @ts-ignore
		events?.map(event => delete event._id);

		return response.json(events);
	}

}