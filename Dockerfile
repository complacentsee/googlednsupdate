FROM gcr.io/google.com/cloudsdktool/google-cloud-cli:alpine 
 
RUN mkdir -p /scripts
RUN mkdir -p /scripts/serviceaccounts 
WORKDIR /scripts/ 
COPY ./scripts/dnsupdate.sh /scripts/dnsupdate.sh

# Set the health check command
HEALTHCHECK --interval=5m --timeout=3s \
  CMD ps aux | grep '/scripts/dnsupdate.sh'| grep -v grep || exit 1

CMD ["/scripts/dnsupdate.sh"]

