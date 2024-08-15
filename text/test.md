# Test

This is a test

```{.ggplot2 format=SVG}
data(world, package = "qlcVisualize")
ggplotify::as.ggplot(~
  plot(sf::st_transform(world, "+proj=aeqd +lat_0=90 +lon_0=45"), col = "grey")
)
```

More text


<iframe src="map.html" width="100%" height="400px"></iframe>


blablabla
