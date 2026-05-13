FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    curl \
    wget \
    git \
    sudo \
    vim \
    nano \
    htop \
    btop \
    neofetch \
    openssh-server \
    openssh-client \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    build-essential \
    gcc \
    g++ \
    make \
    cmake \
    net-tools \
    iproute2 \
    dnsutils \
    inetutils-ping \
    traceroute \
    nmap \
    unzip \
    zip \
    tar \
    gzip \
    bzip2 \
    xz-utils \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    ffmpeg \
    imagemagick \
    jq \
    yq \
    tmux \
    screen \
    rsync \
    sshfs \
    lsof \
    strace \
    iotop \
    iftop \
    tree \
    mc \
    fish \
    zsh \
    bash-completion \
    man \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@latest yarn pm2 nodemon typescript eslint prettier \
    && rm -rf /var/lib/apt/lists/*

RUN echo "root:2010" | chpasswd

RUN sed -i 's/^#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/^#*KbdInteractiveAuthentication.*/KbdInteractiveAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/^#*ChallengeResponseAuthentication.*/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config \
    && echo "PermitRootLogin yes" > /etc/ssh/sshd_config.d/99-root.conf \
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config.d/99-root.conf \
    && echo "KbdInteractiveAuthentication yes" >> /etc/ssh/sshd_config.d/99-root.conf \
    && rm -f /etc/ssh/sshd_config.d/60-cloudimg-settings.conf 2>/dev/null || true

RUN mkdir -p /var/run/sshd /workspace

COPY start.sh /start.sh
RUN chmod +x /start.sh

WORKDIR /workspace

EXPOSE 22 80 3000 8080

CMD ["/start.sh"]
