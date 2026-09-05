# ============================================================
# Regression Models
# Behavioral Determinants of Retaliation in EuroLeague Basketball
# ============================================================
# ============================================================
# Model 1: Patience and Free-Throw Efficiency
# ============================================================

model1 <- lm(
  ft_rate ~ patience_qje +
    total_rebounds +
    steals +
    turnovers +
    free_throws_attempted +
    minutes +
    height_cm +
    age +
    race,
  data = df
)

summary(model1)

# Robust standard errors
model1_robust <- lmtest::coeftest(
  model1,
  vcov = sandwich::vcovHC(model1, type = "HC1")
)

model1_robust
# ============================================================
# Model 2: Steals × Negative Reciprocity
# ============================================================

model2 <- lm(
  fouls_commited ~ steals * negrecip +
    turnovers +
    free_throws_attempted +
    minutes +
    height_cm +
    age +
    race,
  data = df
)

summary(model2)

# Robust standard errors
model2_robust <- lmtest::coeftest(
  model2,
  vcov = sandwich::vcovHC(model2, type = "HC1")
)

model2_robust
# ============================================================
# Model 3: Risk-Taking and Fouls Committed
# ============================================================

model3 <- lm(
  fouls_commited ~ risktaking +
    field_goals_made2 +
    field_goals_made3 +
    minutes +
    height_cm +
    age +
    race,
  data = df
)

summary(model3)

# Robust standard errors
model3_robust <- lmtest::coeftest(
  model3,
  vcov = sandwich::vcovHC(model3, type = "HC1")
)

model3_robust
# ============================================================
# Model 4: Patience and Fouls Received
# ============================================================

model4 <- lm(
  fouls_received ~ patience_qje +
    field_goals_made2 +
    field_goals_made3 +
    minutes +
    height_cm +
    age +
    race,
  data = df
)

summary(model4)

# Robust standard errors
model4_robust <- lmtest::coeftest(
  model4,
  vcov = sandwich::vcovHC(model4, type = "HC1")
)

model4_robust
# ============================================================
# Model 5: Fouls Received × Negative Reciprocity
# ============================================================

model5 <- lm(
  fouls_commited ~ fouls_received * negrecip +
    turnovers +
    field_goals_made2 +
    field_goals_made3 +
    minutes +
    height_cm +
    age +
    race,
  data = df
)

summary(model5)

# Robust standard errors
model5_robust <- lmtest::coeftest(
  model5,
  vcov = sandwich::vcovHC(model5, type = "HC1")
)

model5_robust
# ============================================================
# Model 6: Fouls Received × Negative Reciprocity × Patience
# ============================================================

model6 <- lm(
  fouls_commited ~ fouls_received * negrecip * patience_qje +
    turnovers +
    minutes +
    height_cm +
    age +
    race,
  data = df
)

summary(model6)

# Robust standard errors
model6_robust <- lmtest::coeftest(
  model6,
  vcov = sandwich::vcovHC(model6, type = "HC1")
)

model6_robust
# ============================================================
# Model 7: Fouls Received × Patience
# ============================================================

model7 <- lm(
  fouls_commited ~ fouls_received * patience_qje +
    negrecip +
    turnovers +
    minutes +
    height_cm +
    age +
    race,
  data = df
)

summary(model7)

# Robust standard errors
model7_robust <- lmtest::coeftest(
  model7,
  vcov = sandwich::vcovHC(model7, type = "HC1")
)

model7_robust
# ============================================================
# Model 8: Dual Moderation with Age
# ============================================================

model8 <- lm(
  fouls_commited ~ fouls_received * negrecip +
    fouls_received * patience_qje +
    turnovers +
    minutes +
    height_cm +
    age +
    race,
  data = df
)

summary(model8)

# Robust standard errors
model8_robust <- lmtest::coeftest(
  model8,
  vcov = sandwich::vcovHC(model8, type = "HC1")
)

model8_robust
# ============================================================
# Model 9: Fouls Received × Patience × Experience Group
# ============================================================

model9 <- lm(
  fouls_commited ~ fouls_received * patience_qje * exp_group +
    turnovers +
    minutes,
  data = df
)

summary(model9)

# Robust standard errors
model9_robust <- lmtest::coeftest(
  model9,
  vcov = sandwich::vcovHC(model9, type = "HC1")
)

model9_robust
