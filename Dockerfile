FROM gcr.io/google.com/cloudsdktool/google-cloud-cli:alpine 
 
RUN mkdir -p /scripts
RUN mkdir -p /scripts/serviceaccounts 
WORKDIR /scripts/ 
COPY ./scripts/dnsupdate.sh /scripts/dnsupdate.sh

CMD ["/scripts/dnsupdate.sh"]

