FROM almalinux/8-base

# Install OCaml toolchain dependencies
RUN set -eux; \
        dnf install -y \
            sudo \
            openssl \
            unzip \
            bubblewrap \
            make \
            gcc \
            rsync \
            git \
            mercurial \
            bzip2 \
        ;

# Install Vim, Emacs, and some useful utilities
RUN set -eux; \
        dnf install -y \
            vim \
            emacs \
            less \
            tree \
            procps-ng \
        ;

# Create a non-root sudoer
RUN set -eux; \
        sh -c 'sed -i \
            "s/^# %wheel\tALL=(ALL)\tNOPASSWD: ALL/%wheel\tALL=(ALL)\tNOPASSWD: ALL/" \
            /etc/sudoers' \
        ;\
        useradd fabian -G wheel;

USER fabian
WORKDIR /home/fabian

# Install opam
RUN set -eux; \
        mkdir -p /usr/local/bin; \
        sudo chown root:root /usr/local/bin; \
        \
        curl -LO https://opam.ocaml.org/install.sh; \
        chmod 700 install.sh; \
        sh -c "echo -e '/usr/local/bin\n' | ./install.sh"; \
        rm install.sh;

ARG OCAML_VERSION=4.13.1

# Install the OCaml compiler, Core libraries, and utop
RUN set -eux; \
        opam init --auto-setup --disable-sandboxing; \
        opam switch create ${OCAML_VERSION}; \
        opam switch set ${OCAML_VERSION}; \
        opam install -y \
            core \
            core_bench \
            utop \
        ;\
        echo '#require "core.top";;' > .ocamlinit; \
        echo '#require "ppx_jane";;' >> .ocamlinit; \
        echo 'open Base;;' >> .ocamlinit;

# Install OCaml editor support for Vim and Emacs
RUN set -eux; \
        opam switch set ${OCAML_VERSION}; \
        opam install -y \
            user-setup \
            ocamlformat \
            ocaml-lsp-server \
            merlin \
            tuareg \
        ;\
        opam user-setup install;

# Set additional environment changes
RUN set -eux; \
        echo 'eval $(opam env)' >> .bashrc;

ENTRYPOINT ["/usr/bin/bash"]
