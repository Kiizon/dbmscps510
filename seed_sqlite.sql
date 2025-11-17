PRAGMA foreign_keys = ON;

-- ============================================================
-- GAME ROLES
-- ============================================================
INSERT INTO game_role(role_id, name, description) VALUES
  (1,'Tank','High durability, protects team'),
  (2,'DPS','Damage dealer, eliminates enemies'),
  (3,'Support','Heals and buffs allies'),
  (4,'Assassin','High mobility, burst damage'),
  (5,'Mage','Ranged magic damage');

-- ============================================================
-- PLAYERS (50 players with varied MMR)
-- ============================================================
INSERT INTO player(player_id, display_name, email, password_hash, rank_mmr) VALUES
  (1,'Alice','alice@example.com','hash_a',1200),
  (2,'Bob','bob@example.com','hash_b',1100),
  (3,'Cara','cara@example.com','hash_c',1300),
  (4,'David','david@example.com','hash_d',950),
  (5,'Emma','emma@example.com','hash_e',1450),
  (6,'Frank','frank@example.com','hash_f',1050),
  (7,'Grace','grace@example.com','hash_g',1250),
  (8,'Henry','henry@example.com','hash_h',1400),
  (9,'Iris','iris@example.com','hash_i',1150),
  (10,'Jack','jack@example.com','hash_j',1350),
  (11,'Kelly','kelly@example.com','hash_k',980),
  (12,'Leo','leo@example.com','hash_l',1500),
  (13,'Maya','maya@example.com','hash_m',1280),
  (14,'Noah','noah@example.com','hash_n',1180),
  (15,'Olivia','olivia@example.com','hash_o',1420),
  (16,'Paul','paul@example.com','hash_p',1090),
  (17,'Quinn','quinn@example.com','hash_q',1310),
  (18,'Rachel','rachel@example.com','hash_r',1220),
  (19,'Sam','sam@example.com','hash_s',1380),
  (20,'Tina','tina@example.com','hash_t',1160),
  (21,'Uma','uma@example.com','hash_u',1480),
  (22,'Victor','victor@example.com','hash_v',1070),
  (23,'Wendy','wendy@example.com','hash_w',1330),
  (24,'Xavier','xavier@example.com','hash_x',1240),
  (25,'Yara','yara@example.com','hash_y',1410),
  (26,'Zack','zack@example.com','hash_z',1130),
  (27,'Anna','anna@example.com','hash_aa',1290),
  (28,'Blake','blake@example.com','hash_bb',1190),
  (29,'Chloe','chloe@example.com','hash_cc',1440),
  (30,'Derek','derek@example.com','hash_dd',1010),
  (31,'Elena','elena@example.com','hash_ee',1360),
  (32,'Felix','felix@example.com','hash_ff',1120),
  (33,'Gina','gina@example.com','hash_gg',1470),
  (34,'Hugo','hugo@example.com','hash_hh',1200),
  (35,'Ivy','ivy@example.com','hash_ii',1320),
  (36,'Jake','jake@example.com','hash_jj',1140),
  (37,'Kate','kate@example.com','hash_kk',1390),
  (38,'Luke','luke@example.com','hash_ll',1080),
  (39,'Mia','mia@example.com','hash_mm',1430),
  (40,'Nick','nick@example.com','hash_nn',1170),
  (41,'Oscar','oscar@example.com','hash_oo',1340),
  (42,'Piper','piper@example.com','hash_pp',1230),
  (43,'Quincy','quincy@example.com','hash_qq',1460),
  (44,'Ruby','ruby@example.com','hash_rr',1110),
  (45,'Steve','steve@example.com','hash_ss',1370),
  (46,'Tara','tara@example.com','hash_tt',1150),
  (47,'Ulysses','ulysses@example.com','hash_uu',1490),
  (48,'Vera','vera@example.com','hash_vv',1260),
  (49,'Wade','wade@example.com','hash_ww',1400),
  (50,'Xena','xena@example.com','hash_xx',1270);

