ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Copy data for add-on
COPY data/run.sh /
COPY data/snmp_test.sh /
RUN chmod a+x /run.sh

# Install requirements for add-on
RUN apk add --no-cache net-snmp python3 lm-sensors

CMD [ "/run.sh" ]
