import { Request, Response } from 'express';
import { App } from '../app';
import Route from '../lib/Route';

export default class extends Route {

	constructor(app: App, file: readonly string[]) {
		super(app, file, { route: '' });
	}

	public get(_request: Request, response: Response): Response {
		return response.json({ message: 'Hello World!' });
	}

}