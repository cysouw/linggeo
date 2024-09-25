# R code for the figures in the paper

library(sf)
library(qlcVisualize)
library(rnaturalearth)
library(readxl)

# ===
# projectionsGermany: different projections of Germany
# ===

# download boundary data
deu <- rnaturalearth::ne_countries(scale = 50, country = "Germany")$geometry

# longlat
deu_longlat <- sf::st_transform(deu, "EPSG:3857")
plot(deu_longlat - sf::st_centroid(deu_longlat))

# mollweide, but scaled and centered
deu_mollweide <- sf::st_transform(deu, "ESRI:54009")
scale <- as.numeric(sf::st_area(deu_longlat) / sf::st_area(deu_mollweide))
centre <- sf::st_centroid(deu_mollweide)
plot(
  (deu_mollweide - centre) * sqrt(scale)
  , add = TRUE
  , border = "red"
)

# azimuthal, but scaled and centered
deu_azimuthal <- sf::st_transform(deu, "ESRI:54032")
scale <- as.numeric(sf::st_area(deu_longlat) / sf::st_area(deu_azimuthal))
centre <- sf::st_centroid(deu_azimuthal)
plot(
  (deu_azimuthal - centre) * sqrt(scale)
  , add = TRUE
  , border = "blue"
)

# ===
# projectionsWorld: different projections of the world
# ===

# use worldmap from the qlcVisualize package
data(world, package = "qlcVisualize")

# plot settings
op <- par(mfrow = c(2, 2), mar = c(0, 0, 0, 0), family = "Libertinus Serif")

