FROM quay.io/operator-framework/ansible-operator:v1.12.0

ARG DEFAULT_AWX_VERSION
ARG OPERATOR_VERSION
ENV DEFAULT_AWX_VERSION=${DEFAULT_AWX_VERSION}
ENV OPERATOR_VERSION=${OPERATOR_VERSION}

COPY requirements.yml ${HOME}/requirements.yml
RUN ansible-galaxy collection install -r ${HOME}/requirements.yml \
 && chmod -R ug+rwx ${HOME}/.ansible

COPY watches.yaml ${HOME}/watches.yaml
COPY roles/ ${HOME}/roles/
COPY playbooks/ ${HOME}/playbooks/

# TODO: this is only needed if we use receptor to generate the mesh CA.
# We can probably use openssl for that.
COPY --from=quay.io/ansible/receptor:devel /usr/bin/receptor /usr/bin/receptor
