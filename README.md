# WMADTA Data Preparation Scripts, Data, and Server Configuration

Unless Otherwise Noted:  
**This information is preliminary and is subject to revision. It is being provided to meet 
the need for timely best science. The information is provided on the condition that neither 
the U.S. Geological Survey nor the U.S. Government shall be held liable for any damages resulting 
from the authorized or unauthorized use of this information.**

## Data Creation
These data feed a geoserver infrastructure available here: https://labs.waterdata.usgs.gov/geoserver/web/

This initial repository contains source data and assumes access to a locally running PostGres database and GDAL.

It is reccomended to use docker and the following images:

- for local db, psql, and pgdump : mdillon/postgis
- for ogr2ogr: osgeo/gdal:ubuntu-small-latest

Shell scripts are used to download data layers and upload pgdumps to the Artifactory.

Future work includes running the above process in a Jenkins pipeline.

## GeoServer

A sehll script emulates the configuration of a local geoserver.

It is reccomended to use docker and the following images:

- for local geoserver: kartoza/geoserver

Jenkinsfile can be used in a pipeline to automate configuration of a geoserver via an EC2 instance.