# longlat
plot(sf::st_transform(world, "+proj=longlat +lon_0=11.5"))
title("Simple longitude-latitude projection ('longlat')
  Longitude rotated 11.5°", line = -3)
# imol
plot(sf::st_transform(world, "+proj=imoll +lon_0=11.5"))
title("Interrupted Mollweide projection ('imoll')
  Longitude rotated 11.5°", line = -3)
# eqearth
plot(sf::st_transform(world, "+proj=eqearth +lon_0=151"))
title("Equal Earth projection ('eqearth')
  Longitude rotated 151°", line = -2)
# aeqd
plot(sf::st_transform(world, "+proj=aeqd +lat_0=90 +lon_0=45"))
title("Azimuthal Equidistant projection ('aeqd')
  Longitude rotated 45°, Latitude rotated 90°", line = -2)

# restore default settings
par(op)

# ===
# equalArea: projection weighted by number of languages
# ===

# The computations for these figures are rather unstable.
# Often errors are returned, then just try again.
# Plotting often leads to crashes of R for some unclear reason.

# use worldmap from the qlcVisualize package
data(world, package = "qlcVisualize")

# projection
mollweide <- "+proj=imoll +lon_0=11.5"
azimuth <- "+proj=aeqd +lat_0=90 +lon_0=45"

# glottolog data version 5, downloaded 29 Juli 2024
g <- read.csv("sources/glottolog2024/languoid.csv")
lang <- g[g$level == "language", ]
lang <- lang[lang$bookkeeping != "True", ]
lang <- lang[!is.na(lang$longitude), ]
coor <- sf::st_as_sf(lang, coords = c("longitude", "latitude"), crs = 4326)

# The map appears to be too complex for the cartogram to converge
# Doing it in multiple steps mostly seems to work better

# preparation
w1 <- qlcVisualize::wmap(
  coor
  , window = world
  , crs = mollweide
  , maxit = 3
  , verbose = 1
)
# weighting by language
w2 <- qlcVisualize::wmap(
  w1$weightedPoints
  , window = w1$weightedWindow
  , crs = mollweide
  , maxit = 15
  , verbose = 1
)

# save data
g <- sf::st_sf(
  points = w1$points
  , voronoi = w1$voronoi
  , weightedPoints = w2$weightedPoints
  , weightedVoronoi = w2$weightedVoronoi
  , lang[c(1, 2, 4, 9)]
  , w2[c(3, 6)]
)
save(g, file = "data/equalArea.RData")

# plot settings
fill <- "grey90"
lines <- 0.3

# plot
op <- par(mfrow = c(2, 1), mar = c(0, 0, 0, 0), family = "Libertinus Serif")
# no cartogram
plot(g$voronoi, col = fill, lwd = lines)
title("Voronoi diagram of all glottolog languages", line = -1)
# equal weights per language
plot(g$weightedVoronoi, col = fill, lwd = lines)
title("Weighting all polygons to have equal surface", line = -1)
# restore default settings
par(op)

# ===
# weightedLanguages: other examples of weighting
# ===

# weighting by family
# languages without classification are treated as isolates
empty <- which(coor$family_id == "")
coor[empty, "family_id"] <- coor$id[empty]
familyWeight <- 1 / (log(table(coor$family_id)) + 1)
weights <- as.numeric(familyWeight[coor$family_id])

data <- sf::st_sf(geometry = w2$weightedVoronoi, weigths = weights)
w3 <- cartogramR::cartogramR(
  data
  , count = "weigths"
  , method = "dcn"
  , options = list(maxit = 100, verbose = 1)
)

# save data
families <- sf::st_sf(
  weightedVoronoi = w3$cartogram$geometry
  , coor[c(1, 2, 4)]
  , weights = weights
)
save(families, file = "data/weightedFamilies.RData")
plot(families$weightedVoronoi, col = "grey90", lwd = 0.3)

# weighting by WALS genus
# WALS data downloaded 29 Juli 2024
wals <- read.csv("sources/wals2013/languages.csv")
wals$Glottocode[wals$Glottocode == "tuka1247"] <- "tuka1248"
wals$Glottocode[wals$Glottocode == "bali1280"] <- "unea1237"
wals <- merge(
  coor[, c("id", "geometry")],
  wals[, c("ID", "Name", "Glottocode", "Genus")],
  by.x = "id",
  by.y = "Glottocode"
)
colnames(wals)[1:2] <- c("Glottocode", "WALScode")
genusWeight <- 1 / table(wals$Genus)
weights <- as.numeric(genusWeight[wals$Genus])^0.5

# preparation
w4 <- qlcVisualize::wmap(
  wals
  , window = world
  , crs = mollweide
  , weights = weights
  , maxit = 5
  , verbose = 1
)
# weighting by genus
w5 <- qlcVisualize::wmap(
  w4$weightedPoints
  , window = w4$weightedWindow
  , crs = mollweide
  , weights = weights
  , maxit = 10
  , verbose = 1
)
# another round of cartogram
data <- sf::st_sf(geometry = w5$weightedVoronoi, weigths = weights)
w6 <- cartogramR::cartogramR(
  data
  , count = "weigths"
  , method = "dcn"
  , options = list(maxit = 100, verbose = 1)
)

# save data
genera <- sf::st_sf(
  weightedVoronoi = w6$cartogram$geometry
  , wals[1:4]
  , weights = weights
)
save(genera, file = "data/weightedGenera.RData")
plot(genera$weightedVoronoi, col = "grey90", lwd = 0.3)

# weighting by population
# population data from amano (2014)
pop <- readxl::read_xls("sources/amano2014/rspb20141574supp2.xls")
pop <- merge(
  coor[, c("id", "name", "iso639P3code", "geometry")],
  pop[, c("Language ISO", "Population size")],
  by.x = "iso639P3code",
  by.y = "Language ISO"
)
colnames(pop)[1:4] <- c("iso639", "glottocode", "name", "population")
pop <- pop[!is.na(pop$population), ]
weights <- ceiling(log10(pop$population + 1))^3

# preparation
w7 <- qlcVisualize::wmap(
  pop
  , window = world
  , crs = mollweide
  , weights = weights
  , maxit = 3
  , verbose = 1
)
# weighting by speakers
w8 <- qlcVisualize::wmap(
  w7$weightedPoints
  , window = w7$weightedWindow
  , crs = mollweide
  , weights = weights
  , maxit = 5
  , verbose = 1
)
# another round of cartogram
data <- sf::st_sf(geometry = w8$weightedVoronoi, weigths = weights)
w9 <- cartogramR::cartogramR(
  data
  , count = "weigths"
  , method = "dcn"
  , options = list(maxit = 30, verbose = 1)
)
# save data
population <- sf::st_sf(
  weightedVoronoi = w9$cartogram$geometry
  , pop[1:4]
  , weights = weights
)
save(population, file = "data/weightedPopulation.RData")

plot(population$weightedVoronoi, col = "grey90", lwd = 0.3)

# plot settings
fill <- "grey90"
lines <- 0.3
# plotting
op <- par(mfrow = c(3, 1), mar = c(0, 0, 1, 0), family = "Libertinus Serif")
# glottolog family weighting
plot(families$weightedVoronoi, col = fill, lwd = lines)
title("Weighting all families from Glottolog equally")
# WALS genera weighting
plot(genera$weightedVoronoi, col = fill, lwd = lines)
title("Weighting all genera from WALS equally")
# Population weighting
plot(population$weightedVoronoi, col = fill, lwd = lines)
title("Weighting languages by logarithm of number of speakers")
# restore default settings
par(op)