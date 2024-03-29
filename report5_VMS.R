
library(icesFO)
library(icesTAF)
library(dplyr)
library(ggplot2)
library(sf)

## Run utilies
source("bootstrap/utilities.r")

# set values for automatic naming of files:
cap_year <- 2021
cap_month <- "November"
ecoreg_code <- "ONA"
ecoreg <- "ONA"

mkdir("report")

# file name utilitiy
source("bootstrap/utilities.r")


ecoregion <-
  sf::st_read("ecoregion.csv",
              options = "GEOM_POSSIBLE_NAMES=WKT", crs = 4326)
ecoregion <- dplyr::select(ecoregion, -WKT)


# read vms fishing effort
effort <-
  sf::st_read("vms_effort.csv",
    options = "GEOM_POSSIBLE_NAMES=wkt", crs = 4326
  )
effort <- dplyr::select(effort, -WKT)

# read vms swept area ratio
sar <-
  st_read( "vms_sar.csv",
    options = "GEOM_POSSIBLE_NAMES=wkt", crs = 4326
  )
sar <- dplyr::select(sar, -WKT)

# ~~~~~~~~~~~~~~~#
# A. Effort map
# ~~~~~~~~~~~~~~~#

gears <- c("Static", "Midwater", "Otter", "Demersal seine")

effort <-
  effort %>%
  dplyr::filter(fishing_category_FO %in% gears) %>%
  dplyr::mutate(
    fishing_category_FO =
      dplyr::recode(fishing_category_FO,
        Static = "Static gears",
        Midwater = "Pelagic trawls and seines",
        Otter = "Bottom otter trawls",
        `Demersal seine` = "Bottom seines"
      ),
    mw_fishinghours = as.numeric(mw_fishinghours)
  ) %>%
  filter(!is.na(mw_fishinghours))

# write layer
write_layer <- function(dat, fname) {
  write_sf(dat, paste0("report/", fname, ".shp"))
  files <- dir("report", pattern = fname, full = TRUE)
  files <- files[tools::file_ext(files) != "png"]
  zip(paste0("report/", fname, ".zip"), files, extras = "-j")
  file.remove(files)
}
write_layer(effort, paste0(year_cap, "_", ecoreg,"_FO_VMS_effort"))

# save plot
plot_effort_map(effort, ecoregion) +
  ggtitle("Average MW Fishing hours 2017-2020")

ggsave(file_name(cap_year,ecoreg_code,"VMS_effort", ext = "png"), path = "report", width = 170, height = 200, units = "mm", dpi = 300)

# ~~~~~~~~~~~~~~~#
# A. Swept area map
# ~~~~~~~~~~~~~~~#

# write layer
write_layer(sar, paste0(year_cap, "_", ecoreg,"_FO_VMS_sar"))

plot_sar_map(sar, ecoregion, what = "surface") +
  ggtitle("Average surface swept area ratio 2017-2020")

ggsave(file_name(cap_year,ecoreg_code,"VMS_sarA", ext = "png"), path = "report", width = 170, height = 200, units = "mm", dpi = 300)

plot_sar_map(sar, ecoregion, what = "subsurface") +
  ggtitle("Average subsurface swept area ratio 2017-2020")

ggsave(file_name(cap_year,ecoreg_code,"VMS_sarB", ext = "png"), path = "report", width = 170, height = 200, units = "mm", dpi = 300)
