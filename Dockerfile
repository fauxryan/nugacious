FROM atomist/sdm-base:0.2.0@sha256:e6d29d215754fbec85c638d1c313fc81f44d96bf22f9373e200c713bf6f76fcd

# Install yarn
RUN npm install --global yarn

# Install .NET Core tools
ENV DOTNET_CLI_TELEMETRY_OPTOUT 1
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get install -y apt-transport-https \
    && apt-get update \
    && apt-get install -y dotnet-sdk-2.2

RUN apt-get update && apt-get install -y \
        openjdk-8-jdk-headless maven \
        libfontconfig \
    && rm -rf /var/lib/apt/lists/*

COPY package.json package-lock.json ./

RUN npm ci \
    && npm cache clean --force

COPY . .
