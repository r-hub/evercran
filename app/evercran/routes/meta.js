import express from 'express';
import fs from 'fs';
import zlib from 'node:zlib';
var router = express.Router();

router.get(
    '/yesterday/src/contrib/PACKAGES.gz',
    async function(req, res, next) {
        res.set('Content-Type', 'application/gzip');

        // Calculate date from two days ago
        const twoDaysAgo = new Date();
        twoDaysAgo.setDate(twoDaysAgo.getDate() - 2);

        const year = twoDaysAgo.getFullYear();
        const month = String(twoDaysAgo.getMonth() + 1).padStart(2, '0');
        const day = String(twoDaysAgo.getDate()).padStart(2, '0');

        const gzpkg = `/packages/${year}/${month}/${day}/src/contrib/PACKAGES.gz`;

        const fileStream = fs.createReadStream(gzpkg);
        fileStream.on('error', err => {
            next(err);
        });
        fileStream.pipe(res);
    }
);

router.get(
    '/yesterday/src/contrib/PACKAGES',
    async function(req, res, next) {
        res.set('Content-Type', 'text/plain');

        // Calculate date from two days ago
        const twoDaysAgo = new Date();
        twoDaysAgo.setDate(twoDaysAgo.getDate() - 2);

        const year = twoDaysAgo.getFullYear();
        const month = String(twoDaysAgo.getMonth() + 1).padStart(2, '0');
        const day = String(twoDaysAgo.getDate()).padStart(2, '0');

        const gzpkg = `/packages/${year}/${month}/${day}/src/contrib/PACKAGES.gz`;

        const fileStream = fs.createReadStream(gzpkg);
        var ungz = zlib.createGunzip();
        fileStream.on('error', err => {
            next(err);
        });
        ungz.on('error', function(err){
            next(err);
        });
        fileStream.pipe(ungz);
        ungz.pipe(res);
    }
);

router.get(
    '/:year/:month/:day/src/contrib/PACKAGES',
    async function(req, res, next) {
        res.set('Content-Type', 'text/plain');
        const gzpkg =
              "/packages/" +
              req.params.year + '/' +
              req.params.month + '/' +
              req.params.day +
              '/src/contrib/PACKAGES.gz';

        const fileStream = fs.createReadStream(gzpkg);
        var ungz = zlib.createGunzip();
        fileStream.on('error', err => {
            next(err);
        });
        ungz.on('error', function(err){
            next(err);
        });
        fileStream.pipe(ungz);
        ungz.pipe(res);
    }
);

export default router;
