# AppImages for SRB2Kart

There are 2 builds available: Latest upstream Git or the [Moe mansion](https://mb.srb2.org/addons/srb2kart-1-3-moe-mansion.42/) community build and each build is available with or wothout assets.

To use just download the `.AppImage` of your choice from [here](https://github.com/Lonsfor/srb2k-appimage/releases/latest), make it executible (with GUI or Terminal) and run it.

Terminal example:
```
chmod +x srb2kart*.AppImage
./srb2kart*.AppImage
```

Ignore the `.zsync` files those are for the updating system.

### noassets:

If you download an AppImage without assets make sure you have them somewere else beforehand. In case you do not, they can be extracted from the [srb2kart installer](https://github.com/STJr/Kart-Public/releases/download/v1.3/srb2kart-v13-Installer.exe). Just open it like a `.zip` file and place the `.kart`, `.srb`, `mdls` and `mdls.dat` in `~/.srb2kart`.

```
wget https://github.com/STJr/Kart-Public/releases/download/v1.3/srb2kart-v13-Installer.exe
7z x srb2kart-v13-Installer.exe -o"$HOME"/.srb2kart/ "*.kart" "*.srb" "mdls.dat" "mdls/*"
rm srb2kart-v13-Installer.exe  # remove it since we dont need it now
```

