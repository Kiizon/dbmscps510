/**
 * MOBA Game Dashboard - Client-side JavaScript
 * Handles navigation, API calls, and UI updates
 */

// ============= UTILITY FUNCTIONS =============

/**
 * Show a toast notification
 */
function showToast(message, type = 'success') {
    const toast = document.getElementById('toast');
    toast.textContent = message;
    toast.className = `toast show ${type}`;
    
    setTimeout(() => {
        toast.className = 'toast';
    }, 3000);
}

/**
 * Make a POST request to the API
 */
async function apiPost(url, data = null) {
    try {
        const options = {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        };
        
        if (data) {
            options.body = JSON.stringify(data);
        }
        
        const response = await fetch(url, options);
        const result = await response.json();
        
        if (result.ok) {
            showToast(result.message, 'success');
            return result;
        } else {
            showToast(result.message || 'An error occurred', 'error');
            return null;
        }
    } catch (error) {
        showToast('Network error: ' + error.message, 'error');
        return null;
    }
}

/**
 * Make a GET request to the API
 */
async function apiGet(url) {
    try {
        const response = await fetch(url);
        const result = await response.json();
        
        if (!result.ok) {
            showToast(result.message || 'An error occurred', 'error');
            return null;
        }
        
        return result;
    } catch (error) {
        showToast('Network error: ' + error.message, 'error');
        return null;
    }
}

// ============= NAVIGATION =============

/**
 * Switch between pages
 */
function navigateTo(pageName) {
    // Update nav items
    document.querySelectorAll('.nav-item').forEach(item => {
        item.classList.remove('active');
        if (item.dataset.page === pageName) {
            item.classList.add('active');
        }
    });
    
    // Update pages
    document.querySelectorAll('.page').forEach(page => {
        page.classList.remove('active');
    });
    document.getElementById(`page-${pageName}`).classList.add('active');
    
    // Load data for specific pages
    if (pageName === 'players') {
        loadPlayers();
    } else if (pageName === 'matches') {
        loadMatches();
    } else if (pageName === 'items') {
        loadItems();
        loadEntitlements();
        loadPlayerDropdown();
        loadItemDropdown();
    } else if (pageName === 'viewer') {
        loadTables();
    }
}

// ============= DATABASE OPERATIONS =============

/**
 * Drop all tables
 */
async function dropTables() {
    if (!confirm('Are you sure you want to drop all tables? This will delete ALL data!')) {
        return;
    }
    
    await apiPost('/drop');
    await loadTables();
}

/**
 * Create all tables
 */
async function createTables() {
    await apiPost('/create');
    await loadTables();
}

/**
 * Seed the database
 */
async function seedDatabase() {
    const result = await apiPost('/seed');
    if (result) {
        loadPlayers();
        loadMatches();
        loadItems();
        loadEntitlements();
    }
}

// ============= TABLE BROWSER =============

/**
 * Load list of tables into dropdown
 */
async function loadTables() {
    const result = await apiGet('/tables');
    if (!result) return;
    
    const select = document.getElementById('tableSelect');
    select.innerHTML = '<option value="">-- Select a table --</option>';
    
    result.tables.forEach(table => {
        const option = document.createElement('option');
        option.value = table;
        option.textContent = table;
        select.appendChild(option);
    });
}

/**
 * Query and display a table
 */
async function queryTable() {
    const select = document.getElementById('tableSelect');
    const tableName = select.value;
    
    if (!tableName) {
        showToast('Please select a table', 'error');
        return;
    }
    
    const result = await apiGet(`/query/${tableName}`);
    if (!result) return;
    
    displayTable(result.rows);
}

/**
 * Display table data
 */
function displayTable(rows) {
    const container = document.getElementById('tableResults');
    
    if (!rows || rows.length === 0) {
        container.innerHTML = '<div class="empty-state">No data found</div>';
        return;
    }
    
    // Get column names from first row
    const columns = Object.keys(rows[0]);
    
    // Build table HTML
    let html = '<table><thead><tr>';
    columns.forEach(col => {
        html += `<th>${col}</th>`;
    });
    html += '</tr></thead><tbody>';
    
    rows.forEach(row => {
        html += '<tr>';
        columns.forEach(col => {
            html += `<td>${row[col] !== null ? row[col] : 'NULL'}</td>`;
        });
        html += '</tr>';
    });
    
    html += '</tbody></table>';
    container.innerHTML = html;
}

// ============= PLAYER CRUD =============

/**
 * Load and display all players
 */
