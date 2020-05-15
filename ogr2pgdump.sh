username=$1
password=$2
host=$3
db=$4
schema=$5
owner=$6
ownerpass=$7
check=$8

if [ -z "$ownerpass" ]; then
     echo "You must pass in seven variables, admin username, password, host, database name, schema, database owner, and a database owner password."
     exit
fi

if [ -n "$check" ]; then
    echo "You must pass in seven variables, admin username, password, host, database name, schema, database owner, and a database owner password."
    exit
fi
if [-e NHDPlusNationalData/NHDPlusV21_National_Seamless_Flattened_Lower48.gdb ]; then
  echo "Found NHDPlusV21_National_Seamless_Flattened_Lower48.gdb geo database"
else
  echo "Didn't find NHDPlusV21_National_Seamless_Flattened_Lower48.gdb in NHDPlusNationalData/NHDPlusV21_National_Seamless_Flattened_Lower48.gdb. Download the National Seamless Geodatabase from: https://www.epa.gov/waterdata/nhdplus-national-data and extract to the current working directory."
fi

echo Create new database role for tables
psql -c "CREATE ROLE $owner LOGIN PASSWORD '$ownerpass' NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;" postgresql://$username:$password@$host:5432/

echo Create database 
psql -c "CREATE DATABASE \"$db\" WITH OWNER = \"$owner\";" postgresql://$username:$password@$host:5432/

echo Add postgis extensions
psql -c "CREATE EXTENSION postgis; CREATE EXTENSION postgis_topology;" postgresql://$username:$password@$host:5432/$db

echo Insert NHDArea as nhdarea
ogr2ogr -overwrite -progress -f "PostGreSQL" PG:"host=$host user=$owner password=$ownerpass dbname=$db" -nln "nhdarea" -nlt PROMOTE_TO_MULTI -lco "GEOMETRY_NAME=the_geom" -lco "PRECISION=NO" -a_srs "EPSG:4269"   NHDPlusNationalData/NHDPlusV21_National_Seamless_Flattened_Lower48.gdb NHDArea

echo Index nhdarea
psql -c "CREATE INDEX ON nhdarea (COMID); CREATE INDEX ON nhdarea (FDATE); CREATE INDEX ON nhdarea (RESOLUTION); CREATE INDEX ON nhdarea (GNIS_ID); CREATE INDEX ON nhdarea (GNIS_NAME); CREATE INDEX ON nhdarea (AREASQKM); CREATE INDEX ON nhdarea (ELEVATION); CREATE INDEX ON nhdarea (FTYPE); CREATE INDEX ON nhdarea (FCODE); CREATE INDEX ON nhdarea (ONOFFNET); CREATE INDEX ON nhdarea (PurpCode); CREATE INDEX ON nhdarea (PurpDesc);" postgresql://$owner:$ownerpass@$host:5432/$db

echo Insert NHDFlowline_Network as nhdflowline_network
ogr2ogr -overwrite -progress -f "PostGreSQL" PG:"host=$host user=$owner password=$ownerpass dbname=$db" -nln "nhdflowline_network" -nlt PROMOTE_TO_MULTI -lco "GEOMETRY_NAME=the_geom" -lco "PRECISION=NO" -a_srs "EPSG:4269"   NHDPlusNationalData/NHDPlusV21_National_Seamless_Flattened_Lower48.gdb NHDFlowline_Network

