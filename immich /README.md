It is relatively easy to set most things up, but it took me a while to get my GPU working with immich-maching-learning for face detection/recognition. The GPU setups should be the same as Jellyfin.
One thing to note is that be careful about the parallelization parameter for face detection/recognition, I've hit errors for not having enough VRAM when turning the number too high. Use `nvtop` to monitor your GPU usage while running the tasks.

```
  immich-server:
    container_name: immich-server
    image: ghcr.io/immich-app/immich-server:release
    restart: unless-stopped
    user: 1000:1001
    ports:
    - 30005:2283
    # extends:
    #   file: hwaccel.transcoding.yml
    #   service: cpu # set to one of [nvenc, quicksync, rkmpp, vaapi, vaapi-wsl] for accelerated transcoding
    volumes:
    # Do not edit the next line. If you want to change the media storage location on your system, edit the value of UPLOAD_LOCATION in the .env file
    - /etc/localtime:/etc/localtime:ro
    - /apps/immich/library:/usr/src/app/upload
    - /mnt/backup-01/Photos:/mnt/photo
    - /mnt/backup-01/Pictures:/mnt/picture
    depends_on:
    - immich-redis
    - immich-database
    healthcheck:
      disable: false
    environment:
      DB_URL: postgresql://postgres:postgres@immich_postgres:5432/immich
      REDIS_URL: ioredis://eyJob3N0IjoiaW1taWNoX3JlZGlzIiwicG9ydCI6NjM3OSwiZGIiOjB9 #echo -n '{"host":"immich_redis","port":6379,"db":0}' | base64
    labels:
      glance.name: Immich
      glance.icon: di:immich
      glance.url: https://immich.${DNS_DOMAIN}
      glance.description: High performance self-hosted photo and video management solution

  immich-redis:
    container_name: immich_redis
    image: docker.io/valkey/valkey:8-bookworm@sha256:42cba146593a5ea9a622002c1b7cba5da7be248650cbb64ecb9c6c33d29794b1
    restart: unless-stopped
    healthcheck:
      test: redis-cli ping || exit 1
    labels:
      glance.name: Immich Redis
      glance.icon: di:immich

  immich-database:
    container_name: immich_postgres
    image: docker.io/tensorchord/pgvecto-rs:pg14-v0.2.0@sha256:739cdd626151ff1f796dc95a6591b55a714f341c737e27f045019ceabf8e8c52
    restart: unless-stopped
    environment:
      POSTGRES_PASSWORD: postgres
      POSTGRES_USER: postgres
      POSTGRES_DB: immich
      POSTGRES_INITDB_ARGS: '--data-checksums'
    volumes:
    # Do not edit the next line. If you want to change the database storage location on your system, edit the value of DB_DATA_LOCATION in the .env file
    - /apps/immich/postgres/data:/var/lib/postgresql/data
    healthcheck:
      test: >-
        pg_isready --dbname="$${POSTGRES_DB}" --username="$${POSTGRES_USER}" || exit 1; Chksum="$$(psql --dbname="$${POSTGRES_DB}" --username="$${POSTGRES_USER}" --tuples-only --no-align --command='SELECT COALESCE(SUM(checksum_failures), 0) FROM pg_stat_database')"; echo "checksum failure count is $$Chksum"; [ ">
      interval: 5m
      start_interval: 30s
      start_period: 5m
    command: >-
      postgres -c shared_preload_libraries=vectors.so -c 'search_path="$$user", public, vectors' -c logging_collector=on -c max_wal_size=2GB -c shared_buffers=512MB -c wal_compression=on
    labels:
      glance.name: Immich DB
      glance.icon: di:immich

  immich-machine-learning:
    container_name: immich-machine-learning
    # For hardware acceleration, add one of -[armnn, cuda, rocm, openvino, rknn] to the image tag.
    # Example tag: ${IMMICH_VERSION:-release}-openvino
    image: ghcr.io/immich-app/immich-machine-learning:release-cuda
    deploy:
      resources:
        reservations:
          devices:
          - driver: nvidia
            count: 1
            capabilities:
            - gpu
    restart: unless-stopped
    extends: # uncomment this section for hardware acceleration - see https://immich.app/docs/features/ml-hardware-acceleration
      file: hwaccel.ml.yml
      service: cuda # set to one of [armnn, cuda, rocm, openvino, openvino-wsl, rknn] for accelerated inference - use the `-wsl` version for WSL2 where applicable
    volumes:
    - /apps/immich/cache:/cache
    labels:
      glance.name: Immich Machine Learning
      glance.icon: di:immich
```
