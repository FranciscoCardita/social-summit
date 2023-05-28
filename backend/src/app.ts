import { readdir } from 'fs/promises';
import { join, relative, sep } from 'path';

// eslint-disable-next-line @typescript-eslint/no-var-requires
require('dotenv-override').config({ path: join(__dirname, '../', '.env') });

import Server from './express';
import { Route } from './lib/Route';
import { isClass } from './lib/Util';
import Database from './mongodb';

export class App {
	public db: Database;
	public express: Server;
	public routes: Map<string, Route>;

	constructor() {
		this.db = new Database();
		this.express = new Server(this);
		this.routes = new Map();
	}

	public async init(): Promise<void> {
		await this.registerRoutes();
		await this.db.init();

		const existsUsers = await this.db.hasTable('users');
		if (!existsUsers) await this.db.createTable('users');

		const existsEvents = await this.db.hasTable('events');
		if (!existsEvents) await this.db.createTable('events');

		await this.express.listen(Number(process.env.PORT));
	}

	public findRoute(splitURL: string[]): Route | undefined {
		for (const route of this.routes.values()) if (route.matches(splitURL)) return route;
		return undefined;
	}

	private async registerRoutes(): Promise<void> {
		const directory = join(__dirname, 'routes');
		const files = await readdir(directory);
		for (const file of files) {
			if (!file.endsWith('.js')) continue;
			
			const fileInfo = relative(__dirname, file).split(sep);
			const loc = join(directory, file);
			
			try {
				const loaded = await import(loc) as { default: any } | any;
				const loadedRoute = 'default' in loaded ? loaded.default : loaded;
				if (!isClass(loadedRoute)) throw new TypeError('The exported structure is not a class.');
				const route: Route = new loadedRoute(this, fileInfo);
				this.routes.set(route.name, route);
			} catch (error: any) {
				console.error(`Failed to load file '${loc}'. Error:\n${error.stack || error}`);
			}
		}
	}

}

const app = new App();
app.init();