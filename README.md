# mission-across-iow

[![Project Status: Concept – Minimal or no implementation has been done
yet, or the repository is only intended to be a limited example, demo,
or
proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
![](https://img.shields.io/badge/Shiny-not_yet_hosted-blue?style=flat&labelColor=white&logo=RStudio&logoColor=blue)

## Purposes

Experimental work in progress: an R Shiny app to let users assess the 'difficulty' of straight-line walking routes across the Isle of Wight, UK, given obstructions (waterways, buildings, barriers, etc).

Inspired by Tom '[GeoWizard](https://www.youtube.com/c/GeoWizard/about)' Davies's attempts to cross countries---[like Wales](https://www.youtube.com/playlist?list=PL_japiE6QKWphPxjqn0KJjfoRnuVSELaI)---in a straight line, on foot.

## Use the app

The app will be hosted on shinyapps.io when ready. In the meantime, you can test drive it with:

``` r
shiny::runGitHub(
  username = "matt-dray",
  repo = "mission-across-iow",
  subdir = "mission-across-iow",
  ref = "main"
)
```

username = "matt-dray",See the `mission-across-iow/global.R` for the packages you'll want to install.

## Development

The ultimate goal is to use Leaflet Draw with {leaflet.extras} to allow the user to draw their line onto the map. Also I'll prettify things with probably {bslib}.

## References

Main packages used:

* [{sf}](https://r-spatial.github.io/sf/) for spatial-data  manipulation
* [{osmextra}](https://docs.ropensci.org/osmextract/) for fetching OpenStreetMap features
* [{leaflet}](https://rstudio.github.io/leaflet/) and [{leaflet.extras}](https://bhaskarvk.github.io/leaflet.extras/) for interactive mapping 
* [{shiny}](https://shiny.rstudio.com/) for interactive web apps
* [{geojsonio}](https://docs.ropensci.org/geojsonio/) for reading GeoJSON files
* various [{tidyverse}](https://www.tidyverse.org/) packages for data manipulation

Data from:

* the [Open Geography Portal](https://geoportal.statistics.gov.uk/) from the Office for National Statistics (ONS)
* [OpenStreetMap](https://www.openstreetmap.org/)