async function loadPlayers() {
    const result = await apiGet('/players');
    if (!result) return;
    
    const container = document.getElementById('playerList');
    
    if (!result.players || result.players.length === 0) {
        container.innerHTML = '<div class="empty-state">No players found. Click "Populate Sample Data" to add some.</div>';
        return;
    }
    
    let html = '';
    result.players.forEach(player => {
        html += `
            <div class="data-item">
                <div class="data-item-info">
                    <strong>ID:</strong> ${player.player_id}
                    <strong>Name:</strong> ${player.display_name}
                    <strong>Email:</strong> ${player.email}
                    <strong>MMR:</strong> ${player.rank_mmr}
                </div>
                <div class="data-item-actions">
                    <button class="btn btn-primary btn-small" onclick="editPlayer(${player.player_id})">Edit</button>
                    <button class="btn btn-danger btn-small" onclick="deletePlayer(${player.player_id})">Delete</button>
                </div>
            </div>
        `;
    });
    
    container.innerHTML = html;
}

/**
 * Save (insert or update) a player
 */
async function savePlayer() {
    const playerId = document.getElementById('playerIdEdit').value;
    const displayName = document.getElementById('playerDisplayName').value.trim();
    const email = document.getElementById('playerEmail').value.trim();
    const passwordHash = document.getElementById('playerPasswordHash').value.trim();
    const rankMmr = document.getElementById('playerRankMmr').value;
    
    if (!displayName || !email || !passwordHash) {
        showToast('Please fill in all required fields', 'error');
        return;
    }
    
    const data = {
        display_name: displayName,
        email: email,
        password_hash: passwordHash,
        rank_mmr: parseInt(rankMmr) || 1000
    };
    
    if (playerId) {
        data.player_id = parseInt(playerId);
    }
    
    const result = await apiPost('/player/upsert', data);
    if (result) {
        clearPlayerForm();
        loadPlayers();
    }
}

/**
 * Edit a player (populate form)
 */
async function editPlayer(playerId) {
    const result = await apiGet('/players');
    if (!result) return;
    
    const player = result.players.find(p => p.player_id === playerId);
    if (!player) return;
    
    document.getElementById('playerIdEdit').value = player.player_id;
    document.getElementById('playerDisplayName').value = player.display_name;
    document.getElementById('playerEmail').value = player.email;
    document.getElementById('playerPasswordHash').value = player.password_hash;
    document.getElementById('playerRankMmr').value = player.rank_mmr;
    document.getElementById('btnCancelPlayer').style.display = 'inline-block';
}

/**
 * Delete a player
 */
async function deletePlayer(playerId) {
    if (!confirm(`Are you sure you want to delete player ${playerId}?`)) {
        return;
    }
    
    const result = await apiPost(`/player/delete/${playerId}`);
    if (result) {
        loadPlayers();
    }
}

/**
 * Clear player form
 */
function clearPlayerForm() {
    document.getElementById('playerIdEdit').value = '';
    document.getElementById('playerDisplayName').value = '';
    document.getElementById('playerEmail').value = '';
    document.getElementById('playerPasswordHash').value = '';
    document.getElementById('playerRankMmr').value = '1000';
    document.getElementById('btnCancelPlayer').style.display = 'none';
}

// ============= MATCHES =============

/**
 * Load and display all matches
 */
async function loadMatches() {
    const result = await apiGet('/matches');
    if (!result) return;
    
    const container = document.getElementById('matchList');
    
    if (!result.matches || result.matches.length === 0) {
        container.innerHTML = '<div class="empty-state">No matches found. Click "Populate Sample Data" to add some.</div>';
        return;
    }
    
    let html = '';
    result.matches.forEach(match => {
        html += `
            <div class="data-item">
                <div class="data-item-info">
                    <strong>Match ID:</strong> ${match.match_id}
                    <strong>Gamemode:</strong> ${match.gamemode}
                    <strong>Started:</strong> ${match.started_at}
                    <strong>Ended:</strong> ${match.ended_at || 'In Progress'}
                </div>
                <div class="data-item-actions">
                    <button class="btn btn-info btn-small" onclick="viewMatchDetails(${match.match_id})">View Details</button>
                </div>
            </div>
        `;
    });
    
    container.innerHTML = html;
}

/**
 * View match details (teams and players)
 */
async function viewMatchDetails(matchId) {
    const result = await apiGet(`/match/${matchId}/details`);
    if (!result) return;
    
    const container = document.getElementById('matchDetailsContent');
    const detailsCard = document.getElementById('matchDetails');
    detailsCard.style.display = 'block';
    
    let html = `<h4>Match ${matchId} - ${result.match.gamemode}</h4>`;
    
    // Group players by team
    const teamMap = {};
    result.players.forEach(p => {
        if (!teamMap[p.team_label]) {
            teamMap[p.team_label] = [];
        }
        teamMap[p.team_label].push(p);
    });
    
    html += '<div class="team-container">';
    for (const [teamLabel, players] of Object.entries(teamMap)) {
        html += `
            <div class="team-box">
                <h5>Team ${teamLabel}</h5>
        `;
        players.forEach(p => {
            html += `
                <div class="player-in-match">
                    <strong>${p.display_name}</strong> as <em>${p.character_name}</em> - ${p.result.toUpperCase()}
                    ${p.kills !== undefined ? `<br/>K/D/A: ${p.kills}/${p.deaths}/${p.assists}` : ''}
                </div>
            `;
        });
        html += '</div>';
    }
    html += '</div>';
    
    container.innerHTML = html;
}

