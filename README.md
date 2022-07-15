# xxstats

Polkastats block explorer for [xx-network](https://xx.network/)

## Dependencies

In Ubuntu 20.04 server you can do:

```
apt update && apt upgrade -y && apt autoremove -y
apt install -y git build-essential apt-transport-https ca-certificates gpg-agent curl software-properties-common libpq-dev

# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt update
apt install -y docker-ce

# docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# node v16
curl -fsSL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh
bash nodesource_setup.sh
apt install -y nodejs

# yarn
npm install --global yarn
```

## Install

Install mono-repo:

```
cd /usr/local/
git clone https://github.com/xx-labs/xxstats.git
cd xxstats
yarn
```

### Backend

Before build dockers we need to copy and edit an `.env` file:

```
cp backend/.env-sample backend/.env
```

NOTE: change Hasura password in `HASURA_GRAPHQL_ADMIN_SECRET` environmment variable. Also you can add your Sentry instance URL.

```
yarn workspace backend docker:xx-network
```

That will build and start all the required dockers:

- PostgreSQL
- Hasura GraphQL server
- Parity Polkadot client
- Node.js crawler

### Hasura console

After that you can access to Hasura console at http://server_ip_address:8082 and login as admin using the password you previously set in `HASURA_GRAPHQL_ADMIN_SECRET` environment variable.

### Nginx configuration

You can use Nginx as a inverse proxy for Hasura GraphQL and also to serve the static frontend.

Example nginx config `/etc/nginx/sites-available/default` with SSL enabled using Certbot:

```
server {
    root /usr/local/xxstats/frontend/dist;
    index index.html index.htm index.nginx-debian.html;
    server_name yourdomain.io;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /graphql {
        proxy_pass http://localhost:8082/v1/graphql;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    location ~ ^/api/ {
        proxy_pass http://localhost:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    listen [::]:443 ssl ipv6only=on; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/yourdomain.io/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.io/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
}

server {
    if ($host = yourdomain.io) {
        return 301 https://$host$request_uri;
    } # managed by Certbot
        listen 80 default_server;
        listen [::]:80 default_server;
        server_name yourdomain.io;
    return 404; # managed by Certbot
}
```

Apply your new configuration:

```
ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
systemctl restart nginx
```

### Frontend

First, copy the frontend config file:

```
cp frontend/frontend.config-xx-network.js frontend/frontend.config.js
```

Start a dev frontend with hot reload at http://localhost:3000

```
yarn workspace frontend dev
```

Generate a static build under `frontend/dist` directory:

```
yarn workspace frontend generate
```