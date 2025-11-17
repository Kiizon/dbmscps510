PRAGMA foreign_keys = ON;

-- PLAYER
CREATE TABLE IF NOT EXISTS player (
  player_id     INTEGER PRIMARY KEY,
  display_name  TEXT NOT NULL UNIQUE,
  email         TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  rank_mmr      INTEGER NOT NULL DEFAULT 1000,
  created_at    TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- GAME ROLE
CREATE TABLE IF NOT EXISTS game_role (
  role_id     INTEGER PRIMARY KEY,
  name        TEXT NOT NULL UNIQUE,
  description TEXT
);

-- GAME CHARACTER
CREATE TABLE IF NOT EXISTS game_character (
  character_id INTEGER PRIMARY KEY,
  name         TEXT NOT NULL UNIQUE,
  role_id      INTEGER NOT NULL,
  base_health  INTEGER NOT NULL CHECK (base_health >= 1),
  attack_power INTEGER NOT NULL CHECK (attack_power >= 0),
  attack_speed REAL NOT NULL CHECK (attack_speed > 0),
  CONSTRAINT fk_gc_role FOREIGN KEY (role_id)
    REFERENCES game_role(role_id)
);

-- ABILITY
CREATE TABLE IF NOT EXISTS ability (
  ability_id  INTEGER PRIMARY KEY,
  name        TEXT NOT NULL UNIQUE,
  type        TEXT NOT NULL,
  power       INTEGER NOT NULL CHECK (power >= 0),
  cooldown_s  INTEGER NOT NULL CHECK (cooldown_s >= 0)
);

-- CHARACTER_ABILITY
CREATE TABLE IF NOT EXISTS character_ability (
  character_id INTEGER NOT NULL,
  ability_id   INTEGER NOT NULL,
  slot         TEXT NOT NULL CHECK (slot IN ('primary','secondary','tertiary')),
  CONSTRAINT pk_character_ability PRIMARY KEY (character_id, ability_id),
  CONSTRAINT uq_character_slot UNIQUE (character_id, slot),
  CONSTRAINT fk_ca_character FOREIGN KEY (character_id)
    REFERENCES game_character(character_id) ON DELETE CASCADE,
  CONSTRAINT fk_ca_ability FOREIGN KEY (ability_id)
    REFERENCES ability(ability_id)
);

-- MATCH (GAME)
CREATE TABLE IF NOT EXISTS match_game (
  match_id   INTEGER PRIMARY KEY,
  gamemode   TEXT NOT NULL,
  started_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ended_at   TEXT
);

-- TEAM
CREATE TABLE IF NOT EXISTS team (
  team_id    INTEGER PRIMARY KEY,
  match_id   INTEGER NOT NULL,
  team_label TEXT NOT NULL,
  CONSTRAINT fk_team_match FOREIGN KEY (match_id)
    REFERENCES match_game(match_id) ON DELETE CASCADE,
  CONSTRAINT uq_team_label_per_match UNIQUE (match_id, team_label)
);

-- MATCH_PLAYER
CREATE TABLE IF NOT EXISTS match_player (
  match_player_id INTEGER PRIMARY KEY,
  match_id        INTEGER NOT NULL,
  team_id         INTEGER NOT NULL,
  player_id       INTEGER NOT NULL,
  character_id    INTEGER NOT NULL,
  result          TEXT NOT NULL CHECK (result IN ('win','loss')),
  CONSTRAINT fk_mp_match FOREIGN KEY (match_id)
    REFERENCES match_game(match_id) ON DELETE CASCADE,
  CONSTRAINT fk_mp_team FOREIGN KEY (team_id)
    REFERENCES team(team_id) ON DELETE CASCADE,
  CONSTRAINT fk_mp_player FOREIGN KEY (player_id)
    REFERENCES player(player_id),
  CONSTRAINT fk_mp_character FOREIGN KEY (character_id)
    REFERENCES game_character(character_id),
  CONSTRAINT uq_player_per_match UNIQUE (match_id, player_id),
  CONSTRAINT uq_character_per_team UNIQUE (team_id, character_id)
);

-- MATCH_PLAYER_STATS
CREATE TABLE IF NOT EXISTS match_player_stats (
  match_player_id INTEGER PRIMARY KEY,
  kills           INTEGER NOT NULL DEFAULT 0 CHECK (kills >= 0),
  deaths          INTEGER NOT NULL DEFAULT 0 CHECK (deaths >= 0),
  assists         INTEGER NOT NULL DEFAULT 0 CHECK (assists >= 0),
  damage_dealt    INTEGER NOT NULL DEFAULT 0 CHECK (damage_dealt >= 0),
  healing_done    INTEGER NOT NULL DEFAULT 0 CHECK (healing_done >= 0),
  abilities_used  INTEGER NOT NULL DEFAULT 0 CHECK (abilities_used >= 0),
  mmr_delta       INTEGER NOT NULL DEFAULT 0,
  CONSTRAINT fk_mps_mp FOREIGN KEY (match_player_id)
    REFERENCES match_player(match_player_id) ON DELETE CASCADE
);

-- ITEM
CREATE TABLE IF NOT EXISTS item (
  item_id  INTEGER PRIMARY KEY,
  name     TEXT NOT NULL,
  category TEXT NOT NULL,
  rarity   TEXT NOT NULL
);

-- ENTITLEMENT
CREATE TABLE IF NOT EXISTS entitlement (
  entitlement_id INTEGER PRIMARY KEY,
  player_id      INTEGER NOT NULL,
  item_id        INTEGER NOT NULL,
  acquired_at    TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  quantity       INTEGER NOT NULL DEFAULT 1 CHECK (quantity >= 0),
  status         TEXT NOT NULL DEFAULT 'active',
  CONSTRAINT fk_ent_player FOREIGN KEY (player_id)
    REFERENCES player(player_id) ON DELETE CASCADE,
  CONSTRAINT fk_ent_item FOREIGN KEY (item_id)
    REFERENCES item(item_id),
  CONSTRAINT uq_nonconsumable UNIQUE (player_id, item_id)
);

-- TRANSACTION (txn)
CREATE TABLE IF NOT EXISTS txn (
  txn_id     INTEGER PRIMARY KEY,
  player_id  INTEGER NOT NULL,
  item_id    INTEGER,
  currency   TEXT NOT NULL DEFAULT 'GC',
  amount     INTEGER NOT NULL,
  quantity   INTEGER NOT NULL DEFAULT 1 CHECK (quantity >= 0),
  source     TEXT NOT NULL DEFAULT 'store',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_txn_player FOREIGN KEY (player_id)
    REFERENCES player(player_id) ON DELETE CASCADE,
  CONSTRAINT fk_txn_item FOREIGN KEY (item_id)
    REFERENCES item(item_id)
);

