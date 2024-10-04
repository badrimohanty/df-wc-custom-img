FROM python:3.11-bookworm
#COPY --from=apache/beam_python3.11_sdk:2.54.0 /opt/apache/beam /opt/apache/beam
COPY --from=gcr.io/dataflow-templates-base/python311-template-launcher-base:latest /opt/google/dataflow/python_template_launcher /opt/google/dataflow/python_template_launcher

# Location to store the pipeline artifacts.
ARG WORKDIR=/template
WORKDIR ${WORKDIR}

COPY requirements.txt .
COPY main.py .

RUN pip install --no-cache-dir -r requirements.txt
#RUN pip install -e .

# For more informaiton, see: https://cloud.google.com/dataflow/docs/guides/templates/configuring-flex-templates
ENV FLEX_TEMPLATE_PYTHON_PY_FILE="${WORKDIR}/main.py"
ENV LD_LIBRARY_PATH="/opt/lib/oracle_client/"
RUN pip check
RUN pip freeze
ENTRYPOINT ["/opt/google/dataflow/python_template_launcher"]
