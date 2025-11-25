"""
Flask application for CPS510 DBMS project.
Provides dashboard with table management and CRUD operations.
"""
from flask import Flask, render_template, request, jsonify
import db

app = Flask(__name__)

@app.route('/')
def index():
    """
    Main admin dashboard page.
    """
    return render_template('index.html')

@app.route('/player')
def player_dashboard():
    """
    Player-facing stats and profile search page.
    """
    return render_template('player.html')

@app.route('/drop', methods=['POST'])
def drop():
    """
    Drop all tables.
    """
    try:
        db.drop_all()
        return jsonify({'ok': True, 'message': 'All tables dropped successfully'})
    except Exception as e:
        return jsonify({'ok': False, 'message': str(e)}), 500

@app.route('/create', methods=['POST'])
def create():
    """
    Create all tables from schema.
    """
    try:
        db.create_all()
        return jsonify({'ok': True, 'message': 'All tables created successfully'})
    except Exception as e:
        return jsonify({'ok': False, 'message': str(e)}), 500

@app.route('/seed', methods=['POST'])
def seed():
    """
    Seed all tables with sample data.
    """
    try:
        db.seed_all()
        return jsonify({'ok': True, 'message': 'Database seeded successfully'})
    except Exception as e:
        return jsonify({'ok': False, 'message': str(e)}), 500

@app.route('/tables', methods=['GET'])
def tables():
    """
    Get list of all table names.
    """
    try:
        table_list = db.get_tables()
        return jsonify({'ok': True, 'tables': table_list})
    except Exception as e:
        return jsonify({'ok': False, 'message': str(e)}), 500

@app.route('/query/<table_name>', methods=['GET'])
def query_table(table_name):
    """
    Query all rows from a specific table.
    """
    try:
        rows = db.select_all(table_name)
        return jsonify({'ok': True, 'rows': rows})
    except Exception as e:
        return jsonify({'ok': False, 'message': str(e)}), 500

# ============= PLAYER CRUD =============

@app.route('/players', methods=['GET'])
def get_players():
    """
    Get all players.
    """
    try:
        players = db.get_all_players()
        return jsonify({'ok': True, 'players': players})
    except Exception as e:
        return jsonify({'ok': False, 'message': str(e)}), 500

@app.route('/player/upsert', methods=['POST'])
def upsert_player():
    """
    Insert or update a player.
    If player_id is provided and exists, update; otherwise insert.
    """
    try:
        data = request.get_json() or {}
        player_id = data.get('player_id')
        display_name = data.get('display_name', '').strip()
        email = data.get('email', '').strip()
        password_hash = data.get('password_hash', '').strip()
        rank_mmr = int(data.get('rank_mmr', 1000))
        
        if not display_name or not email or not password_hash:
            return jsonify({'ok': False, 'message': 'Missing required fields'}), 400
        
        if player_id:
            # Update existing player
            db.update_player(player_id, display_name, email, password_hash, rank_mmr)
            message = f'Player {player_id} updated successfully'
        else:
            # Insert new player
            db.insert_player(display_name, email, password_hash, rank_mmr)
            message = 'Player created successfully'
        
        return jsonify({'ok': True, 'message': message})
    except Exception as e:
        return jsonify({'ok': False, 'message': str(e)}), 500

@app.route('/player/delete/<int:player_id>', methods=['POST'])
def delete_player_route(player_id):
    """
    Delete a player by ID.
    """
    try:
        db.delete_player(player_id)
        return jsonify({'ok': True, 'message': f'Player {player_id} deleted successfully'})
    except Exception as e:
        return jsonify({'ok': False, 'message': str(e)}), 500

# ============= GAME_ROLE CRUD =============

@app.route('/roles', methods=['GET'])
def get_roles():
    """
    Get all game roles.
    """
    try:
        roles = db.get_all_roles()
        return jsonify({'ok': True, 'roles': roles})
    except Exception as e:
        return jsonify({'ok': False, 'message': str(e)}), 500

@app.route('/role/upsert', methods=['POST'])
def upsert_role():
    """
    Insert or update a game role.
    If role_id is provided and exists, update; otherwise insert.
    """
    try:
        data = request.get_json() or {}
        role_id = data.get('role_id')
        name = data.get('name', '').strip()
        description = data.get('description', '').strip()
        
        if not name:
            return jsonify({'ok': False, 'message': 'Role name is required'}), 400
        
        if role_id:
            # Update existing role
            db.update_role(role_id, name, description)
            message = f'Role {role_id} updated successfully'
        else:
            # Insert new role
            db.insert_role(name, description)
            message = 'Role created successfully'
        
        return jsonify({'ok': True, 'message': message})
    except Exception as e:
        return jsonify({'ok': False, 'message': str(e)}), 500

