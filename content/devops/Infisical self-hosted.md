---
title: Deploy a self-hosted version of Infisical
publish: true
tags:
  - infisical
  - secret-management
  - self-hosted
  - nginx
---
[Infisical](https://infisical.com/) is a great platform to manage secrets across a team and an infrastructure.
It has a great free plan to start using its features, but it can quickly become limited (especially with the maximum of 3 projects).

While it's open-source with a documentation explaining how to run a self-hosted instance, I had to make a few tweaks to get the result I wanted, which are sum up in this guide.

## Prerequisites

To get started, you'll need:
- A server with at least 2 GB of RAM available (recommended in the [documentation](https://infisical.com/docs/self-hosting/deployment-options/standalone-infisical#system-requirements), for me it was barely enough and I had to use an instance with 4 GB).
- A domain name/subdomain on which you want to expose the Infisical UI (you'll need access to the DNS records)

## Setup

Let's start by following the [Docker Compose deployment tutorial from the Infisical documentation](https://infisical.com/docs/self-hosting/deployment-options/docker-compose). You'll need to [install Docker & Docker Compose](https://docs.docker.com/engine/install/ubuntu/) on your server and fetch some files from Infisical's GitHub repository.

> [!warning] Just do the installation steps, don't start it yet

Now let's generate our SSL certificate and integrate with the NGINX configuration of Infisical.

> [!info] This part is heavily inspired from this [NGINX Docker with Certbot](https://mpolinowski.github.io/docs/DevOps/NGINX/2020-08-28--nginx-docker-certbot/2020-08-27/) article

First, add an `A` record to your domain name that points to your server.
Then, let's install [`cerbot`](https://certbot.eff.org/) and create our certificate:
```sh
snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot

certbot certonly --standalone
```

Once this is done, we need to mount the generated files (located at `/etc/letsencrypt/archive/YOUR_DOMAIN_NAME/`) as a volume of the NGINX service.

Add the following volume to the service:
```yaml
- /etc/letsencrypt/archive/YOUR_DOMAIN_NAME:/etc/nginx/ssl/YOUR_DOMAIN_NAME:ro
```

Finally, let's update the NGINX config to listen on HTTPS traffic and use our certificate by adding these lines at the top:
```nginx
listen 443 ssl;

ssl_certificate /etc/nginx/ssl/YOUR_DOMAIN_NAME/fullchain1.pem;
ssl_certificate_key /etc/nginx/ssl/YOUR_DOMAIN_NAME/privkey1.pem;
```

One last optional thing before starting Infisical, you can update the `.env` file depending on what you want, for example I'm settings these variables:
```text
TELEMETRY_ENABLED=false
INVITE_ONLY_SIGNUP=true
```

And you're good to go 🚀
```sh
docker compose up -d
```
