pipeline {
  agent {
    node {
      label 'team:nhgf'
    }
  }
  stages {
    stage('Set Build Description') {
      steps {
        script {
          currentBuild.description = "Deploy to ${env.DEPLOY_STAGE}"
        }
      }
    }
    stage('Clean Workspace') {
      steps {
        cleanWs()
      }
    }
    stage('Git Clone') {
      steps {
        checkout([
            $class: 'GitSCM',
            branches: [[name: '*/master']],
            doGenerateSubmoduleConfigurations: false,
            extensions: [],
            submoduleCfg: [],
            userRemoteConfigs: [[credentialsId: 'CIDA-Jenkins-GitHub',
            url: 'https://github.com/NWQMC/wmadata-schema-data-prep.git']]])
      }
    }

    stage('Run geoserver config') {
      steps {
        script {
          def nldiSecretsString = sh(script: '/usr/local/bin/aws ssm get-parameter --name "/aws/reference/secretsmanager/NLDI_$DEPLOY_STAGE" --query "Parameter.Value" --with-decryption --output text --region "us-west-2"', returnStdout: true).trim()
          def iowGeoSecretsString = sh(script: '/usr/local/bin/aws ssm get-parameter --name "/aws/reference/secretsmanager/IOW-GEOSERVER" --query "Parameter.Value" --with-decryption --output text --region "us-west-2"', returnStdout: true).trim()
          def nldiSecretsJson  =  readJSON text: nldiSecretsString
          def iowGeoSecretsJson = readJSON text: iowGeoSecretsString
          env.NWIS_DATABASE_ADDRESS = nldiSecretsJson.DATABASE_ADDRESS
          env.NWIS_DATABASE_NAME = nldiSecretsJson.DATABASE_NAME
          env.WMADATA_SCHEMA_NAME = nldiSecretsJson.WMADATA_SCHEMA_NAME
          env.WMADATA_DB_READ_ONLY_USERNAME = nldiSecretsJson.WMADATA_DB_READ_ONLY_USERNAME
          env.WMADATA_DB_READ_ONLY_PASSWORD = nldiSecretsJson.WMADATA_DB_READ_ONLY_PASSWORD
          env.GEOSERVER_PASSWORD = iowGeoSecretsJson.admin
          env.GEOSERVER_WORKSPACE = 'wmadata'
          env.GEOSERVER_STORE = 'wmadata'

          sh '''
            if [ $DEPLOY_STAGE == "TEST" ]; then
               url="https://labs-dev.wma.chs.usgs.gov/geoserver"
            else
               url="https://labs.waterdata.usgs.gov/geoserver"
            fi

            touch wmadata_store.xml

            {
            echo '<dataStore>
              <name>'$GEOSERVER_STORE'</name>
              <connectionParameters>
                <host>'$NWIS_DATABASE_ADDRESS'</host>
                <port>5432</port>
                <database>'$NWIS_DATABASE_NAME'</database>
                <schema>'$WMADATA_SCHEMA_NAME'</schema>
                <user>'$WMADATA_DB_READ_ONLY_USERNAME'</user>
                <passwd>'$WMADATA_DB_READ_ONLY_PASSWORD'</passwd>
                <dbtype>postgis</dbtype>
              </connectionParameters>
            </dataStore>' > wmadata_store.xml
            } 2> /dev/null

            curl -v -u admin:$GEOSERVER_PASSWORD -XPOST -H "Content-type: text/xml" \
              -d "<workspace><name>$GEOSERVER_WORKSPACE</name></workspace>" \
              $url/rest/workspaces

            curl -v -u admin:$GEOSERVER_PASSWORD -XPOST -T wmadata_store.xml -H "Content-type: text/xml" \
              $url/rest/workspaces/$GEOSERVER_WORKSPACE/datastores

            curl -v -u admin:$GEOSERVER_PASSWORD -XPOST -H "Content-type: text/xml" \
              -d "<featureType><name>gagesii</name><nativeCRS>EPSG:4269</nativeCRS><srs>EPSG:4269</srs></featureType>" \
              $url/rest/workspaces/$GEOSERVER_WORKSPACE/datastores/$GEOSERVER_STORE/featuretypes

            curl -v -u admin:$GEOSERVER_PASSWORD -XPOST -H "Content-type: text/xml" \
              -d "<featureType><name>huc08</name><nativeCRS>EPSG:4269</nativeCRS><srs>EPSG:4269</srs></featureType>" \
              $url/rest/workspaces/$GEOSERVER_WORKSPACE/datastores/$GEOSERVER_STORE/featuretypes

            curl -v -u admin:$GEOSERVER_PASSWORD -XPOST -H "Content-type: text/xml" \
              -d "<featureType><name>huc12</name><nativeCRS>EPSG:4269</nativeCRS><srs>EPSG:4269</srs></featureType>" \
              $url/rest/workspaces/$GEOSERVER_WORKSPACE/datastores/$GEOSERVER_STORE/featuretypes

            curl -v -u admin:$GEOSERVER_PASSWORD -XPOST -H "Content-type: text/xml" \
              -d "<featureType><name>huc12all</name><nativeCRS>EPSG:4269</nativeCRS><srs>EPSG:4269</srs></featureType>" \
              $url/rest/workspaces/$GEOSERVER_WORKSPACE/datastores/$GEOSERVER_STORE/featuretypes

            curl -v -u admin:$GEOSERVER_PASSWORD -XPOST -H "Content-type: text/xml" \
              -d "<featureType><name>huc12agg</name><nativeCRS>EPSG:4269</nativeCRS><srs>EPSG:4269</srs></featureType>" \
              $url/rest/workspaces/$GEOSERVER_WORKSPACE/datastores/$GEOSERVER_STORE/featuretypes

            curl -v -u admin:$GEOSERVER_PASSWORD -XPOST -H "Content-type: text/xml" \
              -d "<featureType><name>catchmentsp</name><nativeCRS>EPSG:4269</nativeCRS><srs>EPSG:4269</srs></featureType>" \
              $url/rest/workspaces/$GEOSERVER_WORKSPACE/datastores/$GEOSERVER_STORE/featuretypes

            curl -v -u admin:$GEOSERVER_PASSWORD -XPOST -H "Content-type: text/xml" \
              -d "<featureType><name>nhdarea</name><nativeCRS>EPSG:4269</nativeCRS><srs>EPSG:4269</srs></featureType>" \
              $url/rest/workspaces/$GEOSERVER_WORKSPACE/datastores/$GEOSERVER_STORE/featuretypes

            curl -v -u admin:$GEOSERVER_PASSWORD -XPOST -H "Content-type: text/xml" \
              -d "<featureType><name>nhdflowline_network</name><nativeCRS>EPSG:4269</nativeCRS><srs>EPSG:4269</srs></featureType>" \
              $url/rest/workspaces/$GEOSERVER_WORKSPACE/datastores/$GEOSERVER_STORE/featuretypes

            curl -v -u admin:$GEOSERVER_PASSWORD -XPOST -H "Content-type: text/xml" \
              -d "<featureType><name>nhdflowline_nonnetwork</name><nativeCRS>EPSG:4269</nativeCRS><srs>EPSG:4269</srs></featureType>" \
              $url/rest/workspaces/$GEOSERVER_WORKSPACE/datastores/$GEOSERVER_STORE/featuretypes

            curl -v -u admin:$GEOSERVER_PASSWORD -XPOST -H "Content-type: text/xml" \
              -d "<featureType><name>nhdwaterbody</name><nativeCRS>EPSG:4269</nativeCRS><srs>EPSG:4269</srs></featureType>" \
              $url/rest/workspaces/$GEOSERVER_WORKSPACE/datastores/$GEOSERVER_STORE/featuretypes
            '''
        }
      }
    }
  }
}