echo Index nhdflowline_network
psql -c "CREATE INDEX ON nhdflowline_network (comid);CREATE INDEX ON nhdflowline_network (fdate);CREATE INDEX ON nhdflowline_network (resolution);CREATE INDEX ON nhdflowline_network (gnis_id);CREATE INDEX ON nhdflowline_network (gnis_name);CREATE INDEX ON nhdflowline_network (lengthkm);CREATE INDEX ON nhdflowline_network (reachcode);CREATE INDEX ON nhdflowline_network (flowdir);CREATE INDEX ON nhdflowline_network (wbareacomi);CREATE INDEX ON nhdflowline_network (ftype);CREATE INDEX ON nhdflowline_network (fcode);CREATE INDEX ON nhdflowline_network (shape_length);CREATE INDEX ON nhdflowline_network (streamleve);CREATE INDEX ON nhdflowline_network (streamorde);CREATE INDEX ON nhdflowline_network (streamcalc);CREATE INDEX ON nhdflowline_network (fromnode);CREATE INDEX ON nhdflowline_network (tonode);CREATE INDEX ON nhdflowline_network (hydroseq);CREATE INDEX ON nhdflowline_network (levelpathi);CREATE INDEX ON nhdflowline_network (pathlength);CREATE INDEX ON nhdflowline_network (terminalpa);CREATE INDEX ON nhdflowline_network (arbolatesu);CREATE INDEX ON nhdflowline_network (divergence);CREATE INDEX ON nhdflowline_network (startflag);CREATE INDEX ON nhdflowline_network (terminalfl);CREATE INDEX ON nhdflowline_network (dnlevel);CREATE INDEX ON nhdflowline_network (uplevelpat);CREATE INDEX ON nhdflowline_network (uphydroseq);CREATE INDEX ON nhdflowline_network (dnlevelpat);CREATE INDEX ON nhdflowline_network (dnminorhyd);CREATE INDEX ON nhdflowline_network (dndraincou);CREATE INDEX ON nhdflowline_network (dnhydroseq);CREATE INDEX ON nhdflowline_network (frommeas);CREATE INDEX ON nhdflowline_network (tomeas);CREATE INDEX ON nhdflowline_network (rtndiv);CREATE INDEX ON nhdflowline_network (vpuin);CREATE INDEX ON nhdflowline_network (vpuout);CREATE INDEX ON nhdflowline_network (areasqkm);CREATE INDEX ON nhdflowline_network (totdasqkm);CREATE INDEX ON nhdflowline_network (divdasqkm);CREATE INDEX ON nhdflowline_network (tidal);CREATE INDEX ON nhdflowline_network (totma);CREATE INDEX ON nhdflowline_network (wbareatype);CREATE INDEX ON nhdflowline_network (pathtimema);CREATE INDEX ON nhdflowline_network (hwnodesqkm);CREATE INDEX ON nhdflowline_network (maxelevraw);CREATE INDEX ON nhdflowline_network (minelevraw);CREATE INDEX ON nhdflowline_network (maxelevsmo);CREATE INDEX ON nhdflowline_network (minelevsmo);CREATE INDEX ON nhdflowline_network (slope);CREATE INDEX ON nhdflowline_network (elevfixed);CREATE INDEX ON nhdflowline_network (hwtype);CREATE INDEX ON nhdflowline_network (slopelenkm);CREATE INDEX ON nhdflowline_network (qa_ma);CREATE INDEX ON nhdflowline_network (va_ma);CREATE INDEX ON nhdflowline_network (qc_ma);CREATE INDEX ON nhdflowline_network (vc_ma);CREATE INDEX ON nhdflowline_network (qe_ma);CREATE INDEX ON nhdflowline_network (ve_ma);CREATE INDEX ON nhdflowline_network (qa_01);CREATE INDEX ON nhdflowline_network (va_01);CREATE INDEX ON nhdflowline_network (qc_01);CREATE INDEX ON nhdflowline_network (vc_01);CREATE INDEX ON nhdflowline_network (qe_01);CREATE INDEX ON nhdflowline_network (ve_01);CREATE INDEX ON nhdflowline_network (qa_02);CREATE INDEX ON nhdflowline_network (va_02);CREATE INDEX ON nhdflowline_network (qc_02);CREATE INDEX ON nhdflowline_network (vc_02);CREATE INDEX ON nhdflowline_network (qe_02);CREATE INDEX ON nhdflowline_network (ve_02);CREATE INDEX ON nhdflowline_network (qa_03);CREATE INDEX ON nhdflowline_network (va_03);CREATE INDEX ON nhdflowline_network (qc_03);CREATE INDEX ON nhdflowline_network (vc_03);CREATE INDEX ON nhdflowline_network (qe_03);CREATE INDEX ON nhdflowline_network (ve_03);CREATE INDEX ON nhdflowline_network (qa_04);CREATE INDEX ON nhdflowline_network (va_04);CREATE INDEX ON nhdflowline_network (qc_04);CREATE INDEX ON nhdflowline_network (vc_04);CREATE INDEX ON nhdflowline_network (qe_04);CREATE INDEX ON nhdflowline_network (ve_04);CREATE INDEX ON nhdflowline_network (qa_05);CREATE INDEX ON nhdflowline_network (va_05);CREATE INDEX ON nhdflowline_network (qc_05);CREATE INDEX ON nhdflowline_network (vc_05);CREATE INDEX ON nhdflowline_network (qe_05);CREATE INDEX ON nhdflowline_network (ve_05);CREATE INDEX ON nhdflowline_network (qa_06);CREATE INDEX ON nhdflowline_network (va_06);CREATE INDEX ON nhdflowline_network (qc_06);CREATE INDEX ON nhdflowline_network (vc_06);CREATE INDEX ON nhdflowline_network (qe_06);CREATE INDEX ON nhdflowline_network (ve_06);CREATE INDEX ON nhdflowline_network (qa_07);CREATE INDEX ON nhdflowline_network (va_07);CREATE INDEX ON nhdflowline_network (qc_07);CREATE INDEX ON nhdflowline_network (vc_07);CREATE INDEX ON nhdflowline_network (qe_07);CREATE INDEX ON nhdflowline_network (ve_07);CREATE INDEX ON nhdflowline_network (qa_08);CREATE INDEX ON nhdflowline_network (va_08);CREATE INDEX ON nhdflowline_network (qc_08);CREATE INDEX ON nhdflowline_network (vc_08);CREATE INDEX ON nhdflowline_network (qe_08);CREATE INDEX ON nhdflowline_network (ve_08);CREATE INDEX ON nhdflowline_network (qa_09);CREATE INDEX ON nhdflowline_network (va_09);CREATE INDEX ON nhdflowline_network (qc_09);CREATE INDEX ON nhdflowline_network (vc_09);CREATE INDEX ON nhdflowline_network (qe_09);CREATE INDEX ON nhdflowline_network (ve_09);CREATE INDEX ON nhdflowline_network (qa_10);CREATE INDEX ON nhdflowline_network (va_10);CREATE INDEX ON nhdflowline_network (qc_10);CREATE INDEX ON nhdflowline_network (vc_10);CREATE INDEX ON nhdflowline_network (qe_10);CREATE INDEX ON nhdflowline_network (ve_10);CREATE INDEX ON nhdflowline_network (qa_11);CREATE INDEX ON nhdflowline_network (va_11);CREATE INDEX ON nhdflowline_network (qc_11);CREATE INDEX ON nhdflowline_network (vc_11);CREATE INDEX ON nhdflowline_network (qe_11);CREATE INDEX ON nhdflowline_network (ve_11);CREATE INDEX ON nhdflowline_network (qa_12);CREATE INDEX ON nhdflowline_network (va_12);CREATE INDEX ON nhdflowline_network (qc_12);CREATE INDEX ON nhdflowline_network (vc_12);CREATE INDEX ON nhdflowline_network (qe_12);CREATE INDEX ON nhdflowline_network (ve_12);CREATE INDEX ON nhdflowline_network (lakefract);CREATE INDEX ON nhdflowline_network (surfarea);CREATE INDEX ON nhdflowline_network (rareahload);CREATE INDEX ON nhdflowline_network (rpuid);CREATE INDEX ON nhdflowline_network (vpuid);CREATE INDEX ON nhdflowline_network (enabled);" postgresql://$owner:$ownerpass@$host:5432/$db

