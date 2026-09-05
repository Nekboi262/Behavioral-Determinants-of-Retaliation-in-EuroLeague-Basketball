# ============================================================
# Data Preparation
# Behavioral Determinants of Retaliation in EuroLeague Basketball
# ============================================================

# Load EuroLeague player-level dataset
final_dataset <- read.csv("data/final_dataset.csv")

# Inspect the dataset
head(final_dataset)
str(final_dataset)
# ============================================================
# Load QJE Cultural Data
# ============================================================

qje <- read_dta("data/QJE.dta")

# ============================================================
# Standardise Country Codes and Merge QJE Data
# ============================================================

# Convert player country names to ISO3 codes
final_dataset <- final_dataset %>%
  mutate(
    player_country = countrycode(
      player_country,
      origin = "country.name",
      destination = "iso3c"
    )
  )

# Merge cultural and behavioral indicators
final_dataset <- final_dataset %>%
  left_join(
    qje,
    by = c("player_country" = "ISO3")
  )

# Clean variable names
df <- final_dataset %>%
  janitor::clean_names()
# ============================================================
# Add Player Birthdates and Calculate Age
# ============================================================

# Load player birthdate data
player_info <- read.csv("data/euroleague_alltime.csv")

# Rename player column to match the main dataset
names(player_info)[3] <- "player"

# Merge birthdates
df <- df %>%
  left_join(
    player_info %>% select(player, birthdate),
    by = "player",
    relationship = "many-to-many"
  )

# Move birthdate next to player name
df <- df %>%
  relocate(birthdate, .after = player)

# Calculate player age at the start of each EuroLeague season
df <- df %>%
  mutate(
    birthdate = as.Date(birthdate),
    season_year = as.numeric(substr(season_code, 2, 5)),
    season_start = ymd(paste0(season_year, "-10-01")),
    age = floor(
      time_length(
        interval(birthdate, season_start),
        "years"
      )
    )
  )
# ============================================================
# Add Player Race
# ============================================================

race_data <- read.csv("data/players.csv")

df <- df %>%
  left_join(
    race_data %>% select(player, race),
    by = "player",
    relationship = "many-to-many"
  )


# ============================================================
# Add Player Height
# ============================================================

# EuroLeague seasons used to retrieve player information
seasons <- paste0("E", 2017:2025)

teams <- getCompetitionTeams(seasons)

height_data <- getTeamPeople(
  seasons,
  teams$TeamCode
)

# Keep players only
height_data <- height_data %>%
  filter(TypeName == "Player")

# Create player-height lookup table
height_lookup <- height_data %>%
  select(PersonName, PersonHeight) %>%
  distinct() %>%
  rename(
    player = PersonName,
    height_cm = PersonHeight
  )

# Merge height with main dataset
df <- df %>%
  left_join(
    height_lookup,
    by = "player",
    relationship = "many-to-many"
  )


# ============================================================
# Create Free-Throw Rate
# ============================================================

df <- df %>%
  mutate(
    ft_rate = free_throws_made / free_throws_attempted
  )
# ============================================================
# Create Experience Groups
# ============================================================

df <- df %>%
  group_by(player) %>%
  arrange(season_code, .by_group = TRUE) %>%
  mutate(
    seasons_so_far = dense_rank(season_code)
  ) %>%
  ungroup()

df <- df %>%
  mutate(
    exp_group = ifelse(
      seasons_so_far > 5,
      "Veteran (6+ seasons)",
      "Non-veteran (≤5 seasons)"
    )
  )
