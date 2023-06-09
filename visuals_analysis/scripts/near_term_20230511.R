# --------------------------------------------------------------------
# 2.)	Coastal Facilities Impacted in the Near-Term
# •	Stacked bar chart, if possible add the total number of facilities at the top of each of the 8 columns
# •	X-axis: Facility Type (use Asset_Broad)
# •	Y-axis: Number of Facilities
# •	Symbolize by three colors: Erosion, Inundation, and Both
# o	Erosion (Select all features with Hazard_Erosion, but exclude any erosion ones that have Hazard_Inundation OR Hazard_FEMA)
# o	Inundation (Select all with Hazard_Inundation OR Hazard_FEMA, but exclude any inundation ones that have Hazard_Erosion)
# o	Both (Select those with Hazard_Erosion AND Hazard_Inundation OR Hazard_FEMA)


library(tidyverse)
source("visuals_analysis/scripts/src/functions.R")

file.pattern <- "20230511"

relevant.column <- c("OID_", "ParkName", "Asset_Broad", "Asset_Detail", "Z_relToMHHW_FT", 
                     "SensitivityScore", "CoastEros_Score", "CoastInund_Score", "ExposureScore", "VulnerabilityScore",
                     "Hazard_Erosion",  "Hazard_Inundation", "Hazard_FEMA", "Hazard_Any")

# Import all files --------------------------------------------------
filenames <- RemoveCsv(list.files(path = "visuals_analysis/data_raw", pattern = file.pattern))

for (i in filenames) {
  filepath <- file.path("visuals_analysis/data_raw", paste(i, ".csv", sep = ""))
  assign(make.names(i), read.csv(filepath, stringsAsFactors = FALSE, check.names = TRUE))
}


polygons <- Scored_WA_Parks_Facilities_20230511_polygons %>%
  select(any_of(relevant.column)) %>%
  mutate(feature_class = "polygon")
lines <- Scored_WA_Parks_Facilities_20230511_lines %>%
  select(any_of(relevant.column)) %>%
  mutate(feature_class = "line")
points <- Scored_WA_Parks_Facilities_20230511_points %>%
  select(2, any_of(relevant.column)) %>%
  rename(ParkLocation = 1) %>%
  mutate(feature_class = "point")
locations <- points %>%
  select(ParkLocation, ParkName) %>%
  unique()

parks.data <- polygons %>%
  rbind(lines) %>%
  rbind(points %>% select(-ParkLocation)) %>%
  left_join(locations, by = "ParkName") %>%
  select(ParkName, ParkLocation, everything()) %>%
  mutate(ParkLocation2 = case_when(
    (ParkName == "Clallam Bay") ~ "Pacific Coast",
    (ParkName == "Lilliwaup Tidelands") ~ "Puget Sound",
    (ParkName == "North Jetty") ~ "Pacific Coast",
    (ParkName == "Shine Tidelands") ~ "Puget Sound")) %>%
  mutate(ParkLocation = ifelse(is.na(ParkLocation), ParkLocation2, ParkLocation))


# Graph -------------------------------------------------------------------

group.colors <- c(Erosion = "#DBA827", Inundation = "#04A1FF", Both ='#3ECDA3')

asset <- parks.data %>%
  select(-feature_class, -ParkLocation2)

# o	Erosion 
# Select all features with Hazard_Erosion, 
# but exclude any erosion ones that have Hazard_Inundation OR Hazard_FEMA)
erosion <- asset %>%
  select(-ParkName, -ParkLocation) %>%
  filter(Hazard_Erosion == 1) %>%
  filter(Hazard_FEMA != 1) %>%
  filter(Hazard_Inundation != 1) %>%
  select(1:2) %>%
  group_by(Asset_Broad) %>%
  mutate(facility_count = n()) %>%
  mutate(hazard_type = "Erosion") %>%
  unique() %>%
  select(Asset_Broad, facility_count, hazard_type)

# o	Inundation 
# Select all with Hazard_Inundation OR Hazard_FEMA, 
# but exclude any inundation ones that have Hazard_Erosion)
inundation <- asset %>%
  select(-ParkName, -ParkLocation) %>%
  filter(Hazard_Inundation == 1 | Hazard_FEMA == 1) %>%
  filter(Hazard_Erosion != 1) %>%
  group_by(Asset_Broad) %>%
  mutate(facility_count = n()) %>%
  mutate(hazard_type = "Inundation") %>%
  select(Asset_Broad, facility_count, hazard_type) %>%
  unique()

# o	Both (Select those with Hazard_Erosion AND Hazard_Inundation OR Hazard_FEMA)
both <- asset %>%
  select(-ParkName, -ParkLocation) %>%
  filter(Hazard_Inundation == 1 & Hazard_Erosion == 1) %>%
  group_by(Asset_Broad) %>%
  mutate(facility_count = n()) %>%
  mutate(hazard_type = "Both") %>%
  select(Asset_Broad, facility_count, hazard_type) %>%
  unique()

toplot <- both %>%
  rbind(erosion) %>%
  rbind(inundation) %>%
  group_by(Asset_Broad) %>%
  mutate(complete_count = sum(facility_count))
toplot[toplot == "Shoreline"] <- "Shoreline Armor"


near.term <- ggplot(toplot, aes(fill=factor(hazard_type, levels = c("Erosion", "Inundation", "Both")),
                                            y=facility_count, 
                                            x=reorder(Asset_Broad, - complete_count)),
       labels = labels) + 
  geom_bar(position="stack", stat="identity") +
  theme(axis.text.x = element_text(angle=45, vjust=1, hjust=1)) +
  scale_fill_manual(values=group.colors) +
  xlab("Coastal Facility Type") +
  ylab("Number of Coastal Facilities") +
  labs(fill = "Hazard Type") +
  ggtitle("Coastal Facilities Exposed in the Near-Term to Inundation and/or Erosion")
near.term

ggsave("visuals_analysis/figures/20230511_NearTermInundation.png", near.term, width = 130,
       height = 130, units = "mm")
