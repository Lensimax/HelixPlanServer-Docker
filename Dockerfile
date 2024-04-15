FROM ubuntu:20.04

ARG HELIXPLAN_VERSION=2024.1010

# Env variables
ENV HELIXPLAN_SERVER_NAME="My Helix Plan Server"
ENV HELIXPLAN_SERVER_DATABASE_NAME="My Projects"
ENV HELIXPLAN_SERVER_DATABASE_PASSWORD="qwerty"
ENV HELIXPLAN_SERVER_ADMIN_PASSWORD="qwerty"

RUN apt clean
RUN apt update
# Install needed tools
RUN apt install -y --no-install-recommends curl unzip libasound2 libx11-xcb1 libxkbcommon0 libxkbcommon-x11-0 libfontconfig1 libxrender1 libice6 libsm6 libharfbuzz0b libxcb-randr0


# Get the HelixPlan archive file
RUN curl -k -o HelixPlanServerX64.zip -A "Mozilla/5.0 (compatible; MSIE 7.01; Windows NT 5.0)" -L https://cache.hansoft.com/Helix%20Plan+Server+${HELIXPLAN_VERSION}+Linux2.6+x64.zip

# extract archive in the opt folder
RUN unzip -d /opt/ HelixPlanServerX64.zip

RUN rm HelixPlanServerX64.zip

# Copy server config and run script
COPY run.sh /opt/

# create user Hansoft
RUN useradd -m hansoft && \
    cp /root/.bashrc /home/hansoft/ && \
    mkdir /home/hansoft/data && \
    chown -R --from=root hansoft /home/hansoft

# define working directory
WORKDIR /opt/HelixPlanServer

# expose Helix Plan server port
EXPOSE 50256

# Set user right
RUN chown -R hansoft:hansoft /opt/
USER hansoft


CMD ["/bin/bash", "/opt/run.sh"]


