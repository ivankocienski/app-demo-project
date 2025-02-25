FROM postgres:17

# USER 1000:1000

ENV POSTGRES_PASSWORD=password

EXPOSE 5432


#  db:
#    image: postgres:17
#    user: "1000:1000"
#    environment:
#      POSTGRES_PASSWORD: ${DB_PASSWORD}
#      POSTGRES_HOST: ${HOST_ADDRESS}
#    expose:
#      - ${DB_PORT}
#    ports:
#      - "${DB_PORT}:${DB_PORT}"
#    volumes:
#      - ./db/data:/var/lib/postgresql/data
#      - ./db/init.d:/docker-entrypoint-initdb.d
#    healthcheck:
#      test: ["CMD-SHELL", "pg_isready -U postgres -d postgres"]
#      interval: 10s
#      retries: 5
#      start_period: 30s
#      timeout: 10s
