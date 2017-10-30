### docker container for ensembl webcode
FROM linuxbrew/linuxbrew

# update aptitude and install some required packages
RUN sudo apt-get update && sudo apt-get -y install python

# swtich to using linuxbrew user not root
USER linuxbrew

# Turn off analytics
RUN brew analytics off

# Setup moonshine
RUN mkdir -p $HOME/ENSEMBL_MOONSHINE_ARCHIVE
ENV ENSEMBL_MOONSHINE_ARCHIVE $HOME/ENSEMBL_MOONSHINE_ARCHIVE

# Tap brew repositories
RUN brew tap homebrew/science && \
  brew tap ensembl/ensembl && \
  brew tap ensembl/web && \
  brew tap ensembl/moonshine && \
  brew tap ensembl/cask && \
  brew tap homebrew/nginx

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