-- ============================================================
-- GAME CHARACTERS (10 characters across different roles)
-- ============================================================
INSERT INTO game_character(character_id, name, role_id, base_health, attack_power, attack_speed) VALUES
  (1,'Aegis',1,3000,50,0.80),
  (2,'Blaze',2,1500,120,1.25),
  (3,'Muse',3,1700,40,1.10),
  (4,'Shadow',4,1400,140,1.50),
  (5,'Mystic',5,1300,110,1.00),
  (6,'Titan',1,3200,45,0.75),
  (7,'Reaper',2,1600,125,1.30),
  (8,'Luna',3,1800,35,1.05),
  (9,'Wraith',4,1350,145,1.55),
  (10,'Arcane',5,1250,115,0.95);

-- ============================================================
-- ABILITIES (15 abilities)
-- ============================================================
INSERT INTO ability(ability_id, name, type, power, cooldown_s) VALUES
  (1,'Shield Wall','defense',0,20),
  (2,'Fire Burst','attack',150,8),
  (3,'Healing Wave','support',100,10),
  (4,'Shadow Strike','attack',180,12),
  (5,'Arcane Blast','attack',160,9),
  (6,'Fortify','defense',0,25),
  (7,'Soul Drain','attack',140,15),
  (8,'Divine Light','support',120,12),
  (9,'Blink','mobility',0,18),
  (10,'Meteor','attack',200,20),
  (11,'Barrier','defense',0,15),
  (12,'Regeneration','support',80,8),
  (13,'Assassinate','attack',220,30),
  (14,'Time Warp','support',0,35),
  (15,'Thunder Strike','attack',170,10);

-- ============================================================
-- CHARACTER_ABILITY (assign abilities to characters)
-- ============================================================
INSERT INTO character_ability(character_id, ability_id, slot) VALUES
  (1,1,'primary'),
  (1,6,'secondary'),
  (1,11,'tertiary'),
  (2,2,'primary'),
  (2,15,'secondary'),
  (3,3,'primary'),
  (3,8,'secondary'),
  (3,12,'tertiary'),
  (4,4,'primary'),
  (4,9,'secondary'),
  (4,13,'tertiary'),
  (5,5,'primary'),
  (5,10,'secondary'),
  (5,14,'tertiary'),
  (6,1,'primary'),
  (6,11,'secondary'),
  (7,2,'primary'),
  (7,7,'secondary'),
  (8,3,'primary'),
  (8,12,'secondary'),
  (9,4,'primary'),
  (9,13,'secondary'),
  (10,5,'primary'),
  (10,10,'secondary');

-- ============================================================
-- ITEMS (20 items with various categories)
-- ============================================================
INSERT INTO item(item_id, name, category, rarity) VALUES
  (1,'Health Potion','consumable','common'),
  (2,'Phoenix Blade','weapon','rare'),
  (3,'Aegis Emblem','trinket','epic'),
  (4,'Mana Crystal','consumable','common'),
  (5,'Shadow Dagger','weapon','epic'),
  (6,'Divine Shield','armor','legendary'),
  (7,'Speed Boots','armor','rare'),
  (8,'Magic Wand','weapon','common'),
  (9,'Dragon Scale','armor','epic'),
  (10,'Elixir of Power','consumable','rare'),
  (11,'Frost Sword','weapon','epic'),
  (12,'Lucky Charm','trinket','rare'),
  (13,'Healing Orb','trinket','common'),
  (14,'Thunder Hammer','weapon','legendary'),
  (15,'Invisibility Cloak','armor','epic'),
  (16,'Energy Drink','consumable','common'),
  (17,'Mystic Staff','weapon','rare'),
  (18,'Golden Crown','trinket','legendary'),
  (19,'Battle Axe','weapon','rare'),
  (20,'Resurrection Stone','trinket','legendary');

