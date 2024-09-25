# Test

This is a test

```{.ggplot2 format=SVG}
data(world, package = "qlcVisualize")
library(ggplot2)
op <- par(mfrow = c(2, 2), mar = c(0, 0, 0, 0), family = "Libertinus Serif")
ggplotify::as.ggplot(~
  plot(sf::st_transform(world, "+proj=longlat +lon_0=11.5"))
)
ggtitle("Simple longitude-latitude projection ('longlat')\nLongitude rotated 11.5°")
ggplotify::as.ggplot(~
  plot(sf::st_transform(world, "+proj=imoll +lon_0=11.5"))
)
ggtitle("Interrupted Mollweide projection ('imoll')\nLongitude rotated 11.5°")
ggplotify::as.ggplot(~
  plot(sf::st_transform(world, "+proj=eqearth +lon_0=151"))
)
ggtitle("Equal Earth projection ('eqearth')\nLongitude rotated 151°")
ggplotify::as.ggplot(~
  plot(sf::st_transform(world, "+proj=aeqd +lat_0=90 +lon_0=45"))
)
ggtitle("Azimuthal Equidistant projection ('aeqd')\nLongitude rotated 45°, Latitude rotated 90°")
# restore default settings
par(op)
```

More text

