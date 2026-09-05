# ============================================================
# Visualizations
# Behavioral Determinants of Retaliation in EuroLeague Basketball
# ============================================================


# ============================================================
# Figure 4.1: Effect of Patience on Free-Throw Rate
# ============================================================

pat_effect <- effects::effect(
  "patience_qje",
  model1
)

plot(
  pat_effect,
  main = "",
  xlab = "Patience",
  ylab = "Predicted FT Rate"
)


# ============================================================
# Figure 4.2: Steals × Negative Reciprocity
# ============================================================

df_plot <- df %>%
  filter(!is.na(negrecip)) %>%
  mutate(
    neg_group = ifelse(
      negrecip > median(negrecip, na.rm = TRUE),
      "High Negative Reciprocity",
      "Low Negative Reciprocity"
    )
  )

ggplot(
  df_plot,
  aes(
    x = steals,
    y = fouls_commited,
    color = neg_group,
    fill = neg_group
  )
) +
  geom_smooth(
    method = "lm",
    se = TRUE,
    linewidth = 1.3,
    alpha = 0.20
  ) +
  labs(
    x = "Steals",
    y = "Predicted Fouls Committed",
    color = "Negative Reciprocity",
    fill = "Negative Reciprocity"
  ) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "right")


# ============================================================
# Figure 4.3: Effect of Patience on Fouls Received
# ============================================================

pat_eff <- effects::effect(
  "patience_qje",
  model4
)

plot(
  pat_eff,
  main = "",
  xlab = "Patience",
  ylab = "Predicted Fouls Received"
)


# ============================================================
# Figure 4.4: Fouls Received × Negative Reciprocity
# ============================================================

df_neg <- df %>%
  filter(!is.na(negrecip)) %>%
  mutate(
    neg_group = ifelse(
      negrecip > median(negrecip, na.rm = TRUE),
      "High Negative Reciprocity",
      "Low Negative Reciprocity"
    )
  )

ggplot(
  df_neg,
  aes(
    x = fouls_received,
    y = fouls_commited,
    color = neg_group,
    fill = neg_group
  )
) +
  geom_smooth(
    method = "lm",
    se = TRUE,
    linewidth = 1.3,
    alpha = 0.20
  ) +
  labs(
    x = "Fouls Received",
    y = "Predicted Fouls Committed",
    color = "Negative Reciprocity",
    fill = "Negative Reciprocity"
  ) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "right")


# ============================================================
# Figure 4.5: Fouls Received × Negative Reciprocity × Patience
# ============================================================

df_threeway <- df %>%
  filter(
    !is.na(negrecip),
    !is.na(patience_qje)
  ) %>%
  mutate(
    neg_group = ifelse(
      negrecip > median(negrecip, na.rm = TRUE),
      "High NegRecip",
      "Low NegRecip"
    ),
    patience_group = case_when(
      patience_qje <= quantile(
        patience_qje,
        0.33,
        na.rm = TRUE
      ) ~ "Low Patience",

      patience_qje <= quantile(
        patience_qje,
        0.66,
        na.rm = TRUE
      ) ~ "Medium Patience",

      TRUE ~ "High Patience"
    )
  )

df_threeway$pred <- predict(
  model6,
  newdata = df_threeway
)

ggplot(
  df_threeway,
  aes(
    x = fouls_received,
    y = pred,
    color = neg_group,
    fill = neg_group
  )
) +
  geom_smooth(
    method = "lm",
    se = TRUE,
    linewidth = 1
  ) +
  facet_wrap(~ patience_group) +
  labs(
    x = "Fouls Received",
    y = "Predicted Fouls Committed",
    color = "Negative Reciprocity",
    fill = "Negative Reciprocity"
  ) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "right")


# ============================================================
# Figure 4.6: Fouls Received × Patience
# ============================================================

df_patience <- df %>%
  filter(!is.na(patience_qje)) %>%
  mutate(
    pat_group = ifelse(
      patience_qje > median(
        patience_qje,
        na.rm = TRUE
      ),
      "High Patience",
      "Low Patience"
    )
  )

