library(icesTAF)
taf.library(icesFO)

ecoregion <- icesFO::load_ecoregion("Oceanic Northeast Atlantic")

sf::st_write(ecoregion, "bootstrap/data/ICES_ecoregions/ecoregion.csv", layer_options = "GEOMETRY=AS_WKT")
