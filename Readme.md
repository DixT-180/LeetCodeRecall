# LeetCode Recall App

A Django app that tracks which LeetCode problems you've solved, how well you
understood them, and tells you which ones to review next using a
spaced-repetition-style forgetting model.

---

## 1. Prerequisites

- Docker + Docker Compose installed
- Ports **8000** and **3306** free on the host machine (the compose file uses
  `network_mode: host` for both services, so they bind directly to host ports,
  not container ports)

---

## 2. Build the app image

The compose file references an image (`leetcode-app:latest`) rather than
building it inline, so build it first from the `Dockerfile`:

```bash
docker build -t leetcode-app:latest .
```

---

## 3. Configure `app.env`

`app.env` may currently look like this:

```
DB_NAME=recall_app
DB_USER=root
DB_PASSWORD=1234
DB_HOST=127.0.0.1
DB_PORT=3306

MYSQL_DATABASE=recall_app
MYSQL_ROOT_PASSWORD=1234
```

- `MYSQL_DATABASE` / `MYSQL_ROOT_PASSWORD` are read by the official `mysql:8.0`
  image on first startup — it will auto-create that database and set the
  root password to that value.
- `DB_NAME` / `DB_USER` / `DB_PASSWORD` / `DB_HOST` / `DB_PORT` are there for
  Django to use, but **`settings.py` currently has the DB connection
  hardcoded** (`root` / `1234` / `localhost` / `3306`) rather than reading
  these variables. So, out of the box, whatever you put in `app.env` for
  `DB_USER`/`DB_PASSWORD` won't actually change what Django connects as —
  it'll still connect as `root`/`1234`. Keep that in mind if you create a
  dedicated DB user in step 5: Django itself will keep using `root` unless
  `settings.py`'s `DATABASES` block is updated to match. Update the values
  in `app.env` anyway, so they're correct for when that's wired up.

---

## 4. Start only the database first

```bash
docker compose up -d db
```

Give it a few seconds to initialize (first boot creates the `recall_app`
database and sets the root password from `app.env`).

---

## 5. Create a database + a dedicated user (recommended)

Exec into the running MySQL container using the compose service name:

```bash
docker compose exec db mysql -u root -p
```

Enter the password from `MYSQL_ROOT_PASSWORD` in `app.env` (`1234` by
default) when prompted.

Now, inside the MySQL prompt, create the database (if it doesn't already
exist) and a user with full read/write/manage access to just that database:

```sql
CREATE DATABASE IF NOT EXISTS recall_app;

CREATE USER 'recall_user'@'%' IDENTIFIED BY 'choose_a_strong_password';

-- Full rights on recall_app only (not on other databases).
-- Includes DDL grants (CREATE/ALTER/INDEX/DROP) since Django migrations
-- need to create and modify tables, not just read/write rows.
GRANT ALL PRIVILEGES ON recall_app.* TO 'recall_user'@'%';

FLUSH PRIVILEGES;
EXIT;
```

Then update `app.env` with the new credentials:

```
DB_NAME=recall_app
DB_USER=recall_user
DB_PASSWORD=choose_a_strong_password
DB_HOST=127.0.0.1
DB_PORT=3306
```

(See the note in step 3 — for Django to actually use `recall_user` instead
of `root`, the `DATABASES` block in `settings.py` needs to reference these
values instead of the hardcoded ones.)

---

## 6. Start the full stack

```bash
docker compose up -d
```

The `web` service sleeps 19 seconds before launching Django, to give MySQL
time to finish initializing.

Check logs if needed:

```bash
docker compose logs -f web
```

---

## 7. Run migrations

```bash
docker compose exec web python manage.py migrate
```


```bash
docker compose exec web python manage.py makemigrations recall_app
```

```bash
docker compose exec web python manage.py migrate recall_app
```


---

## 8. Seed the problem catalog: use the recall_app_problem dump to load the LeetCode problems into your database:

1. Copy the SQL dump into the MySQL container
```bash

docker cp recall_app_problem.sql leetcoderecall-db-1:/opt/recall_app_problem.sql

```

2. Import into the new database

```bash
docker exec -it leetcoderecall-db-1 mysql -u root -p
```

3. Enter your MySQL root password, then run:

```bash
CREATE DATABASE IF NOT EXISTS recall_app;
USE recall_app;
SOURCE /opt/recall_app_problem.sql;
```

4. Verify the imported table
```bash
SHOW TABLES;
SELECT COUNT(*) FROM recall_app_problem;
DESCRIBE recall_app_problem;
```

Run on the host:

  ```bash
docker compose exec web python manage.py createsuperuser
```

## 9. (Optional) Create an admin user

```bash
docker compose exec web python manage.py createsuperuser
```


## 10. Use the app

Visit **http://localhost:8000/** (or the host's IP, since networking is set
to `host` mode), register an account, and start logging reviews.

---

## How the app works

The app is a self-tracking tool for LeetCode practice, built around a simple
idea: **the problems you understood the least, and haven't touched in a
while, are the ones you're most likely to forget — so those should surface
first.**

**1. Logging a review**
Every time you revisit a problem, you rate your understanding (roughly 1–5)
and optionally save notes or a solution. Each rating is stored both on the
`ProblemReview` (your current/latest state for that problem) and appended to
`ReviewHistory` (a full log over time).

**2. Turning history into a score**
For each problem, the recommendation engine looks at:
- your **current** understanding rating (most recent review),
- your **average** understanding across all past reviews for that problem,
- how **many times** you've reviewed it, and
- how many **days** have passed since you last reviewed it.

**3. Modeling forgetting**
These are fed into a formula modeled loosely on spaced-repetition "forgetting
curves" (similar in spirit to apps like Anki):
- A blended understanding score is computed (recent performance weighted
  against your history).
- That converts into a **base retention** estimate and an **effective
  half-life** — problems you understand well and have reviewed often get a
  longer half-life (you're assumed to retain them longer without practice).
- Retention is then decayed exponentially based on days-since-last-review
  against that half-life — the longer it's been, the lower your estimated
  current retention.

**4. Prioritizing what to review**
Two numbers come out of that: an **understanding gap** (how far you are from
full mastery) and a **forgetting risk** (how much retention has likely
decayed since you last practiced). These are combined into a single
**priority score**, weighted 60% toward understanding gap and 40% toward
forgetting risk. The home page shows your problems sorted by priority,
highest first — effectively, "review this one next."

Each problem also gets a plain-language **recommendation** label (e.g.
"REVIEW – improve understanding" if your understanding is still low, or
"REVIEW – retention is low" if enough time has passed that you've likely
forgotten it, or "NOT RECOMMENDED" if neither applies yet).
