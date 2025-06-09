This is a self-made tool to keep track of daily spendings with memory to the now dead mint.com. Nobody should be interested in using this but should rather try firefly III. I wrote this just for the sake of self-abuse.

It has three parts:
- A postgres database that keeps things
- A Java backend running dropwizard as the service layer
- A Svelte app running as frontend

In all seriousness don't use it. It's just for me to learn dropwizard, svelte, docker, and probably some postgres at the same time.

```
  money-tracker-database:
    container_name: money-tracker-database
    image: postgres
    restart: unless-stopped
    ports:
    - ${MONEY_TRACKER_DB_PORT}:5432
    environment:
      POSTGRES_DB: ${MONEY_TRACKER_DB_NAME}
      POSTGRES_USER: ${MONEY_TRACKER_DB_USER}
      POSTGRES_PASSWORD: ${MONEY_TRACKER_DB_PASSWORD}
    volumes:
    - /apps/money-tracker/db/pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${MONEY_TRACKER_DB_USER} -d ${MONEY_TRACKER_DB_NAME}"]
      interval: 1s
      timeout: 5s
      retries: 10
    labels:
      glance.name: Money Tracker DB
      glance.icon: di:google-wallet

  money-tracker-api:
    container_name: money-tracker-api
    image: kamarkaka4/money-tracker-api:1.0.0
    restart: unless-stopped
    ports:
    - 30008:8080
    environment:
      DB_HOST: ${MONEY_TRACKER_DB_HOST}
      DB_PORT: ${MONEY_TRACKER_DB_PORT}
      DB_NAME: ${MONEY_TRACKER_DB_NAME}
      DB_USER: ${MONEY_TRACKER_DB_USER}
      DB_PASSWORD: ${MONEY_TRACKER_DB_PASSWORD}
    volumes:
    - /apps/money-tracker/api/config:/app/config
    labels:
      glance.name: Money Tracker API
      glance.icon: di:google-wallet

  money-tracker-ui:
    container_name: money-tracker-ui
    image: kamarkaka4/money-tracker-ui:1.0.0
    restart: unless-stopped
    ports:
    - 30009:3000
    depends_on:
    - money-tracker-database
    - money-tracker-api
    labels:
      glance.name: Money Tracker
      glance.icon: di:google-wallet
      glance.url: https://money.${DNS_DOMAIN}
      glance.description: Keep track of your spendings
```
