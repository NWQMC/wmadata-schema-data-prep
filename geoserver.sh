#!/usr/bin/env bash

contents="<dataStore>
  <name>wmadata</name>
  <connectionParameters>
    <host>172.25.0.2</host>
    <port>5432</port>
    <database>nwis_db</database>
    <user>wmadata_reader</user>
    <passwd>changeMe</passwd>
    <dbtype>postgis</dbtype>
  </connectionParameters>
</dataStore>"
cat <<< $contents > wmadata_store.xml

curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" \
  -d "<workspace><name>wmadata</name></workspace>" \
  http://localhost:8080/geoserver/rest/workspaces

curl -v -u admin:geoserver -XPOST -T wmadata_store.xml -H "Content-type: text/xml" \
   http://localhost:8080/geoserver/rest/workspaces/wmadata/datastores

curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" \
  -d "<featureType><name>gagesii</name><nativeCRS>EPSG:4269</nativeCRS><srs>EPSG:900913</srs></featureType>" \
  http://localhost:8080/geoserver/rest/workspaces/wmadata/datastores/wmadata/featuretypes

curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" \
  -d "<featureType><name>gagesii</name><nativeCRS>EPSG:4269</nativeCRS><srs>EPSG:900913</srs></featureType>" \
  http://localhost:8080/geoserver/rest/workspaces/wmadata/datastores/wmadata/featuretypes

curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" \
  -d "<featureType><name>huc08</name><nativeCRS>EPSG:4269</nativeCRS><srs>EPSG:900913</srs></featureType>" \
  http://localhost:8080/geoserver/rest/workspaces/wmadata/datastores/wmadata/featuretypes

curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" \
  -d "<featureType><name>huc12</name><nativeCRS>EPSG:4269</nativeCRS><srs>EPSG:900913</srs></featureType>" \
  http://localhost:8080/geoserver/rest/workspaces/wmadata/datastores/wmadata/featuretypes

curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" \
  -d "<featureType><name>huc12all</name><nativeCRS>EPSG:4269</nativeCRS><srs>EPSG:900913</srs></featureType>" \
  http://localhost:8080/geoserver/rest/workspaces/wmadata/datastores/wmadata/featuretypes

curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" \
  -d "<featureType><name>huc12agg</name><nativeCRS>EPSG:4269</nativeCRS><srs>EPSG:900913</srs></featureType>" \
  http://localhost:8080/geoserver/rest/workspaces/wmadata/datastores/wmadata/featuretypes

curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" \
  -d "<featureType><name>catchmentsp</name><nativeCRS>EPSG:4269</nativeCRS><srs>EEPSG:4269</srs></featureType>" \
  http://localhost:8080/geoserver/rest/workspaces/wmadata/datastores/wmadata/featuretypes

curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" \
  -d "<featureType><name>nhdarea</name><nativeCRS>EPSG:4269</nativeCRS><srs>EPSG:4269</srs></featureType>" \
  http://localhost:8080/geoserver/rest/workspaces/wmadata/datastores/wmadata/featuretypes

curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" \
  -d "<featureType><name>nhdflowline_network</name><nativeCRS>EPSG:4269</nativeCRS><srs>EPSG:4269</srs></featureType>" \
  http://localhost:8080/geoserver/rest/workspaces/wmadata/datastores/wmadata/featuretypes

curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" \
  -d "<featureType><name>nhdwaterbody</name><nativeCRS>EPSG:4269</nativeCRS><srs>EPSG:4269</srs></featureType>" \
  http://localhost:8080/geoserver/rest/workspaces/wmadata/datastores/wmadata/featuretypes