-- ============================================================
-- MATCHES (15 matches)
-- ============================================================
INSERT INTO match_game(match_id, gamemode, started_at, ended_at) VALUES
  (1,'Ranked','2024-01-15 14:30:00','2024-01-15 15:15:00'),
  (2,'Ranked','2024-01-15 16:00:00','2024-01-15 16:42:00'),
  (3,'Casual','2024-01-15 17:30:00','2024-01-15 18:10:00'),
  (4,'Ranked','2024-01-16 10:00:00','2024-01-16 10:38:00'),
  (5,'Ranked','2024-01-16 11:15:00','2024-01-16 12:05:00'),
  (6,'Casual','2024-01-16 13:45:00','2024-01-16 14:20:00'),
  (7,'Ranked','2024-01-16 15:30:00','2024-01-16 16:15:00'),
  (8,'Ranked','2024-01-17 09:00:00','2024-01-17 09:55:00'),
  (9,'Casual','2024-01-17 11:30:00','2024-01-17 12:08:00'),
  (10,'Ranked','2024-01-17 14:00:00','2024-01-17 14:48:00'),
  (11,'Ranked','2024-01-18 10:30:00','2024-01-18 11:22:00'),
  (12,'Casual','2024-01-18 13:00:00','2024-01-18 13:45:00'),
  (13,'Ranked','2024-01-18 15:30:00','2024-01-18 16:18:00'),
  (14,'Ranked','2024-01-19 10:00:00','2024-01-19 10:52:00'),
  (15,'Casual','2024-01-19 12:30:00','2024-01-19 13:15:00');

-- ============================================================
-- TEAMS (30 teams - 2 per match)
-- ============================================================
INSERT INTO team(team_id, match_id, team_label) VALUES
  (1,1,'Blue'),(2,1,'Red'),
  (3,2,'Blue'),(4,2,'Red'),
  (5,3,'Blue'),(6,3,'Red'),
  (7,4,'Blue'),(8,4,'Red'),
  (9,5,'Blue'),(10,5,'Red'),
  (11,6,'Blue'),(12,6,'Red'),
  (13,7,'Blue'),(14,7,'Red'),
  (15,8,'Blue'),(16,8,'Red'),
  (17,9,'Blue'),(18,9,'Red'),
  (19,10,'Blue'),(20,10,'Red'),
  (21,11,'Blue'),(22,11,'Red'),
  (23,12,'Blue'),(24,12,'Red'),
  (25,13,'Blue'),(26,13,'Red'),
  (27,14,'Blue'),(28,14,'Red'),
  (29,15,'Blue'),(30,15,'Red');

-- ============================================================
-- MATCH_PLAYER (5 players per team = 10 per match = 150 total)
-- ============================================================
-- Match 1
INSERT INTO match_player(match_player_id, match_id, team_id, player_id, character_id, result) VALUES
  (1,1,1,1,1,'win'),(2,1,1,2,2,'win'),(3,1,1,3,3,'win'),(4,1,1,4,4,'win'),(5,1,1,5,5,'win'),
  (6,1,2,6,6,'loss'),(7,1,2,7,7,'loss'),(8,1,2,8,8,'loss'),(9,1,2,9,9,'loss'),(10,1,2,10,10,'loss');

-- Match 2
INSERT INTO match_player(match_player_id, match_id, team_id, player_id, character_id, result) VALUES
  (11,2,3,11,1,'loss'),(12,2,3,12,2,'loss'),(13,2,3,13,3,'loss'),(14,2,3,14,4,'loss'),(15,2,3,15,5,'loss'),
  (16,2,4,16,6,'win'),(17,2,4,17,7,'win'),(18,2,4,18,8,'win'),(19,2,4,19,9,'win'),(20,2,4,20,10,'win');

-- Match 3
INSERT INTO match_player(match_player_id, match_id, team_id, player_id, character_id, result) VALUES
  (21,3,5,21,1,'win'),(22,3,5,22,2,'win'),(23,3,5,23,3,'win'),(24,3,5,24,4,'win'),(25,3,5,25,5,'win'),
  (26,3,6,26,6,'loss'),(27,3,6,27,7,'loss'),(28,3,6,28,8,'loss'),(29,3,6,29,9,'loss'),(30,3,6,30,10,'loss');

