# Kubernetes Sample React JS App

## Steps to Build

1. Run `docker build .`
1. Run

    ```bash
    docker run -p 8080:3000 \
    --env REACT_APP_BG_COLOR=<color of choice> <image hash from build command>
    ```

1. Navigate your browser to `http://localhost:8080`
