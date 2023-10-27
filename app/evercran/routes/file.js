import express from 'express';
var router = express.Router();
import pool from '../lib/pool.js';

const re_pkgfile = /^(?<pkg>[a-zA-Z0-9]+)_(?<ver>[-a-zA-Z0-9.]+)[.]tar[.]gz$/;
const http_mirror = process.env.CRAN_MIRROR || "http://cran.r-project.org";
const https_mirror = process.env.CRAN_MIRROR || "https://cloud.r-project.org";

async function get_package_path(pkg, ver) {
    const ret = await pool.query(
        `SELECT package, version, current
         FROM packages
         WHERE package=$1 AND version=$2`,
        [pkg, ver]
    );
    var path;
    if (ret.rowCount == 0 || ret.rows[0].current === true) {
        path = '/';
    } else {
        path = 'Archive/' + pkg + '/';
    }
    return path;
}

router.get(
    '/:year/:month/:day/src/contrib/Archive/:package/:filename',
    async function redirect_to_package(req, res, next) {
        const filename = req.params.filename
        if (!filename.match(re_pkgfile)) { return next(); }
        const { groups: { pkg, ver } } = re_pkgfile.exec(filename);
        if (pkg != req.params.package) { return next(); }
        const path = 'Archive/' + pkg + '/';
        const mirror = req.protocol == "https" ? https_mirror : http_mirror;
        const url =  mirror + '/src/contrib/' + path + filename;
        console.log(`${req.url} -> ${url}`);
        res.redirect(url);
    }
);

router.get(
    '/:year/:month/:day/src/contrib/:filename',
    async function redirect_to_package(req, res, next) {
        const filename = req.params.filename
        if (!filename.match(re_pkgfile)) { return next(); }
        const { groups: { pkg, ver } } = re_pkgfile.exec(filename);
        if (!!req.params.package) {
            if (pkg != req.params.package) { return next(); }
        }
        const path = await get_package_path(pkg, ver);
        const mirror = req.protocol == "https" ? https_mirror : http_mirror;
        const url = mirror + '/src/contrib/' + path + filename;
        console.log(`${req.url} -> ${url}`);
        res.redirect(url);
    }
);

export default router;
