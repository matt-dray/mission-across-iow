# mission-across-iow

[![Project Status: Concept – Minimal or no implementation has been done
yet, or the repository is only intended to be a limited example, demo,
or
proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)

Experimental work in progress: using R to assess the 'difficulty' of straight-line walking routes across the Isle of Wight, UK. 

Inspired by Tom '[GeoWizard](https://www.youtube.com/c/GeoWizard/about)' Davies's attempts to cross countries---[like Wales](https://www.youtube.com/playlist?list=PL_japiE6QKWphPxjqn0KJjfoRnuVSELaI)---in a straight line, on foot.

The ultimate goal is a Shiny app where the user draws a straight line onto a map and is returned the identity and count of obstructions (waterways, buildings, barriers, etc) and other data.

Packages of note:

* [{sf}](https://r-spatial.github.io/sf/) for spatial-data  manipulation
* [{osmextra}](https://docs.ropensci.org/osmextract/) for fetching OpenStreetMap features
* [{leaflet}](https://rstudio.github.io/leaflet/) and [{leaflet.extras}](https://bhaskarvk.github.io/leaflet.extras/) for interactive mapping 
* [{shiny}](https://shiny.rstudio.com/) for interactive web apps
* [{geojsonio}](https://docs.ropensci.org/geojsonio/) for reading GeoJSON files
* various [{tidyverse}](https://www.tidyverse.org/) packages for data manipulation

Data from:

* the [Open Geography Portal](https://geoportal.statistics.gov.uk/) from the Office for National Statistics (ONS)
* [OpenStreetMap](https://www.openstreetmap.org/)