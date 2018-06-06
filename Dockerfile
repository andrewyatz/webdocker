### docker container for ensembl webcode
FROM linuxbrew/linuxbrew

USER root

# update aptitude and install some required packages
RUN sudo apt-get update && sudo apt-get -y install python

# ---------
# MS CORE FONTS
# ---------
# from http://askubuntu.com/a/25614
RUN echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections
RUN apt-get install -y --no-install-recommends fontconfig ttf-mscorefonts-installer
ADD localfonts.conf /etc/fonts/local.conf
RUN fc-cache -f -v

# swtich to using linuxbrew user not root
USER linuxbrew

# Turn off analytics
RUN brew analytics off

# Setup moonshine
RUN mkdir -p $HOME/ENSEMBL_MOONSHINE_ARCHIVE
ENV HOMEBREW_ENSEMBL_MOONSHINE_ARCHIVE $HOME/ENSEMBL_MOONSHINE_ARCHIVE

# Tap brew repositories
RUN brew tap ensembl/external && \
  brew tap ensembl/ensembl && \
  brew tap ensembl/web && \
  brew tap ensembl/moonshine && \
  brew tap ensembl/cask

# Setup bioperl (will come in via the web cask)
ENV PERL5LIB /home/linuxbrew/.linuxbrew/opt/bioperl-169/libexec
# Setup Perl library dependencies
ENV HTSLIB_DIR=/home/linuxbrew/.linuxbrew/opt/htslib KENT_SRC=/home/linuxbrew/.linuxbrew/opt/kent MACHTYPE=x86_64 SHARE_PATH=/home/linuxbrew/paths

# install ensembl web dependencies
RUN brew update && brew info ensembl/cask/web-base
# Avoid berkeley-db@4 and berkeley-db issues
RUN brew install python
# Fetch ensembl tools
RUN brew install ensembl/ensembl/ensembl-git-tools
RUN brew install ensembl/cask/web-base