-- Match 4
INSERT INTO match_player(match_player_id, match_id, team_id, player_id, character_id, result) VALUES
  (31,4,7,31,1,'win'),(32,4,7,32,2,'win'),(33,4,7,33,3,'win'),(34,4,7,34,4,'win'),(35,4,7,35,5,'win'),
  (36,4,8,36,6,'loss'),(37,4,8,37,7,'loss'),(38,4,8,38,8,'loss'),(39,4,8,39,9,'loss'),(40,4,8,40,10,'loss');

-- Match 5
INSERT INTO match_player(match_player_id, match_id, team_id, player_id, character_id, result) VALUES
  (41,5,9,41,1,'loss'),(42,5,9,42,2,'loss'),(43,5,9,43,3,'loss'),(44,5,9,44,4,'loss'),(45,5,9,45,5,'loss'),
  (46,5,10,1,6,'win'),(47,5,10,2,7,'win'),(48,5,10,3,8,'win'),(49,5,10,4,9,'win'),(50,5,10,5,10,'win');

-- Match 6
INSERT INTO match_player(match_player_id, match_id, team_id, player_id, character_id, result) VALUES
  (51,6,11,6,1,'win'),(52,6,11,7,2,'win'),(53,6,11,8,3,'win'),(54,6,11,9,4,'win'),(55,6,11,10,5,'win'),
  (56,6,12,11,6,'loss'),(57,6,12,12,7,'loss'),(58,6,12,13,8,'loss'),(59,6,12,14,9,'loss'),(60,6,12,15,10,'loss');

-- Match 7
INSERT INTO match_player(match_player_id, match_id, team_id, player_id, character_id, result) VALUES
  (61,7,13,16,1,'loss'),(62,7,13,17,2,'loss'),(63,7,13,18,3,'loss'),(64,7,13,19,4,'loss'),(65,7,13,20,5,'loss'),
  (66,7,14,21,6,'win'),(67,7,14,22,7,'win'),(68,7,14,23,8,'win'),(69,7,14,24,9,'win'),(70,7,14,25,10,'win');

-- Match 8
INSERT INTO match_player(match_player_id, match_id, team_id, player_id, character_id, result) VALUES
  (71,8,15,26,1,'win'),(72,8,15,27,2,'win'),(73,8,15,28,3,'win'),(74,8,15,29,4,'win'),(75,8,15,30,5,'win'),
  (76,8,16,31,6,'loss'),(77,8,16,32,7,'loss'),(78,8,16,33,8,'loss'),(79,8,16,34,9,'loss'),(80,8,16,35,10,'loss');

-- Match 9
INSERT INTO match_player(match_player_id, match_id, team_id, player_id, character_id, result) VALUES
  (81,9,17,36,1,'win'),(82,9,17,37,2,'win'),(83,9,17,38,3,'win'),(84,9,17,39,4,'win'),(85,9,17,40,5,'win'),
  (86,9,18,41,6,'loss'),(87,9,18,42,7,'loss'),(88,9,18,43,8,'loss'),(89,9,18,44,9,'loss'),(90,9,18,45,10,'loss');

-- Match 10
INSERT INTO match_player(match_player_id, match_id, team_id, player_id, character_id, result) VALUES
  (91,10,19,46,1,'loss'),(92,10,19,47,2,'loss'),(93,10,19,48,3,'loss'),(94,10,19,49,4,'loss'),(95,10,19,50,5,'loss'),
  (96,10,20,1,6,'win'),(97,10,20,2,7,'win'),(98,10,20,3,8,'win'),(99,10,20,4,9,'win'),(100,10,20,5,10,'win');

-- Match 11
INSERT INTO match_player(match_player_id, match_id, team_id, player_id, character_id, result) VALUES
  (101,11,21,6,1,'win'),(102,11,21,7,2,'win'),(103,11,21,8,3,'win'),(104,11,21,9,4,'win'),(105,11,21,10,5,'win'),
  (106,11,22,11,6,'loss'),(107,11,22,12,7,'loss'),(108,11,22,13,8,'loss'),(109,11,22,14,9,'loss'),(110,11,22,15,10,'loss');

