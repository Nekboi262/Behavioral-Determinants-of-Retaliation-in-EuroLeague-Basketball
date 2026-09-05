# ============================================================
# Data Preparation
# Behavioral Determinants of Retaliation in EuroLeague Basketball
# ============================================================


# ============================================================
# Load EuroLeague Player-Level Dataset
# ============================================================

final_dataset <- read.csv("data/final_dataset.csv")

# Inspect the dataset
head(final_dataset)
str(final_dataset)


# ============================================================
# Standardise Player Names and Country Codes
# ============================================================

final_dataset <- final_dataset %>%
  mutate(
    # Standardise specific player names
    player = case_when(
      player %in% c("GONZÁLEZ, HUGO", "GONZALEZ, HUGO") ~ "GONZALEZ, HUGO",
      player %in% c("MARÍ, LUCAS", "MARI, LUCAS") ~ "MARI, LUCAS",
      TRUE ~ player
    ),

    # Fill missing/incorrect countries used in the dissertation
    player_country = ifelse(
      player == "GONZALEZ, HUGO", "Spain",
      ifelse(
        player == "MARI, LUCAS", "Spain",
        ifelse(
          player == "McCORMACK, DAVID", "United States",
          player_country
        )
      )
    ),

    # Convert country names to ISO3 codes
    player_country = countrycode(
      player_country,
      origin = "country.name",
      destination = "iso3c"
    )
  )


# ============================================================
# Load and Merge QJE Behavioral Data
# ============================================================

qje <- read_dta("data/QJE.dta")

final_dataset <- final_dataset %>%
  left_join(
    qje,
    by = c("player_country" = "ISO3")
  )

# Standardise column names
df <- final_dataset %>%
  janitor::clean_names()


# ============================================================
# Add Player Birthdates and Calculate Age
# ============================================================

player_info <- read.csv("data/euroleague_alltime.csv")

# Rename player column to match main dataset
names(player_info)[3] <- "player"

df <- df %>%
  left_join(
    player_info %>% select(player, birthdate),
    by = "player",
    relationship = "many-to-many"
  )

df <- df %>%
  relocate(birthdate, .after = player)

# Calculate age at the beginning of each EuroLeague season
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

seasons <- paste0("E", 2017:2025)

teams <- getCompetitionTeams(seasons)

height_data <- getTeamPeople(
  seasons,
  teams$TeamCode
)

# Keep players only
height_data <- height_data %>%
  filter(TypeName == "Player")

# Create player-height lookup
height_lookup <- height_data %>%
  transmute(
    player = PersonName,
    height_cm = as.numeric(PersonHeight)
  ) %>%
  distinct()

# Merge height into main dataset
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
