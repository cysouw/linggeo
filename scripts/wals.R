# use walsMap() without arguments to use global variables
source("scripts/walsMap.R")

# set variables
feature <- "1A"
levs <- c("Small", "Moderately small", "Average", "Moderately large", "Large")
cols <- c("blue", "cyan", "grey", "orange", "red")
name <- "WALS 1A: Consonant Inventories"
height <- c(-1, -0.5, 0, 0.5, 1)
heightArea <- c(-0.6, -0.4, -0.2, 0.2, 0.4, 0.6)
colsArea <- hcl.colors(length(heightArea), "BlueRed")
nInterp <- 30
colsInterp <- force(hcl.colors(nInterp, "BlueRed"))
# make html-map
walsMap()

# set variables
feature <- "2A"
levs <- c("Small (2-4)", "Average (5-6)", "Large (7-14)")
cols <- c("blue", "grey", "red")
name <- "WALS 2A: Vowel Quality Inventories"
height <- c(0, 0.5, 1)
heightArea <- c(0.2, 0.4, 0.6, 0.8)
colsArea <- c("blue4", "blue", "orange", "red")
nInterp <- 30
colsInterp <- hcl.colors(nInterp + 1, "BlueRed")
# make html-map
walsMap()

# set variables
feature <- "9A"
levs <- c("No velar nasal", "No initial velar nasal", "Initial velar nasal")
cols <- c("grey", "orange", "red")
name <- "WALS 9A: The Velar Nasal"
height <- c(0, 0.5, 1)
heightArea <- c(0.25, 0.45, 0.65)
colsArea <- hcl.colors(length(heightArea), "Lajolla")
nInterp <- 30
colsInterp <- rev(hcl.colors(nInterp, "Heat2"))
# make html-map
walsMap()

# set variables
feature <- "12A"
levs <- c("Simple", "Moderately complex", "Complex")
cols <- c("grey", "orange", "red")
name <- "WALS 12A: Syllable Structure"
height <- c(0, 0.5, 1)
heightArea <- c(0.45, 0.65, 0.85)
colsArea <- hcl.colors(length(heightArea), "Lajolla")
nInterp <- 30
colsInterp <- rev(hcl.colors(nInterp, "Heat2"))
# make html-map
walsMap()

# set variables
feature <- "13A"
levs <- c("No tones", "Simple tone system", "Complex tone system")
cols <- c("grey", "orange", "red")
name <- "WALS 13A: Tone"
height <- c(0, 0.5, 1)
heightArea <- c(0.25, 0.45, 0.65)
colsArea <- hcl.colors(length(heightArea), "Lajolla")
nInterp <- 30
colsInterp <- rev(hcl.colors(nInterp, "Heat2"))
# make html-map
walsMap()

# set variables
feature <- "27A"
levs <- c("No productive reduplication", "Full reduplication only", "Productive full and partial reduplication")
cols <- c("grey", "orange", "red")
name <- "WALS 27A: Reduplication"
height <- c(0, 0.5, 1)
heightArea <- c(0.25, 0.45, 0.65)
colsArea <- hcl.colors(length(heightArea), "Lajolla")
nInterp <- 30
colsInterp <- rev(hcl.colors(nInterp, "Heat2"))
# make html-map
walsMap()

# set variables
feature <- "52A"
levs <- c("Identity", "Mixed", "Differentiation")
cols <- c("yellow", "orange", "red")
name <- "WALS 52A: Comitatives and Instrumentals"
height <- c(0, 0.5, 1)
heightArea <- c(0.2, 0.4, 0.6, 0.8)
colsArea <- rev(hcl.colors(length(heightArea), "Heat2"))
nInterp <- 30
colsInterp <- rev(hcl.colors(nInterp + 1, "Heat2"))
# make html-map
walsMap()

# set variables
feature <- "63A"
levs <- c("'And' different from 'with'", "'And' identical to 'with'")
cols <- c("yellow", "red")
name <- "WALS 63A: Noun Phrase Conjunction"
height <- c(0, 1)
heightArea <- c(0.3, 0.4, 0.5, 0.6, 0.7)
colsArea <- hcl.colors(length(heightArea), "Lajolla")
nInterp <- 30
colsInterp <- rev(hcl.colors(nInterp + 1, "Heat2"))
# make html-map
walsMap()

# set variables
feature <- "83A"
levs <- c("OV", "No dominant order", "VO")
cols <- c("blue", "grey", "red")
name <- "WALS 83A: Order of Object and Verb"
height <- c(0, 0.5, 1)
heightArea <- c(0.2, 0.4, 0.6, 0.8)
colsArea <- c("blue4", "blue", "orange", "red")
nInterp <- 30
colsInterp <- hcl.colors(nInterp + 1, "BlueRed")
# make html-map
walsMap()