-- Match 12
INSERT INTO match_player(match_player_id, match_id, team_id, player_id, character_id, result) VALUES
  (111,12,23,16,1,'win'),(112,12,23,17,2,'win'),(113,12,23,18,3,'win'),(114,12,23,19,4,'win'),(115,12,23,20,5,'win'),
  (116,12,24,21,6,'loss'),(117,12,24,22,7,'loss'),(118,12,24,23,8,'loss'),(119,12,24,24,9,'loss'),(120,12,24,25,10,'loss');

-- Match 13
INSERT INTO match_player(match_player_id, match_id, team_id, player_id, character_id, result) VALUES
  (121,13,25,26,1,'win'),(122,13,25,27,2,'win'),(123,13,25,28,3,'win'),(124,13,25,29,4,'win'),(125,13,25,30,5,'win'),
  (126,13,26,31,6,'loss'),(127,13,26,32,7,'loss'),(128,13,26,33,8,'loss'),(129,13,26,34,9,'loss'),(130,13,26,35,10,'loss');

-- Match 14
INSERT INTO match_player(match_player_id, match_id, team_id, player_id, character_id, result) VALUES
  (131,14,27,36,1,'loss'),(132,14,27,37,2,'loss'),(133,14,27,38,3,'loss'),(134,14,27,39,4,'loss'),(135,14,27,40,5,'loss'),
  (136,14,28,41,6,'win'),(137,14,28,42,7,'win'),(138,14,28,43,8,'win'),(139,14,28,44,9,'win'),(140,14,28,45,10,'win');

-- Match 15
INSERT INTO match_player(match_player_id, match_id, team_id, player_id, character_id, result) VALUES
  (141,15,29,46,1,'win'),(142,15,29,47,2,'win'),(143,15,29,48,3,'win'),(144,15,29,49,4,'win'),(145,15,29,50,5,'win'),
  (146,15,30,1,6,'loss'),(147,15,30,2,7,'loss'),(148,15,30,3,8,'loss'),(149,15,30,4,9,'loss'),(150,15,30,5,10,'loss');

-- ============================================================
-- MATCH_PLAYER_STATS (stats for all 150 match players)
-- ============================================================
-- Match 1 stats
INSERT INTO match_player_stats(match_player_id, kills, deaths, assists, damage_dealt, healing_done, abilities_used, mmr_delta) VALUES
  (1,8,3,6,2800,150,15,20),(2,12,2,4,3500,0,18,20),(3,2,4,12,800,2200,22,20),(4,15,1,3,4200,0,20,20),(5,10,3,7,3200,100,17,20),
  (6,4,10,5,2200,200,14,-20),(7,6,8,4,2800,0,16,-20),(8,3,7,8,700,1800,20,-20),(9,5,12,6,2000,0,15,-20),(10,7,9,5,2600,50,18,-20);

-- Match 2 stats
INSERT INTO match_player_stats(match_player_id, kills, deaths, assists, damage_dealt, healing_done, abilities_used, mmr_delta) VALUES
  (11,6,9,4,2300,100,13,-20),(12,8,10,3,3000,0,15,-20),(13,3,8,10,900,1900,19,-20),(14,7,11,5,2500,0,17,-20),(15,5,8,6,2100,80,16,-20),
  (16,10,5,7,2900,180,16,20),(17,11,6,5,3400,0,18,20),(18,4,3,11,1000,2300,21,20),(19,13,4,4,3800,0,19,20),(20,9,4,8,3100,70,17,20);

-- Match 3 stats
INSERT INTO match_player_stats(match_player_id, kills, deaths, assists, damage_dealt, healing_done, abilities_used, mmr_delta) VALUES
  (21,9,2,8,2950,120,16,20),(22,14,3,5,3650,0,19,20),(23,3,5,13,850,2400,23,20),(24,16,2,2,4400,0,21,20),(25,11,4,6,3350,90,18,20),
  (26,5,11,6,2350,190,15,-20),(27,7,9,5,2950,0,17,-20),(28,2,8,9,750,1950,21,-20),(29,6,13,7,2150,0,16,-20),(30,8,10,4,2750,60,19,-20);

