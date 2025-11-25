"""
Database helper functions for SQLite operations.
"""
import sqlite3
from pathlib import Path

DB_FILE = "school.db"

def get_conn():
    """
    Returns a SQLite connection with row_factory and foreign keys enabled.
    """
    conn = sqlite3.connect(DB_FILE)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON;")
    return conn

def exec_script(sql):
    """
    Execute a multi-statement SQL script (DDL/DML).
    """
    with get_conn() as conn:
        conn.executescript(sql)
        conn.commit()

def exec_query(query, params=(), fetch=False, many=False):
    """
    Execute a single query.
    - fetch=True: return all rows as list of dicts
    - fetch=False: just commit (INSERT/UPDATE/DELETE)
    - many=True: use executemany
    """
    with get_conn() as conn:
        cur = conn.cursor()
        if many:
            cur.executemany(query, params)
        else:
            cur.execute(query, params)
        conn.commit()
        
        if fetch:
            rows = cur.fetchall()
            return [dict(row) for row in rows]
        return None

def drop_all():
    """
    Drop all tables in safe dependency order (children first).
    Temporarily disable foreign keys for safety.
    """
    script = """
    PRAGMA foreign_keys = OFF;
    
    DROP TABLE IF EXISTS txn;
    DROP TABLE IF EXISTS entitlement;
    DROP TABLE IF EXISTS match_player_stats;
    DROP TABLE IF EXISTS match_player;
    DROP TABLE IF EXISTS team;
    DROP TABLE IF EXISTS match_game;
    DROP TABLE IF EXISTS character_ability;
    DROP TABLE IF EXISTS game_character;
    DROP TABLE IF EXISTS ability;
    DROP TABLE IF EXISTS item;
    DROP TABLE IF EXISTS game_role;
    DROP TABLE IF EXISTS player;
    
    PRAGMA foreign_keys = ON;
    """
    exec_script(script)

def create_all():
    """
    Create all tables by reading schema_sqlite.sql.
    """
    schema_path = Path(__file__).parent / "schema_sqlite.sql"
    with open(schema_path, 'r') as f:
        schema_sql = f.read()
    exec_script(schema_sql)

def seed_all():
    """
    Seed all tables by reading seed_sqlite.sql.
    """
    seed_path = Path(__file__).parent / "seed_sqlite.sql"
    with open(seed_path, 'r') as f:
        seed_sql = f.read()
    exec_script(seed_sql)

def get_tables():
    """
    Get list of all table names in the database.
    """
    query = """
    SELECT name FROM sqlite_master 
    WHERE type='table' 
    AND name NOT LIKE 'sqlite_%'
    ORDER BY name;
    """
    rows = exec_query(query, fetch=True)
    return [row['name'] for row in rows] if rows else []

def select_all(table_name):
    """
    Select all rows from a given table.
    WARNING: table_name is not parameterized - use only with trusted input.
    """
    # Validate table name exists to prevent SQL injection
    tables = get_tables()
    if table_name not in tables:
        return []
    
    query = f"SELECT * FROM {table_name} LIMIT 100;"
    return exec_query(query, fetch=True)

# ============= PLAYER CRUD =============

def get_all_players():
    """Get all players."""
    return exec_query("SELECT * FROM player ORDER BY player_id;", fetch=True)

def get_player_by_id(player_id):
    """Get a single player by ID."""
    rows = exec_query("SELECT * FROM player WHERE player_id = ?;", (player_id,), fetch=True)
    return rows[0] if rows else None

def insert_player(display_name, email, password_hash, rank_mmr=1000):
    """Insert a new player."""
    query = """
    INSERT INTO player (display_name, email, password_hash, rank_mmr)
    VALUES (?, ?, ?, ?);
    """
    exec_query(query, (display_name, email, password_hash, rank_mmr))

def update_player(player_id, display_name, email, password_hash, rank_mmr):
    """Update an existing player."""
    query = """
    UPDATE player 
    SET display_name = ?, email = ?, password_hash = ?, rank_mmr = ?
    WHERE player_id = ?;
    """
    exec_query(query, (display_name, email, password_hash, rank_mmr, player_id))

def delete_player(player_id):
    """Delete a player by ID."""
    exec_query("DELETE FROM player WHERE player_id = ?;", (player_id,))

# ============= GAME_ROLE CRUD =============

def get_all_roles():
    """Get all game roles."""
    return exec_query("SELECT * FROM game_role ORDER BY role_id;", fetch=True)