df_patience$pred <- predict(
  model7,
  newdata = df_patience
)

ggplot(
  df_patience,
  aes(
    x = fouls_received,
    y = pred,
    color = pat_group,
    fill = pat_group
  )
) +
  geom_smooth(
    method = "lm",
    se = TRUE,
    linewidth = 1.2
  ) +
  labs(
    x = "Fouls Received",
    y = "Predicted Fouls Committed",
    color = "Patience Level",
    fill = "Patience Level"
  ) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "right")


# ============================================================
# Figure 4.7: Retaliation by Experience Group
# ============================================================

experience_plot <- expand.grid(
  fouls_received = seq(
    min(df$fouls_received, na.rm = TRUE),
    max(df$fouls_received, na.rm = TRUE),
    length.out = 200
  ),
  patience_qje = mean(
    df$patience_qje,
    na.rm = TRUE
  ),
  exp_group = c(
    "Non-veteran (≤5 seasons)",
    "Veteran (6+ seasons)"
  ),
  turnovers = mean(
    df$turnovers,
    na.rm = TRUE
  ),
  minutes = mean(
    df$minutes,
    na.rm = TRUE
  )
)

experience_pred <- predict(
  model9,
  newdata = experience_plot,
  interval = "confidence"
)

experience_plot$fit <- experience_pred[, "fit"]
experience_plot$lwr <- experience_pred[, "lwr"]
experience_plot$upr <- experience_pred[, "upr"]

ggplot(
  experience_plot,
  aes(
    x = fouls_received,
    y = fit,
    color = exp_group,
    fill = exp_group
  )
) +
  geom_line(linewidth = 1.2) +
  geom_ribbon(
    aes(
      ymin = lwr,
      ymax = upr
    ),
    alpha = 0.15,
    color = NA
  ) +
  labs(
    x = "Fouls Received",
    y = "Predicted Fouls Committed",
    color = "Experience Group",
    fill = "Experience Group"
  ) +
  theme_minimal(base_size = 14)


# ============================================================
# Figure 4.8: Actual vs Predicted Retaliation — Jan Vesely
# ============================================================

vesely <- df %>%
  filter(player == "VESELY, JAN")

vesely$pred <- predict(
  model9,
  newdata = vesely
)

vesely_pred_smooth <- vesely %>%
  group_by(
    season_code,
    fouls_received
  ) %>%
  summarise(
    mean_pred = mean(
      pred,
      na.rm = TRUE
    ),
    .groups = "drop"
  )

ggplot() +
  geom_point(
    data = vesely,
    aes(
      x = fouls_received,
      y = fouls_commited,
      color = "Actual"
    ),
    alpha = 0.6
  ) +
  geom_line(
    data = vesely_pred_smooth,
    aes(
      x = fouls_received,
      y = mean_pred,
      color = "Predicted"
    ),
    linewidth = 1.2
  ) +
  facet_wrap(~ season_code) +
  labs(
    x = "Fouls Received",
    y = "Fouls Committed",
    color = ""
  ) +
  theme_minimal(base_size = 14)


# ============================================================
# Figure 4.9: Actual vs Predicted Retaliation — Shane Larkin
# ============================================================

larkin <- df %>%
  filter(player == "LARKIN, SHANE")

larkin$pred <- predict(
  model9,
  newdata = larkin
)

larkin_pred_smooth <- larkin %>%
  group_by(
    season_code,
    fouls_received
  ) %>%
  summarise(
    mean_pred = mean(
      pred,
      na.rm = TRUE
    ),
    .groups = "drop"
  )

ggplot() +
  geom_point(
    data = larkin,
    aes(
      x = fouls_received,
      y = fouls_commited,
      color = "Actual"
    ),
    alpha = 0.6
  ) +
  geom_line(
    data = larkin_pred_smooth,
    aes(
      x = fouls_received,
      y = mean_pred,
      color = "Predicted"
    ),
    linewidth = 1.2
  ) +
  facet_wrap(~ season_code) +
  labs(
    x = "Fouls Received",
    y = "Fouls Committed",
    color = ""
  ) +
  theme_minimal(base_size = 14)