-- Match 4 stats
INSERT INTO match_player_stats(match_player_id, kills, deaths, assists, damage_dealt, healing_done, abilities_used, mmr_delta) VALUES
  (31,7,4,7,2700,140,14,20),(32,13,3,6,3550,0,18,20),(33,4,4,11,950,2150,20,20),(34,14,3,5,4000,0,20,20),(35,10,3,8,3250,110,17,20),
  (36,6,10,5,2400,170,15,-20),(37,8,9,4,3050,0,17,-20),(38,3,7,10,850,2000,22,-20),(39,7,12,6,2300,0,16,-20),(40,9,10,5,2850,55,18,-20);

-- Match 5 stats
INSERT INTO match_player_stats(match_player_id, kills, deaths, assists, damage_dealt, healing_done, abilities_used, mmr_delta) VALUES
  (41,5,11,5,2200,110,14,-20),(42,7,10,4,2900,0,16,-20),(43,2,9,11,800,2100,20,-20),(44,6,13,7,2100,0,15,-20),(45,8,11,6,2700,75,17,-20),
  (46,11,4,8,3100,160,17,20),(47,12,5,6,3500,0,19,20),(48,5,3,12,1100,2350,24,20),(49,15,3,4,4100,0,21,20),(50,10,4,9,3200,95,18,20);

-- Match 6 stats
INSERT INTO match_player_stats(match_player_id, kills, deaths, assists, damage_dealt, healing_done, abilities_used, mmr_delta) VALUES
  (51,10,3,7,3000,135,16,20),(52,13,4,5,3600,0,18,20),(53,4,4,12,950,2250,21,20),(54,15,2,4,4150,0,20,20),(55,11,3,7,3300,100,17,20),
  (56,6,11,6,2450,165,15,-20),(57,8,10,5,3100,0,17,-20),(58,3,8,11,900,2050,23,-20),(59,7,13,7,2350,0,16,-20),(60,9,11,5,2900,65,18,-20);

-- Match 7 stats
INSERT INTO match_player_stats(match_player_id, kills, deaths, assists, damage_dealt, healing_done, abilities_used, mmr_delta) VALUES
  (61,5,12,6,2250,115,14,-20),(62,7,11,5,2950,0,16,-20),(63,2,10,12,850,2150,21,-20),(64,6,14,8,2200,0,15,-20),(65,8,12,7,2750,80,17,-20),
  (66,12,5,7,3200,155,17,20),(67,14,6,4,3700,0,19,20),(68,5,4,13,1050,2400,25,20),(69,16,4,3,4250,0,21,20),(70,11,5,8,3350,105,18,20);

-- Match 8 stats
INSERT INTO match_player_stats(match_player_id, kills, deaths, assists, damage_dealt, healing_done, abilities_used, mmr_delta) VALUES
  (71,9,4,8,2900,125,16,20),(72,12,5,6,3450,0,18,20),(73,4,5,13,1000,2300,22,20),(74,14,3,5,3950,0,20,20),(75,10,4,9,3150,105,17,20),
  (76,6,11,7,2500,175,15,-20),(77,8,10,6,3150,0,17,-20),(78,3,9,12,950,2100,24,-20),(79,7,13,8,2400,0,16,-20),(80,9,11,6,2950,70,18,-20);

-- Match 9 stats
INSERT INTO match_player_stats(match_player_id, kills, deaths, assists, damage_dealt, healing_done, abilities_used, mmr_delta) VALUES
  (81,10,4,9,3050,140,16,20),(82,13,5,7,3550,0,18,20),(83,5,5,14,1100,2450,23,20),(84,15,4,6,4050,0,20,20),(85,11,5,10,3250,110,17,20),
  (86,7,12,8,2550,180,15,-20),(87,9,11,7,3200,0,17,-20),(88,4,10,13,1000,2150,25,-20),(89,8,14,9,2450,0,16,-20),(90,10,12,7,3000,75,18,-20);

