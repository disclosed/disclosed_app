Deployment was done following this guide: https://coderwall.com/p/ttrhow/deploying-rails-app-using-nginx-puma-and-capistrano-3

`/etc/environmen` defines the environment variable for `SECRET_KEY_BASE`. Setting this value under `.bash_profile` or `.bashrc` did not work.

### Commands

Use `cap -T` to see all available capistrano tasks.

To deploy

```
cap production deploy
```

To restart the server

```
cap production deploy:restart
```

### Log files


```
deploy@disclosed:~/disclosed/current/log$ ls
nginx.access.log  nginx.error.log  production.log  puma.access.log  puma.error.log
```

It is possible that some exceptions will not show up in the logs above.
To troubleshoot rails server errors start the server in production manually.

```
deploy@disclosed:~/disclosed/current$ bundle exec rails s -e production
```

And then request a page using the links browser

```
links http://0.0.0.0:3000
```

Look at the output of the rails s command


