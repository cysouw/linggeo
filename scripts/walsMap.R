walsMap <- function() {

  # get data, get glottolog coordinates and correct errors in WALS
  wals <- lingtypology::wals.feature(feature)
  wals$glottocode[wals$glottocode == "poqo1257"] <- "poqo1253"
  wals$glottocode[wals$glottocode == "mamc1234"] <- "mamm1241"
  wals$glottocode[wals$glottocode == "tuka1247"] <- "tuka1248"
  wals$glottocode[wals$glottocode == "bali1280"] <- "unea1237"
  wals <- merge(
    wals[, c("language", "glottocode", "wals.code", feature)],
    lingtypology::glottolog[, c("glottocode", "longitude", "latitude")]
  )

  # calculate an equally-weighted voronoi transformation
  data(world, package = "qlcVisualize")
  v <- qlcVisualize::weightedMap(
    wals$longitude, wals$latitude
    , window = world
    , crs = "+proj=imoll +lon_0=11.5"
    , method = "dcn"
    , maxit = 20
  )

  # prepare data for mapview
  wals[, feature] <- factor(wals[, feature], levels = levs)
  data <- sf::st_sf(wals, geometry = v$weightedVoronoi, crs = v$crs)
  names(height) <- levs

  # add contour lines
  conts <- qlcVisualize::addContour(
    height[wals[, feature]]
    , v$weightedPoints
    , v$weightedWindow
    , v$crs
    , levels = heightArea
    , add = FALSE
  )
  conts$levels <- factor(conts$levels)

  # make interpolation
  interp <- qlcVisualize::addContour(
    height[wals[, feature]]
    , v$weightedPoints
    , v$weightedWindow
    , v$crs
    , levels = seq(min(height), max(height), length.out = nInterp)
    , add = FALSE
    , polygons = TRUE
  )

  colsInterp <- colsInterp[as.numeric(interp$levels)]
  interp$cols <- colsInterp[interp$levels]
  interp <- sf::st_make_valid(interp)
  mapInterp <- suppressWarnings(sf::st_intersection(interp, v$weightedWindow))

  #plot(mapInterp["levels"]$geometry, col = mapInterp$cols, border = mapInterp$cols)

  # mapview
  popup <- leafpop::popupTable(
    wals
    , zcol = c("language", "wals.code", "glottocode", feature)
    , row.numbers = FALSE
    , feature.id = FALSE
  )

  original <- mapview::mapview(
    data
    , zcol = feature
    , col.regions = cols
    , lwd = 0.2
    , popup = popup
    , label = "language"
    , layer.name = name
    , legend = FALSE
    , native.crs = TRUE
    , homebutton = FALSE
  )

  interpolation <- mapview::mapview(
    mapInterp
    , zcol = "levels"
    , col.regions = mapInterp$cols
    , color = mapInterp$cols
    , lwd = 1
    , alpha = 0.5
    , alpha.regions = 0.5
    , layer.name = "Interpolation"
    , legend = FALSE
    , native.crs = TRUE
    , homebutton = FALSE
    , hide = TRUE
  )

  areas <- mapview::mapview(
    conts
    , zcol = "levels"
    , color = colsArea
    , lwd = 4
    , layer.name = "Areas"
    , legend = FALSE
    , native.crs = TRUE
    , homebutton = FALSE
    , hide = TRUE
  )

  outline <- mapview::mapview(
    sf::st_sf(v$weightedWindow)
    , col.regions = "grey"
    , layer.name = "World outline"
    , alpha.regions = 0
    , legend = FALSE
    , native.crs = TRUE
    , homebutton = FALSE
    , hide = TRUE
  )

  map <- original + interpolation + areas + outline
  map@map <- leaflet::addLegend(
    map@map
    , labels = levs
    , colors = cols
    , title = name
    , position = "topright"
    , opacity = 1
  )

  map@map <- leafem::removeMouseCoordinates(map)
  setwd("docs/WALS")
  mapview::mapshot2(map, url = paste0("WALS", feature, ".html"))
  setwd("../..")

}