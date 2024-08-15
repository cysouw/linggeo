# =======

# download data
f = "83A"
wals <- lingtypology::wals.feature(f)

# assign colors
table(wals[,f])
# feature 1A
cols <- c("grey", "red", "orange", "cyan1", "blue")
order =  c(5, 4, 1, 3, 2) # order for legend
# feature 83A
cols <- c("grey", "blue", "red")
order =  c(2,3,1) # order for legend

w <- read.csv("not_used/languages.csv")
genus <- merge(wals, w, by.x = "wals.code", by.y = "ID", sort = FALSE)$Genus
weights <- as.numeric(1/table(genus)[genus])

# prepare map
v <- weightedMap(wals$longitude, wals$latitude,
                 window = window, crs = "+proj=moll +lon_0=11", maxit = 8, weights = weights)

# prepare feature
feature <- wals[,f][-v$outsideWindow]
names(cols) <- names(table(feature))

# plot map
plot(v$weightedVoronoi, col = cols[feature], border = NA)
plot(v$weightedWindow, border = "black", add = TRUE, lwd = 0.5)

# add legend
cols <- cols[order]
legend("bottomleft", legend = names(cols), fill = cols, cex = .7)

# ====

ph_all <- lingtypology::phoible.feature()
#ph <- ph_all[ph_all$source == "ph",]
ph <- ph_all

distr <- table(ph$inventoryid, ph$phoneme)
distr <- matrix(distr, ncol = ncol(distr), dimnames = dimnames(distr))

s <- qlcMatrix::cosSparse(t(distr), norm = norm1)
cols <- qlcVisualize::heeringa(as.dist(max(s)-s))

lang <- unique(ph[, c("glottocode", "inventoryid")])
lang <- merge(lang, glottolog, by = "glottocode")

sel <- !duplicated(lang$glottocode)

v <- weightedMap(lang$longitude[sel], lang$latitude[sel], window = land,
                 crs = mollweide_atlantic, maxit = 2, verbose = 1, method = "gsm")
plot(v$weightedVoronoi, col = cols[sel][-v$outsideWindow], border = NA)

# All WALS features

f <- paste0(c(1:138)[-c(3, 25, 81, 95, 96, 97)], "A")
# get data, get glottolog coordinates and correct errors in WALS
wals <- suppressWarnings(lingtypology::wals.feature(f))
wals$glottocode[wals$glottocode == "poqo1257"] <- "poqo1253"
wals$glottocode[wals$glottocode == "mamc1234"] <- "mamm1241"
wals$glottocode[wals$glottocode == "tuka1247"] <- "tuka1248"
wals$glottocode[wals$glottocode == "bali1280"] <- "unea1237"
wals <- merge(
  wals[, c("language", "glottocode", "wals.code", f)],
  lingtypology::glottolog[, c("glottocode", "longitude", "latitude")]
)

coverage <- apply(wals[, f], 1, function(x) {sum(!is.na(x))})
sel <- coverage > 20
data <- wals[sel, f]

s <- qlcMatrix::sim.obs(data, method = "hamming")
cols <- qlcVisualize::heeringa(as.dist(max(s) - s))

data(world, package = "qlcVisualize")
v <- qlcVisualize::wmap(wals$longitude[sel], wals$latitude[sel], window = world,
                 crs = "+proj=imoll +lon_0=11.5", method = "dcn", maxit = 10)
plot(v$weightedVoronoi, col = cols, border = NA)

e <- RSpectra::eigs(s, 10)
vect <- sf::st_sf(geometry = v$weightedVoronoi, vectors = e$vectors)

map <- vect["vectors.5"]
nums <- vect$vectors.5
plot(map, border = NA, key.pos = NULL, pal = rev(sf::sf.colors(13)))
levs <- seq(min(nums), max(nums), length.out = 9)
lwd <- rev(seq(4, 0.5, length.out = length(levs)))
qlcVisualize::addContour(nums, v$weightedPoints, v$weightedWindow, v$crs,
           levels = rev(levs), grid = 1e5, col = "red")

# ====

w <- read.csv("not_used/languages.csv")
genus <- merge(wals, w, by.x = "wals.code", by.y = "ID", sort = FALSE)$Genus
weights <- 1/table(genus)[genus]