// ============= ITEMS & ENTITLEMENTS =============

/**
 * Load and display all items
 */
async function loadItems() {
    const result = await apiGet('/items');
    if (!result) return;
    
    const container = document.getElementById('itemList');
    
    if (!result.items || result.items.length === 0) {
        container.innerHTML = '<div class="empty-state">No items found.</div>';
        return;
    }
    
    let html = '';
    result.items.forEach(item => {
        html += `
            <div class="data-item">
                <div class="data-item-info">
                    <strong>ID:</strong> ${item.item_id}
                    <strong>Name:</strong> ${item.name}
                    <strong>Category:</strong> ${item.category}
                    <strong>Rarity:</strong> ${item.rarity}
                </div>
            </div>
        `;
    });
    
    container.innerHTML = html;
}

/**
 * Load and display entitlements
 */
async function loadEntitlements() {
    const result = await apiGet('/entitlements');
    if (!result) return;
    
    const container = document.getElementById('entitlementList');
    
    if (!result.entitlements || result.entitlements.length === 0) {
        container.innerHTML = '<div class="empty-state">No entitlements found.</div>';
        return;
    }
    
    let html = '';
    result.entitlements.forEach(ent => {
        html += `
            <div class="data-item">
                <div class="data-item-info">
                    <strong>Player:</strong> ${ent.display_name}
                    <strong>Item:</strong> ${ent.item_name}
                    <strong>Quantity:</strong> ${ent.quantity}
                    <strong>Status:</strong> ${ent.status}
                    <strong>Acquired:</strong> ${ent.acquired_at}
                </div>
            </div>
        `;
    });
    
    container.innerHTML = html;
}

/**
 * Load players into grant dropdown
 */
async function loadPlayerDropdown() {
    const result = await apiGet('/players');
    if (!result) return;
    
    const select = document.getElementById('grantPlayerId');
    select.innerHTML = '<option value="">-- Select Player --</option>';
    
    if (result.players) {
        result.players.forEach(player => {
            const option = document.createElement('option');
            option.value = player.player_id;
            option.textContent = `${player.display_name} (ID: ${player.player_id})`;
            select.appendChild(option);
        });
    }
}

/**
 * Load items into grant dropdown
 */
async function loadItemDropdown() {
    const result = await apiGet('/items');
    if (!result) return;
    
    const select = document.getElementById('grantItemId');
    select.innerHTML = '<option value="">-- Select Item --</option>';
    
    if (result.items) {
        result.items.forEach(item => {
            const option = document.createElement('option');
            option.value = item.item_id;
            option.textContent = `${item.name} (${item.category})`;
            select.appendChild(option);
        });
    }
}

/**
 * Grant an item to a player
 */
async function grantItem() {
    const playerId = document.getElementById('grantPlayerId').value;
    const itemId = document.getElementById('grantItemId').value;
    const quantity = document.getElementById('grantQuantity').value;
    
    if (!playerId || !itemId) {
        showToast('Please select both player and item', 'error');
        return;
    }
    
    const data = {
        player_id: parseInt(playerId),
        item_id: parseInt(itemId),
        quantity: parseInt(quantity) || 1
    };
    
    const result = await apiPost('/entitlement/grant', data);
    if (result) {
        loadEntitlements();
        // Reset form
        document.getElementById('grantQuantity').value = '1';
    }
}

// ============= EVENT LISTENERS =============

document.addEventListener('DOMContentLoaded', function() {
    // Navigation
    document.querySelectorAll('.nav-item').forEach(item => {
        item.addEventListener('click', function(e) {
            e.preventDefault();
            navigateTo(this.dataset.page);
        });
    });
    
    // Database operations
    document.getElementById('btnDrop').addEventListener('click', dropTables);
    document.getElementById('btnCreate').addEventListener('click', createTables);
    document.getElementById('btnSeed').addEventListener('click', seedDatabase);
    
    // Table browser
    document.getElementById('btnQuery').addEventListener('click', queryTable);
    
    // Player CRUD
    document.getElementById('btnSavePlayer').addEventListener('click', savePlayer);
    document.getElementById('btnCancelPlayer').addEventListener('click', clearPlayerForm);
    
    // Items & Entitlements
    document.getElementById('btnGrantItem').addEventListener('click', grantItem);
    
    // Initial load
    loadTables();
    loadPlayers();
});
