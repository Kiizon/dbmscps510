/**
 * MOBA Player Stats - Client-side JavaScript
 */

// ============= UTILITY FUNCTIONS =============

function showToast(message, type = 'success') {
    const toast = document.getElementById('toast');
    toast.textContent = message;
    toast.className = `toast show ${type}`;
    
    setTimeout(() => {
        toast.className = 'toast';
    }, 3000);
}

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

// ============= PLAYER SEARCH =============

async function searchPlayers() {
    const searchTerm = document.getElementById('playerSearch').value.trim();
    
    if (!searchTerm) {
        showToast('Please enter a player name or email', 'error');
        return;
    }
    
    const result = await apiGet(`/player/search?q=${encodeURIComponent(searchTerm)}`);
    if (!result) return;
    
    displaySearchResults(result.players);
}

function displaySearchResults(players) {
    const resultsSection = document.getElementById('searchResultsSection');
    const container = document.getElementById('searchResults');
    const profileSection = document.getElementById('profileSection');
    
    profileSection.style.display = 'none';
    
    if (!players || players.length === 0) {
        resultsSection.style.display = 'block';
        container.innerHTML = `
            <div class="empty-state">
                <div class="empty-state-icon">🔍</div>
                <div class="empty-state-text">No players found</div>
            </div>
        `;
        return;
    }
    
    let html = '';
    players.forEach(player => {
        html += `
            <div class="search-result-card" onclick="viewPlayerProfile(${player.player_id})">
                <div class="search-result-name">${player.display_name}</div>
                <div class="search-result-email">${player.email}</div>
                <div class="search-result-mmr">MMR: ${player.rank_mmr}</div>
            </div>
        `;
    });
    
    container.innerHTML = html;
    resultsSection.style.display = 'block';
}

// ============= PLAYER PROFILE =============

async function viewPlayerProfile(playerId) {
    const result = await apiGet(`/player/${playerId}/profile`);
    if (!result) return;
    
    displayPlayerProfile(result);
    
    const profileSection = document.getElementById('profileSection');
    profileSection.style.display = 'block';
    profileSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
}

