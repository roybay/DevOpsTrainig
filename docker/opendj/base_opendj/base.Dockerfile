# Create a Docker image for OpenDJ 6.0.0
FROM openjdk:8u131-jre-alpine

EXPOSE 1389
EXPOSE 1636
EXPOSE 4444
EXPOSE 8080
EXPOSE 8443

ARG SERVICE_USER=opendj
ARG SERVICE_GROUP=forgerock
ARG SERVICE_UID=11111
ARG FILE_HOME=/opt/bits
ARG OPENDJ_HOME=/opt/opendj
ARG OPENDJ_DATA=/opt/opendj-data
ARG DJ_HOST=localhost
ARG DJ_ZIP=../bits/DS-6.0.0.zip

ENV SERVICE_USER=$SERVICE_USER
ENV SERVICE_GROUP=$SERVICE_GROUP
ENV SERVICE_UID=$SERVICE_UID
ENV FILE_HOME=$FILE_HOME
ENV OPENDJ_HOME=$OPENDJ_HOME
ENV OPENDJ_DATA=$OPENDJ_DATA
ENV DJ_HOST=${DJ_HOST}

WORKDIR "${FILE_HOME}"

COPY "${DJ_ZIP}" ./DS.zip
RUN apk add --no-cache unzip bash rng-tools curl \
    && unzip -q ./DS.zip -d ../ \
    && rm -fr ./DS.zip \
    && mkdir -p  "${OPENDJ_DATA}" \
	&& echo "${OPENDJ_DATA}" > "${OPENDJ_HOME}"/instance.loc \
    && if [ "$SERVICE_USER" != "root" ]; then addgroup -g "${SERVICE_UID}" "${SERVICE_GROUP}"; fi \
    && if [ "$SERVICE_USER" != "root" ]; then adduser  -s /bin/bash -h "${OPENDJ_HOME}" -u "${SERVICE_UID}" -D "${SERVICE_USER}" -G "${SERVICE_GROUP}"; fi \
    && if [ "$SERVICE_USER" != "root" ]; then chown    -R "${SERVICE_USER}":"${SERVICE_GROUP}" "${FILE_HOME}" "${OPENDJ_HOME}" "${OPENDJ_DATA}"; fi

USER 	"${SERVICE_USER}"
WORKDIR "${OPENDJ_HOME}"
