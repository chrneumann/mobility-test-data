#!/usr/bin/env bash

set -e

DATA_DIR=/opt/data
MAIN_PBF=$DATA_DIR/cache/germany_hessen.osm.pbf
BOUNDARY_PBF=$DATA_DIR/frankfurt_boundary.osm.pbf
EXTRACT_PBF=$DATA_DIR/frankfurt.osm.pbf
MBTILES=$DATA_DIR/frankfurt.mbtiles
PMTILES=$DATA_DIR/frankfurt.pmtiles

eprint() {
    echo "$@" >&2
}

# Run command if target does not exist or is older than dependency.
make() {
    DEPENDENCY="$1"
    TARGET="$2"
    COMMAND="${@:3}"
    if [ ! -f "$TARGET" ] || { [ -n "$DEPENDENCY" ] && [ "$TARGET" -ot "$DEPENDENCY" ]; }
    then
        $COMMAND
        return 0
    fi
    eprint Nothing to be done for `basename "$2"`
}

if [ ! -d "$DATA_DIR" ]
then
    eprint $DATA_DIR not found. Forgot to bind your local data directory into the container?
    exit 1
fi

mkdir -p "$DATA_DIR/cache"

make "" "$MAIN_PBF" \
     wget https://download.geofabrik.de/europe/germany/hessen-latest.osm.pbf -O "$MAIN_PBF"

make "$MAIN_PBF" "$BOUNDARY_PBF" \
     osmium getid -O -r -t "$MAIN_PBF" r62400 -o "$BOUNDARY_PBF"

make "$BOUNDARY_PBF" "$EXTRACT_PBF" \
     osmium extract -O -p "$BOUNDARY_PBF" "$MAIN_PBF" -o "$EXTRACT_PBF" -v

make "$EXTRACT_PBF" "$MBTILES" \
     tilemaker --input "$EXTRACT_PBF" --output "$MBTILES" \
       --config /usr/share/doc/tilemaker/examples/config-openmaptiles.json \
       --process /usr/share/doc/tilemaker/examples/process-openmaptiles.lua \
       --bbox 8.422089,49.8687512,8.905386,50.3215704

make "$MBTILES" "$PMTILES" \
     /opt/pmtiles convert "$MBTILES" "$PMTILES"
