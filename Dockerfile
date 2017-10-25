### docker container for ensembl webcode
FROM linuxbrew/linuxbrew

# update aptitude and install some required packages
#RUN apt-get update && apt-get -y install 

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

# install ensembl web dependencies
RUN brew update && brew info ensembl/cask/web
RUN brew install python
RUN brew install ensembl/cask/web-base
RUN brew install ensembl/cask/web-perllibs
RUN brew install ensembl/cask/web-gui
# Need to do this to ignore a pcre error
RUN brew install ensembl/ensembl/blast; exit 0
RUN brew install ensembl/cask/web-bifo

# Setup bioperl (came in via the web cask)
ENV PERL5LIB $PERL5LIB:$HOME/.linuxbrew/opt/bioperl-169
# Setup Perl library dependencies
ENV HTSLIB_DIR $HOME/.linuxbrew/opt/htslib
ENV KENT_SRC $HOME/.linuxbrew/opt/kent

# clone git repositories
RUN mkdir -p src
WORKDIR $HOME/src
RUN git clone https://github.com/Ensembl/ensembl.git
RUN git clone https://github.com/Ensembl/ensembl-webcode.git

# Install Perl dependencies
ADD https://raw.githubusercontent.com/Ensembl/cpanfiles/master/web/cpanfile cpanfile
RUN cpanm --installdeps --with-recommends --notest --cpanfile ensembl/cpanfile .
RUN cpanm --installdeps --with-recommends --notest --cpanfile cpanfile .

# Switch back to home
WORKDIR $HOME
# switch back to vep user
# USER vep

# update bash profile
RUN echo >> $HOME/.profile && \
echo PATH=$HOME/.linuxbrew/bin:\$PATH >> $HOME/.profile && \
echo export PATH >> $HOME/.profile && \
echo export PERL5LIB=${PERL5LIB} >> $HOME/.profile && \
echo export ENSEMBL_MOONSHINE_ARCHIVE=${ENSEMBL_MOONSHINE_ARCHIVE}} >> $HOME/.profile