def get_role_by_id(role_id):
    """Get a single role by ID."""
    rows = exec_query("SELECT * FROM game_role WHERE role_id = ?;", (role_id,), fetch=True)
    return rows[0] if rows else None

def insert_role(name, description=""):
    """Insert a new game role."""
    query = "INSERT INTO game_role (name, description) VALUES (?, ?);"
    exec_query(query, (name, description))

def update_role(role_id, name, description):
    """Update an existing game role."""
    query = "UPDATE game_role SET name = ?, description = ? WHERE role_id = ?;"
    exec_query(query, (name, description, role_id))

def delete_role(role_id):
    """Delete a game role by ID."""
    exec_query("DELETE FROM game_role WHERE role_id = ?;", (role_id,))

# ============= MATCH QUERIES =============

def get_all_matches():
    """Get all matches."""
    return exec_query("SELECT * FROM match_game ORDER BY match_id DESC;", fetch=True)

def get_match_details(match_id):
    """Get detailed match information with teams and players."""
    # Get match info
    match_query = "SELECT * FROM match_game WHERE match_id = ?;"
    matches = exec_query(match_query, (match_id,), fetch=True)
    
    if not matches:
        return None
    
    # Get players in match with their character and stats
    players_query = """
    SELECT 
        mp.match_player_id,
        mp.player_id,
        p.display_name,
        mp.character_id,
        gc.name as character_name,
        mp.result,
        t.team_label,
        mps.kills,
        mps.deaths,
        mps.assists,
        mps.damage_dealt,
        mps.healing_done
    FROM match_player mp
    JOIN player p ON mp.player_id = p.player_id
    JOIN game_character gc ON mp.character_id = gc.character_id
    JOIN team t ON mp.team_id = t.team_id
    LEFT JOIN match_player_stats mps ON mp.match_player_id = mps.match_player_id
    WHERE mp.match_id = ?
    ORDER BY t.team_label, p.display_name;
    """
    players = exec_query(players_query, (match_id,), fetch=True)
    
    return {
        'match': matches[0],
        'players': players
    }

# ============= ITEM & ENTITLEMENT QUERIES =============

def get_all_items():
    """Get all items."""
    return exec_query("SELECT * FROM item ORDER BY item_id;", fetch=True)

def get_all_entitlements():
    """Get all entitlements with player and item details."""
    query = """
    SELECT 
        e.entitlement_id,
        e.player_id,
        p.display_name,
        e.item_id,
        i.name as item_name,
        e.quantity,
        e.status,
        e.acquired_at
    FROM entitlement e
    JOIN player p ON e.player_id = p.player_id
    JOIN item i ON e.item_id = i.item_id
    ORDER BY e.entitlement_id DESC;
    """
    return exec_query(query, fetch=True)

def grant_entitlement(player_id, item_id, quantity=1):
    """Grant an item to a player (create entitlement and transaction)."""
    # Insert entitlement
    ent_query = """
    INSERT INTO entitlement (player_id, item_id, quantity, status)
    VALUES (?, ?, ?, 'active');
    """
    exec_query(ent_query, (player_id, item_id, quantity))
    
    # Log transaction
    txn_query = """
    INSERT INTO txn (player_id, item_id, currency, amount, quantity, source)
    VALUES (?, ?, 'GC', 0, ?, 'admin_grant');
    """
    exec_query(txn_query, (player_id, item_id, quantity))

# ============= PLAYER PROFILE QUERIES =============

def search_players(search_term):
    """Search for players by display name or email."""
    query = """
    SELECT player_id, display_name, email, rank_mmr, created_at
    FROM player
    WHERE display_name LIKE ? OR email LIKE ?
    ORDER BY rank_mmr DESC
    LIMIT 20;
    """
    term = f"%{search_term}%"
    return exec_query(query, (term, term), fetch=True)

