import { METHODS, STATUS_CODES } from 'http';
import cors from 'cors';
import express, { Express, NextFunction, Request, Response } from 'express';
import { App } from './app';
import { split } from './lib/Util';

const lowerMethods: Record<string, string> = {};
for (const method of METHODS) lowerMethods[method] = method.toLowerCase();

export const METHODS_LOWER = lowerMethods as Readonly<Record<string, string>>;

interface ErrorLike {
	code?: number;
	stats?: number;
	statusCode?: number;
	message?: string;
}

export default class Server {

	/**
	 * The App that manages this Server instance
	 */
	public app: App;

	/**
	 * The express instance that manages the HTTP requests
	 */
	public express: Express;

	/**
	 * The onError function called when a url does not match
	 */
	private onNoMatch: (this: Server, _request: Request, response: Response) => void;

	/**
	 * @param app The App that manages this Server instance
	 */
	constructor(app: App) {
		this.app = app;
		this.express = express();
		this.express.use(express.json());
		this.express.use(cors());
		this.onNoMatch = this.onError.bind(this, { code: 404 });
	}

	public listen(port: number): Promise<void> {
		this.express.use(this.handler.bind(this));
		return new Promise(res => {
			this.express.listen(port, res);
			console.log(`Listening on port ${port}`);
		});
	}

	/**
	 * The handler for incoming requests
	 * @param request The request
	 * @param response The response
	 * @param next The next function
	 */
	private async handler(request: Request, response: Response, next: NextFunction): Promise<void> {
		const info = new URL(request.url, 'http://localhost');

		const splitURL = split(info.pathname);
		const route = this.app.findRoute(splitURL);

		if (route) request.params = route.execute(splitURL);

		console.log('Incoming request:', request.method, info.pathname);

		// Check if the user is authenticated
		if (route?.authenticated) {
			const token = request.headers.authorization;
			if (!token) return this.onError({ code: 401, message: 'Unauthorized.' }, request, response);

			const user = await this.app.db.exec
				?.collection('users')
				.findOne({ token });

			if (!user) return this.onError({ code: 401, message: 'Invalid token.' }, request, response);
		}

		try {
			if (response.writableEnded) return;
			const method = METHODS_LOWER[request.method];
			if (route && Reflect.has(route, method)) await Reflect.apply(Reflect.get(route, method), route, [request, response, next]);
			else this.onNoMatch(request, response);
		} catch (err: any) {
			return this.onError(err, request, response);
		}

		next();
	}

	/**
	 * The handler for errors
	 * @param error The error
	 * @param request The request
	 * @param response The response
	 */
	private onError(error: Error | ErrorLike, _request: Request, response: Response): void {
		const code = response.statusCode = Reflect.get(error, 'code') ?? Reflect.get(error, 'status') ?? Reflect.get(error, 'statusCode') ?? 500;
		response.end(error.message ?? STATUS_CODES[code]);
	}

}