echo Insert Simplified Catchments into Database as Catchmentsp.
ogr2ogr -overwrite -progress -f "PostGreSQL" PG:"host=$host user=$owner password=$ownerpass dbname=$db" -nln "catchmentsp" -nlt PROMOTE_TO_MULTI -lco "GEOMETRY_NAME=the_geom" -lco "PRECISION=NO" -a_srs "EPSG:4269"   NHDPlusNationalData/NHDPlusV21_National_Seamless_Flattened_Lower48.gdb CatchmentSP

echo Index CatchmentSP.
psql -c "CREATE INDEX ON catchmentsp (FEATUREID); CREATE INDEX ON catchmentsp (GRIDCODE); CREATE INDEX ON catchmentsp (AreaSqKM); CREATE INDEX ON catchmentsp (SOURCEFC);" postgresql://$owner:$ownerpass@$host:5432/$db

echo Insert NHDWaterbody as nhdwaterbody
ogr2ogr -overwrite -progress -f "PostGreSQL" PG:"host=$host user=$owner password=$ownerpass dbname=$db" -nln "nhdwaterbody" -nlt PROMOTE_TO_MULTI -lco "GEOMETRY_NAME=the_geom" -lco "PRECISION=NO" -a_srs "EPSG:4269"   NHDPlusNationalData/NHDPlusV21_National_Seamless_Flattened_Lower48.gdb NHDWaterbody

