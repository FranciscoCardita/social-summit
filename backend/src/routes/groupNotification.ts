import { Request, Response } from 'express';
import { App } from '../app';
import { Notification, NotificationType } from '../lib/Group';
import { Route } from '../lib/Route';
import { SocialSummitSnowflake } from '../lib/Snowflake';
import { User } from '../lib/User';

export default class extends Route {

	constructor(app: App, file: readonly string[]) {
		super(app, file, { route: 'group/notifications', authenticated: true });
	}

	public async post(request: Request, response: Response): Promise<Response> {
		const token = request.headers.authorization;
		if (!token) return response.status(400).json({ message: 'Token is required!' });

		// Find user with token
		const user = await this.app.db.exec
			?.collection('users')
			.findOne({ token }) as User | null;

		if (!user) return response.status(400).json({ message: 'Invalid token.' });

		const { type, description } = request.body;

		if (!type || !description) return response.status(400).json({ message: 'Amount and description are required!' });
		if (!(type in NotificationType)) return response.status(400).json({ message: 'Invalid type. Valid types: ' + Object.values(NotificationType).join(', ') });

		const notification: Notification = {
			id: SocialSummitSnowflake.generate().toString(),
			type,
			date: +new Date(),
			description,
		};

		await this.app.db.update('users', user.id, {
			group: {
				users: user.group.users,
				notifications: [
					...user.group.notifications,
					notification
				],
			}
		});

		return response.json(notification);
	}

}