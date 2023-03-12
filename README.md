## Quick Start

This conatainer will check your current IP address and update a google cloud DNS record if needed.

Run the container with the following command:

```
docker run \
  --env-file envar \
  --volume "$(pwd)/credentials:/scripts/serviceaccounts" \
  --detach \
  --name googleupdatedns \
  complacentsee/googlednsupdate
```

