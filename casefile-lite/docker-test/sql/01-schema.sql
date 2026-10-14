-- Casefile Lite schema (same as casefile-lite/sql/casefile.sql).
-- Auto-loaded by MariaDB on first container start.

CREATE TABLE IF NOT EXISTS casefile_events (
  id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  ts         INT UNSIGNED    NOT NULL,
  actor_id   VARCHAR(64)     NOT NULL,
  actor_name VARCHAR(64)     NULL,
  category   VARCHAR(24)     NOT NULL,
  action     VARCHAR(48)     NOT NULL,
  target_id  VARCHAR(64)     NULL,
  amount     BIGINT          NULL,
  serial     VARCHAR(64)     NULL,
  detail     JSON            NULL,
  source     VARCHAR(24)     NOT NULL DEFAULT 'core',
  PRIMARY KEY (id),
  INDEX idx_actor (actor_id),
  INDEX idx_ts (ts),
  INDEX idx_category (category),
  INDEX idx_serial (serial)
);

CREATE TABLE IF NOT EXISTS casefile_identities (
  person_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  license   VARCHAR(64)  NULL,
  license2  VARCHAR(64)  NULL,
  steam     VARCHAR(64)  NULL,
  discord   VARCHAR(64)  NULL,
  ip        VARCHAR(64)  NULL,
  hwid      VARCHAR(128) NULL,
  PRIMARY KEY (person_id),
  INDEX idx_license (license),
  INDEX idx_discord (discord)
);
