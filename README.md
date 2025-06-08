## Usage

```bash
docker run -p 5005:5005 \
  -e CAMILLA_HOST=<your_host_or_ip> \
  -e CAMILLA_PORT=<your_port> \
  ghcr.io/oscarmcnulty/camillagui:latest
```


## Development

```
docker build --build-arg UPSTREAM_VERSION=$(cat UPSTREAM_VERSION) -t camillagui:latest .
docker run -p 5005:5005 -e CAMILLA_HOST=my.home.net -e CAMILLA_PORT=49123 camillagui:latest
```