echo Index nhdwaterbody
psql -c "CREATE INDEX ON nhdwaterbody (COMID); CREATE INDEX ON nhdwaterbody (FDATE); CREATE INDEX ON nhdwaterbody (RESOLUTION); CREATE INDEX ON nhdwaterbody (GNIS_ID); CREATE INDEX ON nhdwaterbody (GNIS_NAME); CREATE INDEX ON nhdwaterbody (AREASQKM); CREATE INDEX ON nhdwaterbody (ELEVATION); CREATE INDEX ON nhdwaterbody (REACHCODE); CREATE INDEX ON nhdwaterbody (FTYPE); CREATE INDEX ON nhdwaterbody (FCODE); CREATE INDEX ON nhdwaterbody (ONOFFNET); CREATE INDEX ON nhdwaterbody (PurpCode); CREATE INDEX ON nhdwaterbody (PurpDesc);" postgresql://$owner:$ownerpass@$host:5432/$db

echo Insert us_historical_counties
ogr2ogr -overwrite -progress -f "PostGreSQL" PG:"host=$host user=$owner password=$ownerpass dbname=$db" -nln "us_historical_counties" -nlt PROMOTE_TO_MULTI -lco "GEOMETRY_NAME=the_geom" -lco "PRECISION=NO" -a_srs "EPSG:4269"   data/us_historical_counties.gpkg

echo Insert gagesII
ogr2ogr -overwrite -progress -f "PostGreSQL" PG:"host=$host user=$owner password=$ownerpass dbname=$db" -nln "gagesII" -nlt PROMOTE_TO_MULTI -lco "GEOMETRY_NAME=the_geom" -lco "PRECISION=NO" -a_srs "EPSG:4269"   data/gagesII.gpkg

echo Insert huc08
ogr2ogr -overwrite -progress -f "PostGreSQL" PG:"host=$host user=$owner password=$ownerpass dbname=$db" -nln "huc08" -nlt PROMOTE_TO_MULTI -lco "GEOMETRY_NAME=the_geom" -lco "PRECISION=NO" -a_srs "EPSG:4269"   data/huc08.gpkg

echo Insert huc12agg
ogr2ogr -overwrite -progress -f "PostGreSQL" PG:"host=$host user=$owner password=$ownerpass dbname=$db" -nln "huc12agg" -nlt PROMOTE_TO_MULTI -lco "GEOMETRY_NAME=the_geom" -lco "PRECISION=NO" -a_srs "EPSG:4269"   data/huc12agg.gpkg

echo Insert huc12all_temp
ogr2ogr -overwrite -progress -f "PostGreSQL" PG:"host=$host user=$owner password=$ownerpass dbname=$db" NHDPlusNationalData/NHDPlusV21_National_Seamless_Flattened_Lower48.gdb -sql "SELECT HUC_12 AS HUC12, HU_12_DS AS TOHUC, ACRES AS AREAACRES, AreaHUC12 AS AREASQKM, HU_12_NAME AS NAME, HU_12_TYPE AS HUTYPE, HU_12_MOD AS HUMOD, STATES as STATES, NCONTRB_A AS NONCONTRIB FROM HUC12" -a_srs "EPSG:4269" -nln huc12all_temp -nlt PROMOTE_TO_MULTI -lco GEOMETRY_NAME=the_geom -lco "PRECISION=NO"