function displayPlayerProfile(data) {
    const container = document.getElementById('profileContent');
    const player = data.player;
    const stats = data.stats;
    const matches = data.matches;
    const characters = data.characters;
    
    // Calculate win rate
    const winRate = stats.total_matches > 0 
        ? ((stats.wins / stats.total_matches) * 100).toFixed(1) 
        : 0;
    
    // Calculate KDA ratio
    const kdaRatio = stats.avg_deaths > 0
        ? ((stats.avg_kills + stats.avg_assists) / stats.avg_deaths).toFixed(2)
        : (stats.avg_kills + stats.avg_assists).toFixed(2);
    
    let html = `
        <div class="profile-header">
            <h2>${player.display_name}</h2>
            <div class="profile-header-email">${player.email}</div>
            <div class="profile-stats-row">
                <div class="profile-stat">
                    <span class="profile-stat-value">${player.rank_mmr}</span>
                    <span class="profile-stat-label">MMR</span>
                </div>
                <div class="profile-stat">
                    <span class="profile-stat-value">${stats.total_matches || 0}</span>
                    <span class="profile-stat-label">Matches</span>
                </div>
                <div class="profile-stat">
                    <span class="profile-stat-value">${winRate}%</span>
                    <span class="profile-stat-label">Win Rate</span>
                </div>
                <div class="profile-stat">
                    <span class="profile-stat-value">${kdaRatio}</span>
                    <span class="profile-stat-label">KDA Ratio</span>
                </div>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <span class="stat-card-value">${stats.wins || 0}W - ${stats.losses || 0}L</span>
                <span class="stat-card-label">Win/Loss Record</span>
            </div>
            <div class="stat-card">
                <span class="stat-card-value">${stats.avg_kills || 0} / ${stats.avg_deaths || 0} / ${stats.avg_assists || 0}</span>
                <span class="stat-card-label">Average K/D/A</span>
            </div>
            <div class="stat-card">
                <span class="stat-card-value">${stats.avg_damage || 0}</span>
                <span class="stat-card-label">Avg Damage Dealt</span>
            </div>
            <div class="stat-card">
                <span class="stat-card-value">${stats.avg_healing || 0}</span>
                <span class="stat-card-label">Avg Healing Done</span>
            </div>
        </div>
    `;
    
    // Most Played Characters
    if (characters && characters.length > 0) {
        html += `
            <h3 class="section-title">Most Played Characters</h3>
            <div class="characters-grid">
        `;
        characters.forEach(char => {
            const charWinRate = char.times_played > 0
                ? ((char.wins / char.times_played) * 100).toFixed(0)
                : 0;
            html += `
                <div class="character-card">
                    <div class="character-name">${char.character_name}</div>
                    <span class="character-plays">${char.times_played}</span>
                    <div class="character-winrate">${charWinRate}% Win Rate</div>
                </div>
            `;
        });
        html += `</div>`;
    }
    
    // Match History
    if (matches && matches.length > 0) {
        html += `
            <h3 class="section-title">Recent Match History</h3>
            <div class="match-list">
        `;
        matches.forEach(match => {
            const mmrClass = match.mmr_delta >= 0 ? 'positive' : 'negative';
            const mmrSign = match.mmr_delta >= 0 ? '+' : '';
            html += `
                <div class="match-card ${match.result}" onclick="viewMatchDetails(${match.match_id})">
                    <div class="match-info">
                        <div class="match-character">${match.character_name}</div>
                        <div class="match-result">${match.result}</div>
                        <div class="match-kda">${match.kills}/${match.deaths}/${match.assists} KDA</div>
                        <div class="match-details">${match.gamemode} • ${match.started_at}</div>
                    </div>
                    <div class="match-mmr ${mmrClass}">${mmrSign}${match.mmr_delta} MMR</div>
                    <div class="match-expand-hint">Click for details →</div>
                </div>
            `;
        });
        html += `</div>`;
    } else {
        html += `
            <h3 class="section-title">Match History</h3>
            <div class="empty-state">
                <div class="empty-state-icon">📊</div>
                <div class="empty-state-text">No match history available</div>
            </div>
        `;
    }
    
    container.innerHTML = html;
}

// ============= MATCH DETAILS =============

async function viewMatchDetails(matchId) {
    const result = await apiGet(`/match/${matchId}/details`);
    if (!result) return;
    
    displayMatchModal(result);
}

function displayMatchModal(data) {
    const match = data.match;
    const players = data.players;
    
    // Group players by team
    const teamMap = {};
    players.forEach(p => {
        if (!teamMap[p.team_label]) {
            teamMap[p.team_label] = [];
        }
        teamMap[p.team_label].push(p);
    });
    
    let html = `
        <div class="match-modal-header">
            <h3>Match ${match.match_id} - ${match.gamemode}</h3>
            <p>${match.started_at} - ${match.ended_at || 'In Progress'}</p>
            <button class="modal-close" onclick="closeMatchModal()">×</button>
        </div>
        <div class="match-modal-content">
    `;
    
    // Display teams
    for (const [teamLabel, teamPlayers] of Object.entries(teamMap)) {
        const teamResult = teamPlayers[0].result;
        html += `
            <div class="team-section ${teamResult}">
                <h4>Team ${teamLabel} - ${teamResult.toUpperCase()}</h4>
                <div class="team-players">
        `;
        
        teamPlayers.forEach(p => {
            const kda = p.kills !== undefined 
                ? `${p.kills}/${p.deaths}/${p.assists}` 
                : 'N/A';
            html += `
                <div class="modal-player-card">
                    <div class="modal-player-name" onclick="viewPlayerProfile(${p.player_id})">${p.display_name}</div>
                    <div class="modal-player-character">${p.character_name}</div>
                    <div class="modal-player-stats">
                        <span><strong>KDA:</strong> ${kda}</span>
                        ${p.damage_dealt !== undefined ? `<span><strong>Damage:</strong> ${p.damage_dealt}</span>` : ''}
                        ${p.healing_done !== undefined && p.healing_done > 0 ? `<span><strong>Healing:</strong> ${p.healing_done}</span>` : ''}
                    </div>
                </div>
            `;
        });
        
        html += `
                </div>
            </div>
        `;
    }
    
    html += `</div>`;
    
    // Show modal
    const modal = document.getElementById('matchModal');
    const modalContent = document.getElementById('matchModalContent');
    modalContent.innerHTML = html;
    modal.style.display = 'flex';
}