@app.route('/role/delete/<int:role_id>', methods=['POST'])
def delete_role_route(role_id):
    """
    Delete a game role by ID.
    """
    try:
        db.delete_role(role_id)
        return jsonify({'ok': True, 'message': f'Role {role_id} deleted successfully'})
    except Exception as e:
        return jsonify({'ok': False, 'message': str(e)}), 500

# ============= MATCH ROUTES =============

@app.route('/matches', methods=['GET'])
def get_matches():
    """
    Get all matches.
    """
    try:
        matches = db.get_all_matches()
        return jsonify({'ok': True, 'matches': matches})
    except Exception as e:
        return jsonify({'ok': False, 'message': str(e)}), 500

@app.route('/match/<int:match_id>/details', methods=['GET'])
def get_match_details(match_id):
    """
    Get detailed information about a specific match.
    """
    try:
        details = db.get_match_details(match_id)
        if not details:
            return jsonify({'ok': False, 'message': 'Match not found'}), 404
        return jsonify({'ok': True, **details})
    except Exception as e:
        return jsonify({'ok': False, 'message': str(e)}), 500

# ============= ITEM & ENTITLEMENT ROUTES =============

@app.route('/items', methods=['GET'])
def get_items():
    """
    Get all items.
    """
    try:
        items = db.get_all_items()
        return jsonify({'ok': True, 'items': items})
    except Exception as e:
        return jsonify({'ok': False, 'message': str(e)}), 500

@app.route('/entitlements', methods=['GET'])
def get_entitlements():
    """
    Get all entitlements with player and item details.
    """
    try:
        entitlements = db.get_all_entitlements()
        return jsonify({'ok': True, 'entitlements': entitlements})
    except Exception as e:
        return jsonify({'ok': False, 'message': str(e)}), 500

@app.route('/entitlement/grant', methods=['POST'])
def grant_entitlement():
    """
    Grant an item to a player.
    """
    try:
        data = request.get_json() or {}
        player_id = data.get('player_id')
        item_id = data.get('item_id')
        quantity = data.get('quantity', 1)
        
        if not player_id or not item_id:
            return jsonify({'ok': False, 'message': 'Player ID and Item ID are required'}), 400
        
        db.grant_entitlement(player_id, item_id, quantity)
        return jsonify({'ok': True, 'message': f'Item granted to player successfully'})
    except Exception as e:
        return jsonify({'ok': False, 'message': str(e)}), 500

# ============= PLAYER PROFILE ROUTES =============

@app.route('/player/search', methods=['GET'])
def search_players():
    """
    Search for players by name or email.
    """
    try:
        search_term = request.args.get('q', '')
        if not search_term:
            return jsonify({'ok': False, 'message': 'Search term required'}), 400
        
        players = db.search_players(search_term)
        return jsonify({'ok': True, 'players': players})
    except Exception as e:
        return jsonify({'ok': False, 'message': str(e)}), 500

@app.route('/player/<int:player_id>/profile', methods=['GET'])
def get_player_profile(player_id):
    """
    Get detailed player profile with stats and match history.
    """
    try:
        profile = db.get_player_profile(player_id)
        if not profile:
            return jsonify({'ok': False, 'message': 'Player not found'}), 404
        return jsonify({'ok': True, **profile})
    except Exception as e:
        return jsonify({'ok': False, 'message': str(e)}), 500

# ============= GAME DATA ROUTES =============

@app.route('/characters', methods=['GET'])
def get_characters():
    """
    Get all characters with their role and stats.
    """
    try:
        characters = db.get_all_characters()
        return jsonify({'ok': True, 'characters': characters})
    except Exception as e:
        return jsonify({'ok': False, 'message': str(e)}), 500

@app.route('/character/<int:character_id>', methods=['GET'])
def get_character_details(character_id):
    """
    Get detailed character information with abilities.
    """
    try:
        character = db.get_character_details(character_id)
        if not character:
            return jsonify({'ok': False, 'message': 'Character not found'}), 404
        return jsonify({'ok': True, **character})
    except Exception as e:
        return jsonify({'ok': False, 'message': str(e)}), 500

@app.route('/items/all', methods=['GET'])
def get_all_items():
    """
    Get all items with categories and rarities.
    """
    try:
        items = db.get_all_items()
        return jsonify({'ok': True, 'items': items})
    except Exception as e:
        return jsonify({'ok': False, 'message': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000)
