# `nginx` role

Deploys a dedicated nginx container for the phrase app.

- Uses Podman with `nginxinc/nginx-unprivileged` image.
- Publishes host `80` to container `8080`.
- Renders a vhost returning `200 "Phrase is up"` for `GET /phrase`.
