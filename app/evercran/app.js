import express from 'express';
import logger from 'morgan';

import metaRouter from './routes/meta.js';
import fileRouter from './routes/file.js';

export var app = express();

app.use(logger('combined'));
app.use(express.static("/packages"));

app.use('/', metaRouter);
app.use('/', fileRouter);

export default app;
