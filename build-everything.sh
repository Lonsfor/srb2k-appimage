#! /bin/bash

set -x
set -e

sudo apt update -yq && sudo apt upgrade -yq
sudo apt install -yq build-essential git p7zip-full p7zip-rar nasm libpng-dev zlib1g-dev libsdl2-dev libsdl2-mixer-dev libgme-dev libopenmpt-dev libcurl4-openssl-dev rapidjson-dev cmake fuse nano pkg-config

git clone https://github.com/discord/discord-rpc.git
cd discord-rpc
mkdir build
cd build
cmake .. -DBUILD_EXAMPLES=OFF -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=/usr
sudo cmake --build . --config Release --target install
cd ../..

git clone https://github.com/STJr/Kart-Public.git kart
cd kart
LIBGME_CFLAGS= LIBGME_LDFLAGS=-lgme make -C src/ LINUX64=1 NOUPX=1 NOOBJDUMP=1 HAVE_DISCORDRPC=1
cd ..

wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
chmod +x linuxdeploy*.AppImage

mkdir -p AppDir/usr/bin
mkdir -p AppDir/usr/share/applications
install -Dm755 kart/bin/Linux64/Release/lsdl2srb2kart AppDir/usr/bin/srb2kart
install -Dm755 AppRun AppDir/
install -Dm644 kart/srb2.png AppDir/usr/share/icons/hicolor/256x256/apps/org.srb2.SRB2Kart.png
install -Dm644 org.srb2.SRB2Kart.desktop AppDir/usr/share/applications/org.srb2.SRB2Kart.desktop
chmod -R a+rx AppDir

export VERSION=1.3-git-$(cd kart && git rev-parse --short HEAD)

export UPDATE_INFORMATION=gh-releases-zsync|lonsfor|srb2k-appimage|continuous|srb2kart-noassets-x86_64.AppImage.zsync 
OUTPUT=srb2kart-noassets-x86_64.AppImage ./linuxdeploy-x86_64.AppImage --appdir AppDir --output appimage

wget https://github.com/STJr/Kart-Public/releases/download/v1.3/srb2kart-v13-Installer.exe
7z x srb2kart-v13-Installer.exe -oAppDir/usr/games/SRB2Kart/ "*.kart" "*.srb" "mdls.dat" "mdls/*"
chmod -R a+rx AppDir

export UPDATE_INFORMATION=gh-releases-zsync|lonsfor|srb2k-appimage|continuous|srb2kart-x86_64.AppImage.zsync 
OUTPUT=srb2kart-x86_64.AppImage ./linuxdeploy-x86_64.AppImage --appdir AppDir --output appimage
