#!/usr/bin/env bash

FILES=("./data/gagesII.gpkg" "./data/us_historical_counties.gpkg" "./data/huc08.gpkg", "./data/huc12agg.gpkg")
ARTIFACTORY_URL="https://artifactory.wma.chs.usgs.gov/artifactory/wma-binaries/lfs/api/nwc2wmadataprep/"

if [ ! -d './data' ]; then
    mkdir data
    mkdir dumps
    mkdir NHDPlusNationalData
fi

for file in ${FILES[@]}; do

    if [ ! -f $file ]; then
        echo${ARTIFACTORY_URL}$(basename $file)
        curl ${ARTIFACTORY_URL}$(basename $file) > $file
    fi

done

echo "Dowload and extract the driectory 'NHDPlusV21_National_Seamless_Flattened_Lower48.gdb' in to \
'./NHDPlusNationalData located here:"
echo "https://nhdplus.com/NHDPlus/V2NationalData.php"
echo "The name of this gdb can change over time thus why this download is not automated"