function closeMatchModal() {
    document.getElementById('matchModal').style.display = 'none';
}

// ============= SECTION NAVIGATION =============

function showSection(section) {
    // Update header nav links
    document.querySelectorAll('.header-nav-link').forEach(link => {
        link.classList.remove('active');
    });
    event.target.classList.add('active');
    
    // Show/hide sections
    if (section === 'search') {
        document.getElementById('playerSearchSection').style.display = 'block';
        document.getElementById('browseSection').style.display = 'none';
    } else if (section === 'browse') {
        document.getElementById('playerSearchSection').style.display = 'none';
        document.getElementById('browseSection').style.display = 'block';
        loadCharacters();
    }
    
    // Scroll to top
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

function showBrowseTab(tab) {
    // Update tab buttons
    document.querySelectorAll('.browse-tab').forEach(btn => {
        btn.classList.remove('active');
    });
    event.target.classList.add('active');
    
    // Show/hide tab content
    document.querySelectorAll('.browse-tab-content').forEach(content => {
        content.classList.remove('active');
    });
    
    if (tab === 'characters') {
        document.getElementById('charactersTab').classList.add('active');
        loadCharacters();
    } else if (tab === 'items') {
        document.getElementById('itemsTab').classList.add('active');
        loadItems();
    }
}

// ============= CHARACTERS =============

async function loadCharacters() {
    const container = document.getElementById('charactersGrid');
    
    // Check if already loaded
    if (container.innerHTML) return;
    
    const result = await apiGet('/characters');
    if (!result) return;
    
    displayCharacters(result.characters);
}

function displayCharacters(characters) {
    const container = document.getElementById('charactersGrid');
    
    if (!characters || characters.length === 0) {
        container.innerHTML = '<div class="empty-state"><div class="empty-state-icon">🎭</div><div class="empty-state-text">No characters found</div></div>';
        return;
    }
    
    let html = '';
    characters.forEach(char => {
        html += `
            <div class="character-card-browse" onclick="viewCharacterDetails(${char.character_id})">
                <div class="character-card-header">
                    <div class="character-card-name">${char.name}</div>
                    <div class="character-card-role">${char.role_name}</div>
                </div>
                <div class="character-card-stats">
                    <div class="character-stat-row">
                        <span class="character-stat-label">Health:</span>
                        <span class="character-stat-value">${char.base_health}</span>
                    </div>
                    <div class="character-stat-row">
                        <span class="character-stat-label">Attack Power:</span>
                        <span class="character-stat-value">${char.attack_power}</span>
                    </div>
                    <div class="character-stat-row">
                        <span class="character-stat-label">Attack Speed:</span>
                        <span class="character-stat-value">${char.attack_speed}</span>
                    </div>
                </div>
            </div>
        `;
    });
    
    container.innerHTML = html;
}

async function viewCharacterDetails(characterId) {
    const result = await apiGet(`/character/${characterId}`);
    if (!result) return;
    
    displayCharacterModal(result);
}

function displayCharacterModal(data) {
    const char = data.character;
    const abilities = data.abilities;
    const stats = data.stats;
    
    const winRate = stats.times_played > 0 
        ? ((stats.wins / stats.times_played) * 100).toFixed(1) 
        : 0;
    
    let html = `
        <div class="match-modal-header">
            <h3>${char.name}</h3>
            <p>${char.role_name} - ${char.role_description}</p>
            <button class="modal-close" onclick="closeCharacterModal()">×</button>
        </div>
        <div class="match-modal-content">
            <div class="team-section">
                <h4>Base Stats</h4>
                <div class="team-players">
                    <div class="modal-player-card">
                        <div class="modal-player-stats">
                            <span><strong>Health:</strong> ${char.base_health}</span>
                            <span><strong>Attack Power:</strong> ${char.attack_power}</span>
                            <span><strong>Attack Speed:</strong> ${char.attack_speed}</span>
                        </div>
                    </div>
                </div>
            </div>
    `;
    
    if (abilities && abilities.length > 0) {
        html += `
            <div class="team-section">
                <h4>Abilities</h4>
                <div class="team-players">
        `;
        abilities.forEach(ability => {
            html += `
                <div class="modal-player-card">
                    <div class="modal-player-name">${ability.name}</div>
                    <div class="modal-player-character">${ability.slot} - ${ability.type}</div>
                    <div class="modal-player-stats">
                        <span><strong>Power:</strong> ${ability.power}</span>
                        <span><strong>Cooldown:</strong> ${ability.cooldown_s}s</span>
                    </div>
                </div>
            `;
        });
        html += `</div></div>`;
    }
    
    if (stats.times_played > 0) {
        html += `
            <div class="team-section">
                <h4>Play Statistics</h4>
                <div class="team-players">
                    <div class="modal-player-card">
                        <div class="modal-player-stats">
                            <span><strong>Times Played:</strong> ${stats.times_played}</span>
                            <span><strong>Win Rate:</strong> ${winRate}% (${stats.wins}W - ${stats.losses}L)</span>
                            <span><strong>Avg K/D/A:</strong> ${stats.avg_kills}/${stats.avg_deaths}/${stats.avg_assists}</span>
                            <span><strong>Avg Damage:</strong> ${stats.avg_damage}</span>
                        </div>
                    </div>
                </div>
            </div>
        `;
    }
    
    html += `</div>`;
    
    const modal = document.getElementById('characterModal');
    const modalContent = document.getElementById('characterModalContent');
    modalContent.innerHTML = html;
    modal.style.display = 'flex';
}

function closeCharacterModal() {
    document.getElementById('characterModal').style.display = 'none';
}

// ============= ITEMS =============

async function loadItems() {
    const container = document.getElementById('itemsGrid');
    
    // Check if already loaded
    if (container.innerHTML) return;
    
    const result = await apiGet('/items/all');
    if (!result) return;
    
    displayItems(result.items);
}

function displayItems(items) {
    const container = document.getElementById('itemsGrid');
    
    if (!items || items.length === 0) {
        container.innerHTML = '<div class="empty-state"><div class="empty-state-icon">📦</div><div class="empty-state-text">No items found</div></div>';
        return;
    }
    
    let html = '';
    items.forEach(item => {
        html += `
            <div class="item-card-browse">
                <div class="item-card-name">${item.name}</div>
                <div class="item-card-meta">
                    <span class="item-category">${item.category}</span>
                    <span class="item-rarity ${item.rarity}">${item.rarity}</span>
                </div>
            </div>
        `;
    });
    
    container.innerHTML = html;
}

// ============= EVENT LISTENERS =============

document.addEventListener('DOMContentLoaded', function() {
    // Search button
    document.getElementById('btnSearch').addEventListener('click', searchPlayers);
    
    // Enter key on search input
    document.getElementById('playerSearch').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            searchPlayers();
        }
    });
    
    // Close match modal when clicking outside
    document.getElementById('matchModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeMatchModal();
        }
    });

    // Close character modal when clicking outside
    document.getElementById('characterModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeCharacterModal();
        }
    });

    // Close modals with Escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeMatchModal();
            closeCharacterModal();
        }
    });
});

