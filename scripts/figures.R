# R code for the figures in the paper

library(sf)
library(qlcVisualize)
library(rnaturalearth)

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
