import { Request, Response } from 'express';
import { App } from '../../app';
import { Route } from '../../lib/Route';

export default class extends Route {

	constructor(app: App, file: readonly string[]) {
		super(app, file, { route: 'events/:eventID', authenticated: true });
	}

	public async get(request: Request, response: Response): Promise<Response> {
		const { eventID } = request.params;

		const event = await this.app.db.get('events', eventID);
		if (!event) return response.status(404).json({ message: 'Event not found' });

		// @ts-ignore
		delete event._id;

		return response.json(event);
	}

}