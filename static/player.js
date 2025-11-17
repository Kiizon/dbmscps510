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
                <div class="match-card ${match.result}">
                    <div class="match-info">
                        <div class="match-character">${match.character_name}</div>
                        <div class="match-result">${match.result}</div>
                        <div class="match-kda">${match.kills}/${match.deaths}/${match.assists} KDA</div>
                        <div class="match-details">${match.gamemode} • ${match.started_at}</div>
                    </div>
                    <div class="match-mmr ${mmrClass}">${mmrSign}${match.mmr_delta} MMR</div>
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
});

