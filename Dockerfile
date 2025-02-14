# Use Python 3.11 on Alpine as the base image
FROM python:3.11-alpine

# Set OpenCV version
ENV OPENCV_VERSION=4.9.0

# Set working directory
WORKDIR /opt/build

# Install necessary dependencies
RUN apk add --no-cache \
    build-base cmake wget unzip python3-dev \
    libjpeg-turbo-dev libpng-dev tiff-dev libwebp-dev eigen-dev openblas-dev \
    linux-headers \
    && pip install numpy

# Download OpenCV and OpenCV contrib sources
RUN wget -q https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip -O opencv.zip \
    && wget -q https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip -O opencv_contrib.zip \
    && unzip opencv.zip -d /opt \
    && unzip opencv_contrib.zip -d /opt

# Build OpenCV
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib-${OPENCV_VERSION}/modules \
    -D PYTHON3_EXECUTABLE=$(which python3) \
    /opt/opencv-${OPENCV_VERSION} \
    && make -j2 \
    && make install \
    && rm -rf /opt/opencv-${OPENCV_VERSION} /opt/opencv_contrib-${OPENCV_VERSION}

# Set default command
CMD ["python3"]
