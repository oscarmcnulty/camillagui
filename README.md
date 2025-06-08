```
docker build -t camillagui:latest .
docker run -p 5005:5005 -e CAMILLA_HOST=my.home.net -e CAMILLA_PORT=49123 camillagui:latest
```