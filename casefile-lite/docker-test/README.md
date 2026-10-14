# Casefile — local DB test (Path B)

Proves Casefile's schema + search queries work on a **real MariaDB** (runs natively
on Apple Silicon — no emulation). Does not test the FiveM runtime; that's the VPS step.

## Run it
From Terminal:

```bash
cd ~/Documents/"GTA MODs"/casefile-lite/docker-test

# 1) start MariaDB (first run downloads the image, ~1 min). Loads the schema automatically.
docker compose up -d

# 2) wait ~15s for the database to finish initializing, then run the test
docker compose exec -T db mariadb -uroot -pcasefiletest casefile < test.sql
```

You should see the event counts and search results print out
(6 captured, 4 for "jay", 3 money, 2 "jay"+money, 1 admin).

## Stop / reset
```bash
docker compose down -v      # stops and wipes the test database
```
To run the test again from a clean slate: `docker compose down -v && docker compose up -d` then re-run step 2.

## Notes
- The "Using a password on the command line interface can be insecure" warning is harmless (local test DB).
- Host port is 3307 so it won't clash with any MySQL you already run.
