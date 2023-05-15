import { MongoClient as Mongo, ServerApiVersion } from 'mongodb';
import { isObject, mergeObjects } from './lib/Util';
import type { Collection, Db, DeleteResult, Document, InsertOneResult, UpdateResult } from 'mongodb';

export default class Database {

	private db: Db | null;

	constructor() {
		this.db = null;
	}

	/**
	 * Initializes the database
	 */
	async init(): Promise<void> {
		const connectionString = process.env.MONGODB_URI;
		if (!connectionString) throw new Error('The environment variable MONGODB_URI must be specified!');

		const mongoClient = new Mongo(connectionString, { serverApi: ServerApiVersion.v1 });

		await mongoClient.connect();
		this.db = mongoClient.db();
	}

	/* Table methods */

	get exec() {
		return this.db;
	}

	/**
	 * Inserts or creates a table in the database.
	 * @param table The table to check against
	 */
	public createTable(table: string): Promise<Collection<Document>> {
		return this.db!.createCollection(table);
	}

	/**
	 * Deletes or drops a table from the database.
	 * @param table The table to check against
	 */
	public deleteTable(table: string): Promise<boolean> {
		return this.db!.dropCollection(table);
	}

	/**
	 * Checks if a table exists in the database.
	 * @param table The table to check against
	 */
	public async hasTable(table: string): Promise<boolean> {
		return this.db!.listCollections().toArray().then(collections => collections.some(col => col.name === table));
	}

	/* Document methods */

	/**
	 * Inserts new entry into a table.
	 * @param table The table to update
	 * @param entry The entry's ID to create
	 * @param data The data to insert
	 */
	public async create(table: string, entry: string, data: object = {}): Promise<InsertOneResult<Document>> {
		return this.db!.collection(table).insertOne(mergeObjects(data, resolveQuery(entry)));
	}

	/**
	 * Removes entries from a table.
	 * @param table The table to update
	 * @param entry The ID of the entry to delete
	 */
	public async delete(table: string, entry: string): Promise<DeleteResult> {
		return this.db!.collection(table).deleteOne(resolveQuery(entry));
	}

	/**
	 * Retrieve a single entry from a table.
	 * @param table The table to query
	 * @param entry The ID of the entry to retrieve
	 */
	public async get(table: string, entry: string): Promise<object | null> {
		return this.db!.collection(table).findOne(resolveQuery(entry));
	}

	/**
	 * Retrieve all entries from a table.
	 * @param table The table to query
	 * @param entries The ids to retrieve from the table
	 */
	public async getAll(table: string, entries: string[]): Promise<object[]> {
		if (entries.length) return this.db!.collection(table).find({ id: { $in: entries } }, { projection: { _id: 0 } }).toArray();
		return this.db!.collection(table).find({}, { projection: { _id: 0 } }).toArray();
	}

	/**
	 * Retrieves all entries' keys from a table.
	 * @param table The table to query
	 */
	public async getKeys(table: string): Promise<string[]> {
		return this.db!.collection(table).find({}, { projection: { id: 1, _id: 0 } }).toArray().then(docs => docs.map(doc => doc.id));
	}

	/**
	 * Retrives a random entry from a table.
	 * @param table The table to query
	 */
	public async getRandom(table: string): Promise<object | null> {
		return this.db!.collection(table).aggregate([{ $sample: { size: 1 } }]);
	}

	/**
	 * Check if an entry exists in a table.
	 * @param table The table to update
	 * @param entry The entry's ID to check against
	 */
	public async has(table: string, entry: string): Promise<boolean> {
		return this.get(table, entry).then(Boolean);
	}

	/**
	 * Updates an entry from a table.
	 * @param table The table to update
	 * @param entry The entry's ID to update
	 * @param data The data to update
	 */
	public async update(table: string, entry: string, data: object): Promise<UpdateResult> {
		return this.db!.collection(table).updateOne(resolveQuery(entry), { $set: flatten(data) });
	}

	/**
	 * Overwrites the data from an entry in a table.
	 * @param table The table to update
	 * @param entry The entry's ID to update
	 * @param data The new data for the entry
	 */
	public async replace(table: string, entry: string, data: object): Promise<Document | UpdateResult> {
		return this.db!.collection(table).replaceOne(resolveQuery(entry), data);
	}

}

const resolveQuery = (query: object | string) => isObject(query) ? query : { id: query };

function flatten(obj: object, path = ''): object {
	let output: { [key: string]: string } = {};
	for (const [key, value] of Object.entries(obj)) {
		if (isObject(value)) output = Object.assign(output, flatten(value, path ? `${path}.${key}` : key));
		else output[path ? `${path}.${key}` : key] = value;
	}
	return output;
}