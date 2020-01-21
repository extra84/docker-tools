FROM debian:buster-slim
COPY themes.jupyterlab-settings /root/.jupyter/lab/user-settings/\@jupyterlab/apputils-extension/themes.jupyterlab-settings
RUN useradd -ms /bin/bash jupyter \
        && apt-get update \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends busybox \
                                                                                gcc \
                                                                                git \
                                                                                gosu \
                                                                                make \
										npm \
										nodejs \
                                                                                python3 \
                                                                                python3-dev \
                                                                                python3-pip \
                                                                                python3-venv \
                                                                                yarnpkg \
        && mkdir -p /kernels \
        && mkdir -p /workspace/notebooks \
        && mkdir /workspace/envs \
        && mkdir /workspace/kernels \
        && mkdir /workspace/archives \
        && python3 -m pip install --no-cache-dir -U pip \
        && pip3 install --no-cache-dir setuptools wheel \
        && pip3 install --no-cache-dir jupyterlab \
        && apt-get clean \
        && rm -rf /var/cache/apt/* \
	&& cd /kernels \
	&& bash -c "python3 -m venv raw \
                && source /kernels/raw/bin/activate \
                && pip3 install --no-cache-dir ipykernel ipywidgets\
                && ipython kernel install --name=raw" \
        && bash -c "python3 -m venv stats \
                && source  /kernels/stats/bin/activate \
                && pip3 install --no-cache-dir ipykernel ipywidgets matplotlib pandas networkx \
                && ipython kernel install --name=stats" \
        && jupyter labextension install @lckr/jupyterlab_variableinspector \
	&& jupyter labextension install @jupyter-widgets/jupyterlab-manager \
	&& mkdir -p /home/jupyter/.jupyter/lab/user-settings/\@jupyterlab/apputils-extension/ \
	&& cp /root/.jupyter/lab/user-settings/\@jupyterlab/apputils-extension/themes.jupyterlab-settings /home/jupyter/.jupyter/lab/user-settings/\@jupyterlab/apputils-extension/themes.jupyterlab-settings \
        && chown -R jupyter /workspace/ \
        && chown -R jupyter.jupyter /home/jupyter \
        && chown jupyter /kernels \
        && chown jupyter /usr/local/share/jupyter/kernels


WORKDIR /workspace/
COPY entrypoint.sh /usr/local/bin/
COPY install.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
