import pg from 'pg';
import fs from "fs";

const pass_file = process.env.PG_PASS_FILE;
const pass = pass_file && fs.readFileSync(pass_file, 'utf8').trim();

const pool = new pg.Pool({
    host: process.env.PG_HOST,
    user: process.env.PG_USER || 'postgres',
    db: 'postgres',
    password: pass
})

export default pool;
