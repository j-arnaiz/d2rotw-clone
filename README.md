# D2 DClone Monitor

A Rails + Sidekiq app that polls the [diablo2.io](https://diablo2.io) API every minute to track Diablo Clone (Über Diablo) walk progress across all regions and sends Telegram notifications when the progress changes.

## Features

- Polls diablo2.io every minute via a Sidekiq cron job
- Tracks progress per region (Americas, Europe, Asia)
- Sends Telegram alerts when progress changes, with a special warning when DClone is walking (6/6)
- Simple dashboard showing current progress for all regions
- Sidekiq Web UI available at `/sidekiq`

## Requirements

- Docker and Docker Compose

## Setup

### 1. Copy the environment file

```bash
cp .env.example .env
```

### 2. Configure `.env`

Edit `.env` and fill in the required values:

```dotenv
# Redis (leave as-is when using Docker Compose)
REDIS_URL=redis://redis:6379/0

# Diablo 2 API parameters
D2_LADDER=1   # 1=Ladder, 2=Non-Ladder
D2_HC=2       # 1=Softcore, 2=Hardcore
D2_VER=2      # Game version

# Telegram
TELEGRAM_BOT_TOKEN=<your_bot_token>
TELEGRAM_CHAT_ID=<your_chat_id>

# Web
WEB_PORT=3000
RAILS_ENV=production
RAILS_LOG_TO_STDOUT=true
SECRET_KEY_BASE=<generate below>
```

### 3. Generate a secret key

```bash
docker compose run --rm web bundle exec rails secret
```

Copy the output and set it as `SECRET_KEY_BASE` in `.env`.

### 4. Start the app

```bash
docker compose up --build -d
```

The dashboard will be available at `http://localhost:3000` (or whatever `WEB_PORT` is set to).

## Creating a Telegram Bot

### Step 1 — Create the bot and get the token

1. Open Telegram and search for **@BotFather**.
2. Send `/newbot` and follow the prompts (choose a name and username for your bot).
3. BotFather will reply with your bot token, e.g.:
   ```
   123456789:AAFxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   ```
4. Set this as `TELEGRAM_BOT_TOKEN` in `.env`.

### Step 2 — Get your Chat ID

**For a personal chat:**

1. Send any message to your new bot.
2. Open the following URL in a browser (replace `<TOKEN>` with your bot token):
   ```
   https://api.telegram.org/bot<TOKEN>/getUpdates
   ```
3. Look for `"chat":{"id":...}` in the JSON response. That number is your `TELEGRAM_CHAT_ID`.

**For a group chat:**

1. Add the bot to the group.
2. Send a message in the group mentioning the bot or any message.
3. Call `getUpdates` as above — the `id` under `"chat"` will be a negative number (e.g., `-1001234567890`).

4. Set `TELEGRAM_CHAT_ID` in `.env`.

## Stopping

```bash
docker compose down
```

To also remove stored Redis data:

```bash
docker compose down -v
```

## Architecture

| Service  | Description                                      |
|----------|--------------------------------------------------|
| `web`    | Rails/Puma server serving the dashboard          |
| `worker` | Sidekiq worker running the DClone polling cron   |
| `redis`  | State store (progress values) and Sidekiq broker |
