# Dockerized janky

## Example configuration

We need mysql or postgresql as a persistence layer, active jenkins & hubot instances

```sh
# expose socket at /run/mysqld/mysql.sock
# create users
docker run \
  --name mysql \
  -v /path/to/mysql/data:/var/lib/mysql \
  -v /run/mysqld:/run/mysqld \
  --hostname mysqlhost \
  -e 'DB_USER=janky' \
  -e 'DB_PASS=janky_pass' \
  -e 'DB_NAME=janky_production' \
  sameersbn/mysql

docker run \
  --link db:db \
  --name janky \
  -v /path/to/config:/opt/config \
  -v /run/mysqld:/run/mysqld \
  -e 'RACK_ENV=production' \
  -e 'DATABASE_URL=mysql2://janky:janky_pass@mysqlhost/janky_production' \
  -e 'JANKY_BASE_URL=http://janky.example.com/' \
  -e 'JANKY_BUILDER_DEFAULT=http://jenkins.example.com/' \
  -e 'JANKY_CONFIG_DIR=/opt/config' \
  -e 'JANKY_HUBOT_USER=janky' \
  -e 'JANKY_HUBOT_PASSWORD=janky_password' \
  -e 'JANKY_GITHUB_USER=github' \
  -e 'JANKY_GITHUB_PASSWORD=github_token' \
  -e 'JANKY_GITHUB_HOOK_SECRET=supersecret' \
  -e 'JANKY_CHAT_DEFAULT_ROOM=control-room' \
  -e 'JANKY_DATABASE_SOCKET=/run/mysql.sock' \
  -e 'JANKY_GITHUB_STATUS_TOKEN=....' \
  -e 'JANKY_CHAT=hubot' \
  -e 'JANKY_CHAT_HUBOT_URL=https://hubot.example.com/' \
  -e 'JANKY_CHAT_HUBOT_ROOMS=control-room' \
  -e 'JANKY_SESSION_SECRET=$(pwgen)' \
  -e 'JANKY_AUTH_CLIENT_ID=...' \
  -e 'JANKY_AUTH_CLIENT_SECRET=...' \
  -e 'JANKY_AUTH_ORGANIZATION=...' \
  -e 'JANKY_AUTH_TEAM_ID=git' \
  makeomatic/janky
```
