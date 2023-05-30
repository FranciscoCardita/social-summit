import { Request, Response } from 'express';
import { App } from '../../app';
import { Route } from '../../lib/Route';
import { User } from '../../lib/User';

export default class extends Route {

	constructor(app: App, file: readonly string[]) {
		super(app, file, { route: 'group/users', authenticated: true });
	}

	public async get(request: Request, response: Response): Promise<Response> {
		const token = request.headers.authorization;

		// Find user with token
		const user = await this.app.db.exec
			?.collection('users')
			.findOne({ token }) as User | null;

		if (!user) return response.status(401).json({ message: 'Invalid token.' });

		return response.json(user.group.users);
	}

	public async post(request: Request, response: Response): Promise<Response> {
		const token = request.headers.authorization;

		// Find user with token
		const user = await this.app.db.exec
			?.collection('users')
			.findOne({ token }) as User | null;

		if (!user) return response.status(401).json({ message: 'Invalid token.' });

		const { email: userEmail } = request.body;
		if (!userEmail) return response.status(400).json({ message: 'User email is required!' });

		// Find user with email
		const invitedUser = await this.app.db.exec
			?.collection('users')
			.findOne({ email: userEmail }) as User | null;

		if (!invitedUser) return response.status(400).json({ message: 'Invalid user email.' });
		if (user.group.users.find(u => u.id === invitedUser.id)) return response.status(400).json({ message: 'User is already in the group.' });

		await this.app.db.update('users', user.id, {
			group: {
				users: [
					...user.group.users,
					{
						id: invitedUser.id,
						name: invitedUser.name,
						avatar: invitedUser.avatar
					}
				],
				notifications: user.group.notifications
			}
		});

		return response.json({ message: 'User added to the group.' });
	}

	public async delete(request: Request, response: Response): Promise<Response> {
		const token = request.headers.authorization;

		// Find user with token
		const user = await this.app.db.exec
			?.collection('users')
			.findOne({ token }) as User | null;

		if (!user) return response.status(401).json({ message: 'Invalid token.' });

		const { id } = request.body;
		if (!id) return response.status(400).json({ message: 'User ID is required!' });

		// Find user with email
		const invitedUser = await this.app.db.exec
			?.collection('users')
			.findOne({ id }) as User | null;

		if (!invitedUser) return response.status(400).json({ message: 'Invalid user ID.' });
		if (!user.group.users.find(u => u.id === invitedUser.id)) return response.status(400).json({ message: 'User is not in the group.' });

		await this.app.db.update('users', user.id, {
			group: {
				users: user.group.users.filter(u => u.id !== invitedUser.id),
				notifications: user.group.notifications
			}
		});

		return response.json({ message: 'User removed from the group.' });
	}

}