echo Insert huc12all
psql -c "CREATE TABLE huc12all AS (SELECT huc12, tohuc, areaacres, areasqkm, name, hutype,humod, states, noncontrib, st_SimplifyPreserveTopology(the_geom, 0.0005) as the_geom FROM huc12all_temp);" postgresql://$owner:$ownerpass@$host:5432/$db

psql -c "DROP TABLE huc12all_temp;" postgresql://$owner:$ownerpass@$host:5432/$db

sleep 10

echo Insert union_county
psql -c "CREATE TABLE union_county AS (SELECT ST_MakeValid(ST_Simplify(ST_Union(us_historical_counties.the_geom), 0.1, false)) as the_geom FROM us_historical_counties)" postgresql://$owner:$ownerpass@$host:5432/$db

echo Insert huc12
psql -c "CREATE TABLE huc12 AS (SELECT * FROM huc12all);" postgresql://$owner:$ownerpass@$host:5432/$db
psql -c "UPDATE huc12 SET the_geom = ST_Multi(ST_Intersection(huc12.the_geom, union_county.the_geom)) FROM union_county WHERE ST_Intersects(huc12.the_geom, union_county.the_geom);" postgresql://$owner:$ownerpass@$host:5432/$db
psql -c "DROP TABLE union_county;" postgresql://$owner:$ownerpass@$host:5432/$db
psql -c "DELETE FROM huc12 WHERE states = 'CAN';" postgresql://$owner:$ownerpass@$host:5432/$db

echo Create pgdumps and convert all schema names to public so ingestion jenkins file can convert to relevant schmea name
pg_dump -O -a -t $schema.gagesII postgresql://$owner:$ownerpass@$host:5432/$db > "dumps/gagesii.pgdump"
sed -i 's/'$schema'.gagesii/public.gagesii/g' ./dumps/gagesii.pgdump

pg_dump -O -a -t $schema.huc08 postgresql://$owner:$ownerpass@$host:5432/$db > "dumps/huc08.pgdump"
sed -i 's/'$schema'.huc08/public.huc08/g' ./dumps/huc08.pgdump

pg_dump -O -a -t $schema.huc12all postgresql://$owner:$ownerpass@$host:5432/$db > "dumps/huc12all.pgdump"
sed -i 's/'$schema'.huc12all/public.huc12all/g' ./dumps/huc12all.pgdump

pg_dump -O -a -t $schema.huc12 postgresql://$owner:$ownerpass@$host:5432/$db > "dumps/huc12.pgdump"
sed -i 's/'$schema'.huc12/public.huc12/g' ./dumps/huc12.pgdump

pg_dump -O -a -t $schema.huc12agg postgresql://$owner:$ownerpass@$host:5432/$db > "dumps/huc12agg.pgdump"
sed -i 's/'$schema'.huc12agg/public.huc12agg/g' ./dumps/huc12agg.pgdump

pg_dump -O -a -t $schema.nhdflowline_network postgresql://$owner:$ownerpass@$host:5432/$db > "dumps/nhdflowline_network.pgdump"
sed -i 's/'$schema'.nhdflowline_network/public.nhdflowline_network/g' ./dumps/nhdflowline_network.pgdump

pg_dump -O -a -t $schema.nhdarea postgresql://$owner:$ownerpass@$host:5432/$db > "dumps/nhdarea.pgdump"
sed -i 's/'$schema'.nhdarea/public.nhdarea/g' ./dumps/nhdarea.pgdump

pg_dump -O -a -t $schema.catchmentsp postgresql://$owner:$ownerpass@$host:5432/$db > "dumps/catchmentsp.pgdump"
sed -i 's/'$schema'.catchmentsp/public.catchmentsp/g' ./dumps/catchmentsp.pgdump

pg_dump -O -a -t $schema.nhdwaterbody postgresql://$owner:$ownerpass@$host:5432/$db > "dumps/nhdwaterbody.pgdump"
sed -i 's/'$schema'.nhdwaterbody/public.nhdwaterbody/g' ./dumps/nhdwaterbody.pgdump

for file in dumps/*.pgdump; do gzip $file; done;
