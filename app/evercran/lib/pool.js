import pg from 'pg';
import url from 'url';

const pg_url = process.env.DATABASE_URL;

const params = url.parse(pg_url);
const auth = params.auth.split(':');
const creds = {
    user: auth[0],
    password: auth[1],
    host: params.hostname,
    port: params.port,
    database: params.pathname.split('/')[1]
};

const pool = new pg.Pool(creds);

export default pool;
