## Quick Start

This conatainer will check your current IP address and update a google cloud DNS record if needed.

Run the container with the following command:

```
$ docker run --env-file envar \
    -v "$(pwd)/credentials:/scripts/serviceaccounts" \ 
    googlednsupdate
```

