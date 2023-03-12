[![Build Docker Image](https://github.com/complacentsee/googlednsupdate/actions/workflows/buildandpushdockerimage.yaml/badge.svg)](https://github.com/complacentsee/googlednsupdate/actions/workflows/buildandpushdockerimage.yaml)

## Quick Start

This container will check your current IP address and update a Google Cloud DNS record if needed.

To run the container, use the following command:

```
docker run \
  --env-file envar \
  --volume "$(pwd)/credentials:/scripts/serviceaccounts" \
  --detach \
  --name googleupdatedns \
  complacentsee/googlednsupdate
```

### Environmental Variables
The script will look for the following envirnmental variables. These can be explicity set, or set using an envar file. 
```
PROJECT_ID=my-GoogleCloudProjectID    #The ProjectID that the script should run against
ZONE_NAME=my-zone                     #The name of your DNS Zone
RECORD_NAME=my-record                 #The name of our A record
#SERVICE_ACCOUNT_FILE=/		      #Optional, you can specify an explicit path to a service account file.
#TTL=300                              #Optional, can you specify an explicit TTL
#CHECK_INTERVAL=1600                  #Optional, can you specify an explicit delay beteen checks. 
```

