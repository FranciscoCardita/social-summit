import { join } from 'path';
// eslint-disable-next-line @typescript-eslint/no-var-requires
require('dotenv-override').config({ path: join(__dirname, '../', '.env') });

import Database from './mongodb';

const db = new Database();
db.init();