A self-made tool that works as a cron job to check for updates on apps by essentially scraping the website. You can define the patterns in the database and the tool will download the updates if there are any.
Why this? I am too lazy to keep track all the software I am using from video players to OS images to GPU drivers. This tool just help me check for updates everyday. If there is, it will download the latest release.
The tool is written in plain Java, probably it'd be better to refactor it with Selenium to get past all sorts of captcha and shit.
Nowadays there are all kinds of AI agents boasting similar functionalities, maybe worth a try? Well I am too lazy now.

It needs a postgres database to store all apps to scrape and their scraping rules. Maybe a local SQLite instance is better?

```
  app-updater-database:
    container_name: app-updater-database
    image: postgres
    restart: always
    ports:
    - ${APP_UPDATER_DB_PORT}:5432
    environment:
      POSTGRES_DB: ${APP_UPDATER_DB_NAME}
      POSTGRES_USER: ${APP_UPDATER_DB_USER}
      POSTGRES_PASSWORD: ${APP_UPDATER_DB_PASSWORD}
    volumes:
    - /apps/app-updater/db/pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${APP_UPDATER_DB_USER} -d ${APP_UPDATER_DB_NAME}"]
      interval: 1s
      timeout: 5s
      retries: 10
    labels:
      glance.parent: App Updater
      glance.name: App Updater DB

  app-updater:
    container_name: app-updater
    image: kamarkaka4/app-updater:1.0.0
    restart: always
    depends_on:
    - app-updater-database
    environment:
      TZ: America/New_York
      DB_HOST: ${APP_UPDATER_DB_HOST}
      DB_PORT: ${APP_UPDATER_DB_PORT}
      DB_NAME: ${APP_UPDATER_DB_NAME}
      DB_USER: ${APP_UPDATER_DB_USER}
      DB_PASSWORD: ${APP_UPDATER_DB_PASSWORD}
      mail.smtp.host: ${MAIL_SMTP_HOST}
      mail.smtp.port: ${MAIL_SMTP_PORT}
      mail.smtp.username: ${MAIL_SMTP_USERNAME}
      mail.smtp.password: ${MAIL_SMTP_PASSWORD}
    volumes:
    - /mnt/backup-02/downloads:/output/
    labels:
      glance.id: App Updater
      glance.name: App Updater
      glance.icon: di:code
```
