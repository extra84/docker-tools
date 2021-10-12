FROM debian:bullseye-slim
ENV CARGO_HOME=/workspace/cargo
ENV RUSTUP_HOME=/workspace/rustup
RUN useradd -ms /bin/bash rust \
	&& mkdir /workspace \
	&& chown -R rust.rust /workspace \
	&& apt-get update \
	&& DEBIAN_FRONTEND=noninteractice apt-get install --no-install-recommends -y busybox \
											ca-certificates \
											curl \
											gcc \
											gcc-multilib \
											git \
											gosu \
											universal-ctags \
											vim \
											vim-common \
											vim-doc \
											vim-runtime \
											vim-scripts 
COPY vimrc /home/rust/.vimrc
COPY entrypoint.sh /usr/local/bin/init.sh
WORKDIR /workspace/projects
ENTRYPOINT /usr/local/bin/init.sh 
