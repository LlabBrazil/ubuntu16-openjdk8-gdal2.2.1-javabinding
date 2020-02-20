FROM picoded/ubuntu-openjdk-8-jdk

RUN curl -O http://download.osgeo.org/gdal/2.2.1/gdal221.zip

RUN apt-get update
RUN apt-get install -y zip

RUN unzip -o gdal221.zip -d /
RUN apt-get install -y \
    pkg-config \
    swig \
    bash-completion \
    software-properties-common \
    python-software-properties \
    build-essential \
    python-dev \
    python-numpy \
    libspatialite-dev \
    sqlite3 \
    libpq-dev \
    libcurl4-gnutls-dev \
    libproj-dev \
    libxml2-dev \
    libgeos-dev \
    libnetcdf-dev \
    libpoppler-dev \
    libspatialite-dev \
    libhdf4-alt-dev \
    libhdf5-serial-dev \
    wget
RUN cd /gdal-2.2.1 && ./configure --with-static-proj4=/usr/local --with-java=yes
RUN apt-get install -y swig
RUN cd /gdal-2.2.1 && make
RUN cd /gdal-2.2.1 && su && make install

RUN echo 'JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64\n'"$(cat /gdal-2.2.1/swig/java/java.opt)" > /gdal-2.2.1/swig/java/java.opt
RUN cd /gdal-2.2.1/swig/java && make
RUN cd /gdal-2.2.1/swig/java && su && make install

RUN cd /gdal-2.2.1/swig/java && cp *.so /usr/local/lib
RUN export PATH=/usr/local/bin:$PATH
RUN export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
RUN export GDAL_DATA=/usr/local/share/gdal

CMD tail -f /dev/null