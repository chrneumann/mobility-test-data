# Mobility Test Data

An *experimental* script to generate map vector tiles for testing and examples.
Wrapped inside a docker container.

Currently, it downloads an OpenStreetMap extract for Germany/Hessen from
https://download.geofabrik.de/europe/germany/hessen.html and further processes
it to get a PBF extract, boundary, MBTiles and PMTiles for Frankfurt am Main.

Tiles and Styles Copyright:
- OpenStreetMap Contributors https://www.openstreetmap.org/copyright
- Maptiler https://www.maptiler.com/copyright/

## Download the docker container and run it:

```bash
mkdir data
docker run -v ./data:/opt/data ghcr.io/chrneumann/mobility-test-data:0.1.1
```

## Alternative: Build the container

```bash
docker build -t mobility-test-data .
mkdir data
docker run -v ./data:/opt/data --rm mobility-test-data
```
