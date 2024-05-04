ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG PROJECT_NAME=docker-ml-template
ARG USER_NAME=docker
ARG GROUP_NAME=docker
ARG UID=1000
ARG GID=1000
ARG APPLICATION_DIRECTORY=/home/${USER_NAME}/${PROJECT_NAME}/
ARG USE_POETRY=false

ENV LC_ALL="C.UTF-8"
ENV TZ=Asia/Tokyo
ENV HOME=/home/${USER_NAME}
ENV PYTHONPATH=${HOME}:${PYTHONPATH}
ENV PATH="${HOME}/.local/bin:$PATH"

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    sudo \
    openssh-client \
    tmux \
    tree \
    tzdata \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN groupadd -g ${GID} ${GROUP_NAME} \
    && useradd -ms /bin/bash --uid ${UID} -g ${GID} -G sudo ${USER_NAME} \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER ${USER_NAME}

RUN pip3 install -U pip \
    && curl -sSL https://install.python-poetry.org | python3 -

COPY --chown=${UID}:${GID} pyproject.toml poetry.lock poetry.toml ${APPLICATION_DIRECTORY}
WORKDIR ${APPLICATION_DIRECTORY}

RUN test ${USE_POETRY} = "true" && poetry install || echo "skip to run poetry install."
# RUN test ${USE_POETRY} = "false" && pip install -r requirements.txt || \
#     echo "skip to install with requirements.txt"

CMD ["/bin/bash"]
