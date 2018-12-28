FROM forgerock-docker-public.bintray.io/forgerock/openig:6.0.0

COPY config /var/openig/config/

USER root
RUN chown -R forgerock /var/openig/config
USER forgerock