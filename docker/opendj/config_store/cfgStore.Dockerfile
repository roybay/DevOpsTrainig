# Create a Docker image for initialising OpenDJ 6.0.0

ARG BASE_IMAGE=molpis/opendj_base:6.0.0

FROM ${BASE_IMAGE}

ARG TYPE="directory-server"
ARG STRUCTURE="${FILE_HOME}/Artifacts/structure.ldif"
ARG SCHEMA="${FILE_HOME}/Artifacts/opendj_config_schema.ldif"
ARG DB_CACHE_PERCENT="70"
ARG BASE_DN="dc=roylab,dc=com"
ARG ROOT_USER_DN="cn=Directory Manager"
ARG ROOT_USER_PASSWORD_FILE="${FILE_HOME}"/Artifacts/.pw_root_user
ARG ADMIN_USER="AdminUser"
ARG ADMIN_PASSWORD_FILE="${FILE_HOME}"/Artifacts/.pw_admin_user
ARG MONITOR_USER_DN="uid=Monitor"
ARG MONITOR_USER_PASSWORD_FILE="${FILE_HOME}"/Artifacts/.pw_monitor_user

ENV TYPE=$TYPE
ENV STRUCTURE=$STRUCTURE
ENV SCHEMA=$SCHEMA
ENV BASE_DN=$BASE_DN
ENV DB_CACHE_PERCENT=$DB_CACHE_PERCENT
ENV ROOT_USER_DN=$ROOT_USER_DN
ENV ROOT_USER_PASSWORD_FILE=$ROOT_USER_PASSWORD_FILE
ENV ADMIN_USER=$ADMIN_USER
ENV ADMIN_PASSWORD_FILE=$ADMIN_PASSWORD_FILE
ENV MONITOR_USER_DN=$MONITOR_USER_DN
ENV MONITOR_USER_PASSWORD_FILE=$MONITOR_USER_PASSWORD_FILE

#See base.Dockerfile for environment variables
WORKDIR "${FILE_HOME}"

RUN mkdir Artifacts

RUN echo "Password1!" >> $ROOT_USER_PASSWORD_FILE
RUN echo "Password1" >> $ADMIN_PASSWORD_FILE
RUN echo "Password2" >> $MONITOR_USER_PASSWORD_FILE
RUN chmod 400 -R "${FILE_HOME}"/Artifacts/.pw*

COPY Artifacts/structure.ldif Artifacts/opendj_config_schema.ldif "${FILE_HOME}"/Artifacts/
COPY scripts/setup_functions.sh scripts/setup_functions_variables.sh Artifacts/setup_opendj.sh "${FILE_HOME}"/

USER root
RUN  chown -R "${SERVICE_USER}":"${SERVICE_GROUP}" "${FILE_HOME}"
RUN  chmod 744 -R "${FILE_HOME}"/*.sh

USER    "${SERVICE_USER}"
WORKDIR "${FILE_HOME}"

RUN "${FILE_HOME}"/setup_opendj.sh
RUN "${OPENDJ_HOME}"/bin/start-ds
