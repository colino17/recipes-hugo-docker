# Recipes
A recipe site using [HUGO](https://gohugo.io/) and a modified version of the [SummerQRemix theme](https://github.com/mipmip/summer-qremix). This container is used to generate and update the site, and along with the Docker Compose example below, can be deployed with a [Lighttpd Webserver](https://www.lighttpd.net) and a [Traefik Reverse Proxy](https://traefik.io/traefik/).

# Docker Compose Stack
Below is an example docker compose stack for this container as well as a lightweight webserver with Traefik labels for reverse proxying. The key items to modify are as follows:

- The BASEURL environment variable should be modified to the domain you wish to access the site from. The same modifications must be made to the URL in the Traefik labels.
- The SITE_TITLE environment variable can be modified to add custom text to the top of the site. By default, without setting this variable, this will just read "Recipes".
- Volume paths should be modified to suit your needs. The content volume path can be excluded entirely to use the included recipes. For custom recipes you will need to fork and modify the repo, or populate the content volume path with your own data.
- The networks should be modified to whatever docker network your Traefik instance is on. The docker labels also need to be modified to match.

```yaml
  recipes_hugo:
    image: ghcr.io/colino17/recipes-hugo-docker:latest
    container_name: recipes_hugo
    restart: always
    networks:
      - proxy
    environment:
      - BASEURL=https://recipes.example.com
      - SITE_TITLE=My Cool Recipe Site
    volumes:
      - /path/to/recipe/content:/site/content/recipe
      - /path/to/generated/site:/site/public
  recipes_web:
    image: rtsp/lighttpd:latest
    container_name: recipes_web
    restart: always
    networks:
      - proxy
    volumes:
      - /path/to/generated/site:/var/www/html:ro
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.recipes.entrypoints=http"
      - "traefik.http.routers.recipes.rule=Host(`https://recipes.example.com`)"
      - "traefik.http.middlewares.recipes-https-redirect.redirectscheme.scheme=https"
      - "traefik.http.routers.recipes.middlewares=recipes-https-redirect"
      - "traefik.http.routers.recipes-secure.entrypoints=https"
      - "traefik.http.routers.recipes-secure.rule=Host(`https://recipes.example.com`)"
      - "traefik.http.routers.recipes-secure.tls=true"
      - "traefik.http.routers.recipes-secure.service=recipes"
      - "traefik.http.services.recipes.loadbalancer.server.port=80"
      - "traefik.docker.network=proxy"
```
