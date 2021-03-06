# mission-across-iow

<!-- badges: start -->
[![Project Status: Concept – Minimal or no implementation has been done
yet, or the repository is only intended to be a limited example, demo,
or
proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
![](https://img.shields.io/badge/Shiny-not_yet_hosted-blue?style=flat&labelColor=white&logo=RStudio&logoColor=blue)
[![rostrum.blog
post](https://img.shields.io/badge/rostrum.blog-post-008900?style=flat&labelColor=black&logo=data:image/gif;base64,R0lGODlhEAAQAPEAAAAAABWCBAAAAAAAACH5BAlkAAIAIf8LTkVUU0NBUEUyLjADAQAAACwAAAAAEAAQAAAC55QkISIiEoQQQgghRBBCiCAIgiAIgiAIQiAIgSAIgiAIQiAIgRAEQiAQBAQCgUAQEAQEgYAgIAgIBAKBQBAQCAKBQEAgCAgEAoFAIAgEBAKBIBAQCAQCgUAgEAgCgUBAICAgICAgIBAgEBAgEBAgEBAgECAgICAgECAQIBAQIBAgECAgICAgICAgECAQECAQICAgICAgICAgEBAgEBAgEBAgICAgICAgECAQIBAQIBAgECAgICAgIBAgECAQECAQIBAgICAgIBAgIBAgEBAgECAgECAgICAgICAgECAgECAgQIAAAQIKAAAh+QQJZAACACwAAAAAEAAQAAAC55QkIiESIoQQQgghhAhCBCEIgiAIgiAIQiAIgSAIgiAIQiAIgRAEQiAQBAQCgUAQEAQEgYAgIAgIBAKBQBAQCAKBQEAgCAgEAoFAIAgEBAKBIBAQCAQCgUAgEAgCgUBAICAgICAgIBAgEBAgEBAgEBAgECAgICAgECAQIBAQIBAgECAgICAgICAgECAQECAQICAgICAgICAgEBAgEBAgEBAgICAgICAgECAQIBAQIBAgECAgICAgIBAgECAQECAQIBAgICAgIBAgIBAgEBAgECAgECAgICAgICAgECAgECAgQIAAAQIKAAA7)](https://www.rostrum.blog/2021/05/22/mission-across-iow/)
<!-- badges: end -->

What's the easiest route to cross the [Isle of Wight](https://en.wikipedia.org/wiki/Isle_of_Wight) on foot in a straight line?

## Purpose

Experimental work in progress: an R Shiny app to let users assess the 'difficulty' of straight-line walking routes across the [Isle of Wight, UK](https://en.wikipedia.org/wiki/Isle_of_Wight), given obstructions (waterways, buildings, barriers, etc).

Inspired by Tom '[GeoWizard](https://www.youtube.com/c/GeoWizard/about)' Davies's attempts to cross countries, [like Wales](https://www.youtube.com/playlist?list=PL_japiE6QKWphPxjqn0KJjfoRnuVSELaI), in a straight line on foot.

## Use the app

The app will be hosted on shinyapps.io when ready. In the meantime, you can download and test drive it from your R session with:

``` r
shiny::runGitHub(
  username = "matt-dray",
  repo = "mission-across-iow",
  subdir = "mission-across-iow",
  ref = "main"
)
```

It'll take a moment to download. See the `mission-across-iow/global.R` file for the packages you'll want to install.

## Development

The ultimate goal is to use Leaflet Draw via {leaflet.extras} to let users draw a line, rather than provide points. Also I'll prettify things with (probably) {bslib}.

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