-- Match 10 stats
INSERT INTO match_player_stats(match_player_id, kills, deaths, assists, damage_dealt, healing_done, abilities_used, mmr_delta) VALUES
  (91,6,13,9,2350,120,14,-20),(92,8,12,8,3050,0,16,-20),(93,3,11,14,950,2250,22,-20),(94,7,15,10,2300,0,15,-20),(95,9,13,8,2850,85,17,-20),
  (96,13,6,10,3300,165,17,20),(97,15,7,6,3800,0,19,20),(98,6,5,15,1150,2500,26,20),(99,17,5,5,4350,0,21,20),(100,12,6,11,3400,115,18,20);

-- Match 11 stats
INSERT INTO match_player_stats(match_player_id, kills, deaths, assists, damage_dealt, healing_done, abilities_used, mmr_delta) VALUES
  (101,11,5,11,3100,145,16,20),(102,14,6,8,3600,0,18,20),(103,6,6,16,1200,2550,24,20),(104,16,5,7,4150,0,20,20),(105,12,6,12,3350,120,17,20),
  (106,8,13,10,2600,185,15,-20),(107,10,12,9,3250,0,17,-20),(108,5,11,15,1050,2200,26,-20),(109,9,15,11,2500,0,16,-20),(110,11,13,8,3050,80,18,-20);

-- Match 12 stats
INSERT INTO match_player_stats(match_player_id, kills, deaths, assists, damage_dealt, healing_done, abilities_used, mmr_delta) VALUES
  (111,10,6,12,3000,135,16,20),(112,13,7,9,3500,0,18,20),(113,6,7,17,1150,2500,25,20),(114,15,6,8,4050,0,20,20),(115,11,7,13,3250,115,17,20),
  (116,8,14,11,2550,180,15,-20),(117,10,13,10,3200,0,17,-20),(118,5,12,16,1000,2250,27,-20),(119,9,16,12,2450,0,16,-20),(120,11,14,9,3000,85,18,-20);

-- Match 13 stats
INSERT INTO match_player_stats(match_player_id, kills, deaths, assists, damage_dealt, healing_done, abilities_used, mmr_delta) VALUES
  (121,12,7,13,3150,150,16,20),(122,14,8,10,3650,0,18,20),(123,7,8,18,1250,2600,26,20),(124,16,7,9,4200,0,20,20),(125,12,8,14,3350,125,17,20),
  (126,9,15,12,2650,190,15,-20),(127,11,14,11,3300,0,17,-20),(128,6,13,17,1100,2300,28,-20),(129,10,17,13,2550,0,16,-20),(130,12,15,10,3100,90,18,-20);

-- Match 14 stats
INSERT INTO match_player_stats(match_player_id, kills, deaths, assists, damage_dealt, healing_done, abilities_used, mmr_delta) VALUES
  (131,7,16,14,2450,125,14,-20),(132,9,15,12,3150,0,16,-20),(133,4,14,18,1000,2350,23,-20),(134,8,18,14,2400,0,15,-20),(135,10,16,11,2950,90,17,-20),
  (136,15,8,14,3400,170,17,20),(137,16,9,11,3900,0,19,20),(138,8,7,19,1300,2650,27,20),(139,18,8,10,4450,0,21,20),(140,13,9,15,3500,130,18,20);

-- Match 15 stats
INSERT INTO match_player_stats(match_player_id, kills, deaths, assists, damage_dealt, healing_done, abilities_used, mmr_delta) VALUES
  (141,13,9,15,3250,160,16,20),(142,15,10,12,3750,0,18,20),(143,8,9,20,1350,2700,28,20),(144,17,9,11,4300,0,20,20),(145,13,10,16,3450,135,17,20),
  (146,10,17,15,2700,195,15,-20),(147,12,16,13,3350,0,17,-20),(148,6,14,19,1150,2400,29,-20),(149,11,18,15,2600,0,16,-20),(150,13,16,12,3150,95,18,-20);

