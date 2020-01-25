FROM debian
MAINTAINER mplm17

ARG USER=noip-autorenew
ARG UID=1000
ARG HOME=/noip-autorenew
ARG DEBIAN_FRONTED=noninteractive

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install ruby ruby-mechanize ruby-nokogiri

RUN mkdir $HOME
COPY noip.autorenew.rb $HOME
RUN useradd -d $HOME -u $UID $USER
RUN chown -R noip-autorenew:noip-autorenew $HOME
RUN chmod 700 "$HOME/noip.autorenew.rb"
USER $USER
WORKDIR $HOME
CMD ["bash"]
