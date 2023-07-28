import express from 'express';
import fs from 'fs';
import zlib from 'node:zlib';
var router = express.Router();

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
