FROM ubuntu:15.10

ENV OPENCV_VERSION=master \
    OPENCV_CONTRIB_VERSION=master

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y -q install \
  build-essential \
  cmake \
  ca-certificates \
  curl \
  libjpeg8-dev \
  libtiff5-dev \
  libjasper-dev \
  libpng12-dev \
  libavcodec-dev \
  libavformat-dev \
  libswscale-dev \
  libv4l-dev \
  libatlas-base-dev \
  libfreetype6-dev \
  gfortran \
  octave \
  pkg-config \
  python-dev \
  python-openssl \
  python-pip \
  && apt-get clean && rm -rf /var/tmp/* /var/lib/apt/lists/* /tmp/*

# ------------------------------------- python deps -------------------------------------------
RUN pip install \
  docopt \
  numpy \
  scipy 

RUN pip install \
  matplotlib \
  mahotas \
  scikit-learn \
  scikit-image \
  oct2py \
  pandas \
  python-gflags \
  oauth2client \
  httplib2 \
  google-api-python-client 

# ------------------------------------- python niceties ---------------------------------------
RUN pip install \
  ipython \
  notebook

# ------------------------------------- OpenCV stuff ------------------------------------------
RUN mkdir -p /opt/src/opencv-${OPENCV_VERSION}/build \
  && curl -Lo /opt/src/opencv3.tar.gz \
     https://github.com/Itseez/opencv/archive/${OPENCV_VERSION}.tar.gz \
  && tar -xzvf /opt/src/opencv3.tar.gz -C /opt/src \
  # Get OpenCV Contrib
  && curl -Lo /opt/src/contrib.tar.gz \
     https://github.com/opencv/opencv_contrib/archive/${OPENCV_CONTRIB_VERSION}.tar.gz \
  && mkdir /opt/src/opencv_contrib \
  && tar -xzvf /opt/src/contrib.tar.gz -C /opt/src/opencv_contrib --strip-components=1 \
  ## Build
  && cd /opt/src/opencv-${OPENCV_VERSION}/build \
  && cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_C_EXAMPLES=ON \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_EXTRA_MODULES_PATH=/opt/src/opencv_contrib/modules \
    -D BUILD_EXAMPLES=ON .. \
  && make -j $(nproc) \
  && make install \
  && ldconfig -v \
  && rm -rf /opt/src

VOLUME /notebooks
WORKDIR /notebooks
EXPOSE 8888
CMD ["jupyter", "notebook", "--no-browser", "--ip", "0.0.0.0", "--port", "8888"]