def get_player_profile(player_id):
    """Get detailed player profile with statistics."""
    # Get basic player info
    player_query = "SELECT * FROM player WHERE player_id = ?;"
    player = exec_query(player_query, (player_id,), fetch=True)
    
    if not player:
        return None
    
    # Get match statistics
    stats_query = """
    SELECT 
        COUNT(DISTINCT mp.match_id) as total_matches,
        SUM(CASE WHEN mp.result = 'win' THEN 1 ELSE 0 END) as wins,
        SUM(CASE WHEN mp.result = 'loss' THEN 1 ELSE 0 END) as losses,
        CAST(AVG(mps.kills) AS INTEGER) as avg_kills,
        CAST(AVG(mps.deaths) AS INTEGER) as avg_deaths,
        CAST(AVG(mps.assists) AS INTEGER) as avg_assists,
        CAST(AVG(mps.damage_dealt) AS INTEGER) as avg_damage,
        CAST(AVG(mps.healing_done) AS INTEGER) as avg_healing
    FROM match_player mp
    LEFT JOIN match_player_stats mps ON mp.match_player_id = mps.match_player_id
    WHERE mp.player_id = ?;
    """
    stats = exec_query(stats_query, (player_id,), fetch=True)
    
    # Get recent matches
    matches_query = """
    SELECT 
        mg.match_id,
        mg.gamemode,
        mg.started_at,
        gc.name as character_name,
        mp.result,
        mps.kills,
        mps.deaths,
        mps.assists,
        mps.damage_dealt,
        mps.mmr_delta
    FROM match_player mp
    JOIN match_game mg ON mp.match_id = mg.match_id
    JOIN game_character gc ON mp.character_id = gc.character_id
    LEFT JOIN match_player_stats mps ON mp.match_player_id = mps.match_player_id
    WHERE mp.player_id = ?
    ORDER BY mg.started_at DESC
    LIMIT 10;
    """
    matches = exec_query(matches_query, (player_id,), fetch=True)
    
    # Get favorite characters
    characters_query = """
    SELECT 
        gc.name as character_name,
        COUNT(*) as times_played,
        SUM(CASE WHEN mp.result = 'win' THEN 1 ELSE 0 END) as wins
    FROM match_player mp
    JOIN game_character gc ON mp.character_id = gc.character_id
    WHERE mp.player_id = ?
    GROUP BY gc.character_id
    ORDER BY times_played DESC
    LIMIT 5;
    """
    characters = exec_query(characters_query, (player_id,), fetch=True)
    
    return {
        'player': player[0],
        'stats': stats[0] if stats else {},
        'matches': matches,
        'characters': characters
    }

# ============= GAME DATA QUERIES =============

def get_all_characters():
    """Get all characters with their roles and stats."""
    query = """
    SELECT 
        gc.character_id,
        gc.name,
        gr.name as role_name,
        gc.base_health,
        gc.attack_power,
        gc.attack_speed
    FROM game_character gc
    JOIN game_role gr ON gc.role_id = gr.role_id
    ORDER BY gr.name, gc.name;
    """
    return exec_query(query, fetch=True)

def get_character_details(character_id):
    """Get detailed character information with abilities."""
    # Get character info
    char_query = """
    SELECT 
        gc.character_id,
        gc.name,
        gr.name as role_name,
        gr.description as role_description,
        gc.base_health,
        gc.attack_power,
        gc.attack_speed
    FROM game_character gc
    JOIN game_role gr ON gc.role_id = gr.role_id
    WHERE gc.character_id = ?;
    """
    character = exec_query(char_query, (character_id,), fetch=True)
    
    if not character:
        return None
    
    # Get character abilities
    abilities_query = """
    SELECT 
        a.ability_id,
        a.name,
        a.type,
        a.power,
        a.cooldown_s,
        ca.slot
    FROM character_ability ca
    JOIN ability a ON ca.ability_id = a.ability_id
    WHERE ca.character_id = ?
    ORDER BY 
        CASE ca.slot 
            WHEN 'primary' THEN 1 
            WHEN 'secondary' THEN 2 
            WHEN 'tertiary' THEN 3 
        END;
    """
    abilities = exec_query(abilities_query, (character_id,), fetch=True)
    
    # Get play statistics
    stats_query = """
    SELECT 
        COUNT(DISTINCT mp.match_id) as times_played,
        SUM(CASE WHEN mp.result = 'win' THEN 1 ELSE 0 END) as wins,
        SUM(CASE WHEN mp.result = 'loss' THEN 1 ELSE 0 END) as losses,
        CAST(AVG(mps.kills) AS INTEGER) as avg_kills,
        CAST(AVG(mps.deaths) AS INTEGER) as avg_deaths,
        CAST(AVG(mps.assists) AS INTEGER) as avg_assists,
        CAST(AVG(mps.damage_dealt) AS INTEGER) as avg_damage
    FROM match_player mp
    LEFT JOIN match_player_stats mps ON mp.match_player_id = mps.match_player_id
    WHERE mp.character_id = ?;
    """
    stats = exec_query(stats_query, (character_id,), fetch=True)
    
    return {
        'character': character[0],
        'abilities': abilities,
        'stats': stats[0] if stats else {}
    }

