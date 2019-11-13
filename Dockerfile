FROM sangwo/archlinux:latest

ENV MY_USERNAME=haoliang

ENV SWOOLE_VERSION="4.2.12"

COPY ./docker/scripts/ /usr/local/bin

# #{{{ php

RUN pacman -Syy --noconfirm && pacman -S --noconfirm --needed \
    php \
    xdebug \
    php-intl \
    php-mongodb

USER $MY_USERNAME
# todo customize config of swoole
RUN cower_install.sh php-swoole
USER root

# tool
RUN curl -SL "https://getcomposer.org/composer.phar" -o /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer

COPY ./docker/config/php/php.ini /etc/php/php.ini
COPY ./docker/config/php/ext/    /etc/php/conf.d/

# #}}}

# go #{{{
RUN pacman -Syy --noconfirm && pacman -S --noconfirm --needed \
    go go-tools \
    delve dep

USER $MY_USERNAME
RUN cower_install.sh gometalinter-git
USER root
# #}}}

# python #{{{
RUN pacman -Syy --noconfirm && pacman -S --noconfirm --needed \
    python python-doc \
    python-pip python-wheel \
    python-pylint flake8 mypy \
    ipython \
    poetry
# #}}}

# #{{{ tools

RUN pacman -Syy --noconfirm && pacman -S --noconfirm --needed \
    neovim \
    python-neovim \
    zsh \
    grml-zsh-config \
    tmux \
    the_silver_searcher \
    autojump \
    fzf \
    openssh \
    openssl \
    lsof \
    jq \
    mariadb-clients \
    whois \
    vifm \
    tree \
    bc \
    p7zip \
    dos2unix \
    traceroute \
    bind-tools \
    tcpdump \
    sysstat \
    socat \
    shellcheck \
    strace \
    stow \
    inotify-tools \
    netcat \
    ansible ansible-lint \
    colordiff \
    mosh \
    time \
    proxychains-ng

USER $MY_USERNAME
RUN cower_install.sh universal-ctags-git \
    gotty \
    git-recent-git
USER root

USER $MY_USERNAME
RUN cd /tmp && git clone --depth 1 https://gitlab.com/haoliang-aur/fpp-git.git \
    && cd fpp-git && makepkg -sirc --noconfirm
USER root

# #}}}

# #{{{ 善后

RUN pacman -Syu --noconfirm

RUN pacman -Scc --noconfirm
RUN rm -rf /tmp/*

# fixme
# see https://github.com/moby/moby/issues/3465#issuecomment-356988520
#unset MY_USERNAME

VOLUME ["/srv/http"]
VOLUME ["/root"]
VOLUME ["/home/$MY_USERNAME"]
VOLUME ["/srv/golang"]

WORKDIR /srv/http
USER $MY_USERNAME
ENTRYPOINT ["docker_entrypoint"]

# #}}}
