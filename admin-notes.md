# 2024-04-20

## Move to api.r-pkg.org

Create postgres DB, apps:

```
dokku apps:create evercran
dokku builder-dockerfile:set evercran dockerfile-path \
    app/evercran/Dockerfile
dokku builder:set evercran selected dockerfile
dokku postgres:create evercran
dokku postgres:link evercran evercran

dokku apps:create evercran-shell
dokku builder-dockerfile:set evercran-shell dockerfile-path \
    app/shell/Dockerfile
dokku builder:set evercran-shell selected dockerfile
dokku postgres:link evercran evercran-shell
```

Create dB structure from `create.sql`.

```
dokku postgres:connect evercran < create.sql
```

Mount `/packages`, this is where `PACKAGES.gz` files will be stored.

```
mkdir /packages
dokku storage:mount evercran /packages:/packages
dokku storage:mount evercran-shell /packages:/packages
```

Update the app, push to dokku.

```
git remote add dokku-shell dokku@api.r-pkg.org:evercran-shell
git remote add dokku dokku@api.r-pkg.org:evercran
git push dokku-shell
git push dokku
```

Get https certs:

```
dokku letsencrypt:set evercran email csardi.gabor@gmail.com
dokku domains:add evercran evercran.r-pkg.org
dokku letsencrypt:enable evercran
```

Actually, that's not good, because we cannot redirect to https,
that would break the old R versions the evercran supports. So we
need our own nginx config template file, inside the repo. We
need to set its location in the config:
```
dokku nginx:set evercran nginx-conf-sigil-path \
    app/evercran/nginx.conf.sigil
```
