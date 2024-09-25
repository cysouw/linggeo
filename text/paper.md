# Visualisation in comparative linguistics

visualisation in comparative linguistics is mainly used to inspect data and formulate hypotheses and generalisations

Previous research [@rohrdantz2012; @mcnew2018; @comrie2020]

dialect maps [@rabanus2018; @rabanus2020]

# Methods

In the main text of this paper only a high-level outline of the visualisations will be presented. An appendix is added to the paper with more detailed information on how to create the visualisations. However, even this appendix will still be rather abstract in the sense that it will not contain any code or detailed instructions on how to use specific software. The actual code that has been used to prepare the visualisations are available in a separate online repository.

# Projection

The surface of the world is curved and for that reason a decision is needed how to project this curved surface onto a flat surface like a screen or a piece of paper. The problem of how to use such geographical projections is known for centuries and many different projections have been developed. Modern geographical software, either in form of a dedicated GIS or of geographical libraries for general programming languages like Python or R, make it really easy to switch between different projections. Mostly it takes just a single click or a single line of code. So there is really no excuse not to spend at least a few thoughts on the choice of the projection when trying to represent geographical data.

When dealing with linguistic diverity, the most detailed geographical data to be represented is dialectal variation. The graphical representation of such local variation is actually not strongly influences by different projections. For example, consider three different projections for the outline of Germany shown in [@fig:projectionsGermany]. Although clear differences are visible, the effects of different projections do not seem to be very meaningful for the interpretation of linguistic variation in such an area.

![Different projections of Germany, centralised and scaled for comparison: a rectangular longitude-latitude plot (EPSG:3857 in black), an equal-area Mollweide projection (ESRI:54009 in red), and an azimuthal equal-area projection (ESRI:54032 in blue).](figures/projectionsGermany){#fig:projectionsGermany .inline-svg}

The situation is quite different when dealing with global data. The choice of projection can have a strong impact on the interpretation of the data. As an example, consider the projections shown in [@fig:projectionsWorld]. The rectangular longitude-latitude projections (top left) is often used [e.g. in the online version of WALS, @dryer2013a] because it allows for the direct specificiation of longitude-latitude coordinates, so it might feel like a natural unopinionated display. However, the use of this visual characterisation is a decision and it is actually rather unfitting for the display of worldwide linguistic variation. Landmasses close to the North Pole are relatively large, while these areas generally contain little linguistic variation. Note that the specific projection in [@fig:projectionsWorld] is already a slightly changed longitude-latitude projection, because it is rotated 11.5 degrees to the west to put the cut-off in the Bering Strait.

![Different projections of the World](figures/projectionsWorld){#fig:projectionsWorld .inline-svg}

The other three projections shown in [@fig:projectionsWorld] are proposed here are better choices for the projection of worldwide linguistic variation. All three are area-preserving projections, which means that the size of the areas in the display is proportional to the area of the surfaces on the globe. The projection in the top-right of [@fig:projectionsWorld] is a Mollweide projection, which is a compromise between the rectangular longitude-latitude projection and an equal-area projection. Specifically, shown here is an "interrupted" Mollweide projection, which breaks open the projection in the oceans to more faithfully represent the outline of the landmasses. Like the previous projection, this Mollweide projection is rotated to put the cut-off in the Bering Strait.

Shown in the bottom-left of [@fig:projectionsWorld] is a so-called Equal Earth projection [@savric2019]. This is a relatively new projection intended as an improvement on the Robinson projection [which was used in the original printed version of the WALS, @haspelmath2005c]. This projection seems particularly useful for a pacific-centered display, because it has still a reasonably recognizable outline of the extreme left and right coastlines.

Finally, a somewhat unusual but promising projection is shown bottom-right in [@fig:projectionsWorld]. This is an azimuthal equidistant projection, for example used in the United Nations Emblem. The biggest drawback of this projection is the rather strong distortion of the form of Autralia.

# Weighting

Even when using a suitable projection, there is still another problem with the display of world-wide linguistic variation. The number of languages spoken around the world is very unevenly distributed geographically. There are some regions in which very many different languages are spoken in close proximity, while other areas only few different languages are attested. Any display that does not take this effect into account will have an implicit visual bias in they display of the world-wide linguistic variation.

For example, when using equally-sized symbols in linguistic maps (like in WALS) this often leads to overlapping symbols. The hidden portions of symbols induces less visual prominency for these languages and are thus an implicit distortion of the visual display. This problem was explicitly addressed by McNew, Derung & Moran [-@mcnew2018], who suggest a Thiessen/Voronoi-tesselation as an alternative. In such a display 

Distortion to visually weight the prominence of certain areas.

To be able to distort

![Cartogram with equal area for all languages in the Glottolog](figures/equalArea){#equalArea .inline-svg width=100%}

![Cartogram with different kinds of weighting](figures/weightedLanguages){#weightedLanguages .inline-svg width=100%}

Populationdata from [@amano2014]

# Interpolation

[@thebpanya2020]

# Prediction

# Conclusion

# Appendix

## Projections

Different projections can be easily applied by using the algorithms and specifications from PROJ [@proj2024]. The following PROJ-strings can be used to create the projections shown in [@fig:projectionsWorld]:

- Longitude-latitude projection: "+proj=longlat +long_0=11.5"
- Interrupted Mollweide projection: "+proj=imoll +long_0=11.5"
- Equal Earth projection: "+proj=eqearth +lon_0=151"
- Azimuthal Equal Distance projection: "+proj=aeqd +lat_0=90 +lon_0=45"

Similar to the Azimuth projection, the Fuller projection is a way to solve the distortion of Australia. Such a Fuller projection is for example used for the display of human migrations based on genetic data on Wikipedia.^[<https://commons.wikimedia.org/wiki/File:World_map_of_prehistoric_human_migrations.jpg>, accessed 21 August 2014.] Because of copyright reasons the Fuller projection is currently not available in PROJ.

# References
