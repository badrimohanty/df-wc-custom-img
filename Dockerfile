FROM python:3.11-slim-bookworm
#COPY --from=apache/beam_python3.11_sdk:2.54.0 /opt/apache/beam /opt/apache/beam
COPY --from=gcr.io/dataflow-templates-base/python311-template-launcher-base:20230622_RC00 /opt/google/dataflow/python_template_launcher /opt/google/dataflow/python_template_launcher

RUN pip install --no-cache-dir apache-beam[gcp]==2.58.1

# Location to store the pipeline artifacts.
ARG WORKDIR=/template
WORKDIR ${WORKDIR}

#COPY requirements.txt .
COPY main.py .

#RUN pip install --no-cache-dir -r requirements.txt
#RUN pip install -e .

# For more informaiton, see: https://cloud.google.com/dataflow/docs/guides/templates/configuring-flex-templates
ENV FLEX_TEMPLATE_PYTHON_PY_FILE="${WORKDIR}/main.py"
RUN pip check
RUN pip freeze
ENTRYPOINT ["/opt/google/dataflow/python_template_launcher"]
