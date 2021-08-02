FROM appimagecrafters/appimage-builder:latest

RUN apt-get update -q -y && apt-get upgrade -q -y && \
apt-get install -y build-essential git p7zip-full p7zip-rar nasm libpng-dev zlib1g-dev libsdl2-dev libsdl2-mixer-dev libgme-dev libopenmpt-dev libcurl4-openssl-dev rapidjson-dev cmake fuse nano pkg-config