-- ============================================================
-- ENTITLEMENTS (grant items to various players)
-- ============================================================
INSERT INTO entitlement(entitlement_id, player_id, item_id, quantity, status) VALUES
  (1,1,1,5,'active'),(2,1,2,1,'active'),(3,1,3,1,'active'),
  (4,2,1,3,'active'),(5,2,8,1,'active'),(6,2,12,1,'active'),
  (7,3,4,10,'active'),(8,3,7,1,'active'),(9,3,13,2,'active'),
  (10,5,2,1,'active'),(11,5,9,1,'active'),(12,5,10,3,'active'),
  (13,8,1,8,'active'),(14,8,6,1,'active'),(15,8,15,1,'active'),
  (16,10,5,1,'active'),(17,10,11,1,'active'),(18,10,16,5,'active'),
  (19,12,14,1,'active'),(20,12,18,1,'active'),(21,12,20,1,'active'),
  (22,15,2,1,'active'),(23,15,9,1,'active'),(24,15,17,1,'active'),
  (25,20,1,6,'active'),(26,20,4,7,'active'),(27,20,19,1,'active'),
  (28,25,3,1,'active'),(29,25,7,1,'active'),(30,25,12,1,'active'),
  (31,30,5,1,'active'),(32,30,11,1,'active'),(33,30,15,1,'active'),
  (34,35,6,1,'active'),(35,35,14,1,'active'),(36,35,18,1,'active'),
  (37,40,1,4,'active'),(38,40,8,1,'active'),(39,40,13,2,'active'),
  (40,45,2,1,'active'),(41,45,9,1,'active'),(42,45,17,1,'active'),
  (43,50,20,1,'active'),(44,50,18,1,'active'),(45,50,14,1,'active');

-- ============================================================
-- TRANSACTIONS (purchase/reward history)
-- ============================================================
INSERT INTO txn(txn_id, player_id, item_id, currency, amount, quantity, source) VALUES
  (1,1,2,'GC',500,1,'store'),(2,1,1,'GC',50,5,'store'),(3,1,3,'GC',1000,1,'quest'),
  (4,2,8,'GC',100,1,'store'),(5,2,12,'GC',300,1,'quest'),(6,2,1,'GC',30,3,'store'),
  (7,3,7,'GC',400,1,'store'),(8,3,4,'GC',100,10,'store'),(9,3,13,'GC',80,2,'quest'),
  (10,5,2,'GC',500,1,'store'),(11,5,9,'GC',800,1,'quest'),(12,5,10,'GC',150,3,'store'),
  (13,8,6,'GC',2000,1,'quest'),(14,8,15,'GC',900,1,'store'),(15,8,1,'GC',80,8,'store'),
  (16,10,5,'GC',850,1,'quest'),(17,10,11,'GC',800,1,'store'),(18,10,16,'GC',50,5,'store'),
  (19,12,14,'GC',2500,1,'quest'),(20,12,18,'GC',3000,1,'quest'),(21,12,20,'GC',3500,1,'quest'),
  (22,15,2,'GC',500,1,'store'),(23,15,9,'GC',800,1,'store'),(24,15,17,'GC',350,1,'quest'),
  (25,20,19,'GC',450,1,'store'),(26,20,1,'GC',60,6,'store'),(27,20,4,'GC',70,7,'store'),
  (28,25,3,'GC',1000,1,'quest'),(29,25,7,'GC',400,1,'store'),(30,25,12,'GC',300,1,'store'),
  (31,30,5,'GC',850,1,'store'),(32,30,11,'GC',800,1,'quest'),(33,30,15,'GC',900,1,'store'),
  (34,35,6,'GC',2000,1,'quest'),(35,35,14,'GC',2500,1,'quest'),(36,35,18,'GC',3000,1,'quest'),
  (37,40,8,'GC',100,1,'store'),(38,40,13,'GC',80,2,'store'),(39,40,1,'GC',40,4,'store'),
  (40,45,2,'GC',500,1,'quest'),(41,45,9,'GC',800,1,'store'),(42,45,17,'GC',350,1,'store'),
  (43,50,20,'GC',3500,1,'quest'),(44,50,18,'GC',3000,1,'quest'),(45,50,14,'GC',2500,1,'quest');
