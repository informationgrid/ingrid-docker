ARG IGE_NG_VERSION
FROM docker-registry.wemove.com/ingrid-ige-ng:$IGE_NG_VERSION AS midstage
COPY ./selfSignedCerts /certificates
COPY ./importSelfSignedCert.sh /
ARG CERT_FILE_NAME_1
RUN /importSelfSignedCert.sh $CERT_FILE_NAME_1
ARG CERT_FILE_NAME_2
RUN /importSelfSignedCert.sh $CERT_FILE_NAME_2
FROM midstage AS finalstage
