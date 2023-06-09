## RLionheart
## 21-0771-001
## February 2023
## Shoreline Conservation Areas, Washington State Parks


## Where does the "shore" line cross the MHHW plane? 

# -------------------------------------------------------------------------

#profile.pattern <- "prof"

source("scripts/src/load_packages.R")
source("scripts/src/assign_profile_parks.R")

# How far are those points from the Base Point? -------------------------------------------------
MHHW.dist <- complete.profile %>%
  filter(z == MHHW) %>%
  arrange(profile, year) %>%
  group_by(year) %>%
  mutate(x = mean(x),
         y = mean(y)) %>%
  select(profile, Park, year, BasePoint_X, BasePoint_Y, x, y, z) %>%
  unique() %>%
  group_by(profile, year) %>%
  mutate(MHHW_to_BP = sqrt(((BasePoint_X - x)^2) + ((BasePoint_Y -  y)^2))) %>%
  drop_na() %>%
  group_by(profile) %>%
  mutate(profile_slope = ifelse(MHHW_to_BP[which.min(year)] < MHHW_to_BP[which.max(year)],
                                "Accretion", "Erosion"))


## Plot Overall Change
MHHW.dist.plot <- ggplot(MHHW.dist, aes(x = year, y = MHHW_to_BP,
                                        fill=profile_slope, group = profile_slope)) +
  facet_wrap( ~ profile, scales = "free") +
  geom_bar(position = "dodge", stat = "identity", color = "black") +
  geom_smooth(method = "lm", se = TRUE, color="black") +
  scale_fill_manual(values=c("#04A1FF", "tomato2")) +
  theme(axis.text.x = element_blank()) +
  ggtitle(paste("Profile", profile.pattern, "MHHW Euclidean Distance from BP")) 
MHHW.dist.plot


## Rates of change
MHHW.ROC <- MHHW.dist %>%
  group_by(profile) %>% 
  #######
  select(profile:year, MHHW_to_BP:profile_slope) %>%
  mutate(dummy_year = row_number()) %>%
  mutate(diff_year = dummy_year - lag(dummy_year),  
         diff_growth = MHHW_to_BP - lag(MHHW_to_BP)) %>% 
  mutate(rate_percent = (diff_growth / diff_year)/MHHW_to_BP * 100) %>% 
  #######
  #mutate(pct_change = (MHHW_to_BP/lead(MHHW_to_BP) - 1) * 100) %>%
  mutate(profile_direction = ifelse(rate_percent > 0, "Accretion", "Erosion"))

MHHW.ROC.plot <- ggplot(MHHW.ROC, aes(x = year, y = rate_percent, fill = profile_direction)) +
  facet_wrap( ~ profile, scales = "free") +
  geom_bar(position = "dodge", stat = "identity") +
  scale_fill_manual(values=c("#04A1FF", "tomato2")) +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank()) +
  ggtitle("Erosion and Accretion Rates of Change at the MHHW Mark") 
MHHW.ROC.plot


## Write csv with MHHW rates of change
write.csv(MHHW.ROC %>% select(profile, Park, year, rate_percent),
          "data_secondary/profiles_with_MHHW_ROC.csv", row.names = FALSE)


