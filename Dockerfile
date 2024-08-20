FROM python:3.11-bookworm AS build-env
#COPY --from=apache/beam_python3.11_sdk:2.54.0 /opt/apache/beam /opt/apache/beam
#RUN pip install --no-cache-dir apache-beam[gcp]==2.58.1
COPY --from=gcr.io/dataflow-templates-base/python311-template-launcher-base:20230622_RC00 /opt/google/dataflow/python_template_launcher /opt/google/dataflow/python_template_launcher
RUN pip install --no-cache-dir apache-beam[gcp]==2.58.1
COPY --from=apache/beam_python3.11_sdk:2.58.1 /opt/apache/beam /opt/apache/beam

RUN pip check
RUN pip freeze

FROM gcr.io/distroless/python3
COPY --from=build-env /opt/google/dataflow/python_template_launcher /opt/google/dataflow/python_template_launcher
COPY --from=build-env /opt/apache/beam /opt/apache/beam

#COPY --from=build-env /usr/local/lib /usr/local/lib
#COPY --from=build-env /usr/local/gcloud /usr/local/gcloud
#COPY --from=build-env /usr/local/bin /usr/local/bin

# Location to store the pipeline artifacts.
ARG WORKDIR=/template
WORKDIR ${WORKDIR}
COPY main.py .
# For more informaiton, see: https://cloud.google.com/dataflow/docs/guides/templates/configuring-flex-templates
ENV FLEX_TEMPLATE_PYTHON_PY_FILE="${WORKDIR}/main.py"

ENTRYPOINT ["/opt/google/dataflow/python_template_launcher"]
