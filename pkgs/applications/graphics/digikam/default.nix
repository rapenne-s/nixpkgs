{ mkDerivation, lib, fetchurl, cmake, doxygen, extra-cmake-modules, wrapGAppsHook

# For `digitaglinktree`
, perl, sqlite

, qtbase
, qtxmlpatterns
, qtsvg
, qtwebengine

, akonadi-contacts
, kcalendarcore
, kconfigwidgets
, kcoreaddons
, kdoctools
, kfilemetadata
, knotifications
, knotifyconfig
, ktextwidgets
, kwidgetsaddons
, kxmlgui

, bison
, boost
, eigen
, exiv2
, ffmpeg
, flex
, lcms2
, lensfun
, libgphoto2
, libkipi
, libksane
, liblqr1
, libqtav
, libusb1
, marble
, libGL
, libGLU
, opencv3
, pcre
, threadweaver

# For panorama and focus stacking
, enblend-enfuse
, hugin
, gnumake

, breeze-icons
, oxygen
}:

mkDerivation rec {
  pname   = "digikam";
  version = "6.4.0";

  src = fetchurl {
    url = "https://download.kde.org/stable/${pname}/${version}/${pname}-${version}.tar.xz";
    sha256 = "0vwd97zkxv30y8x0z76s4fsj4w9ysgsmpjclp2h2bpava7zi4l3p";
  };

  nativeBuildInputs = [ cmake doxygen extra-cmake-modules kdoctools wrapGAppsHook ];

  buildInputs = [
    bison
    boost
    eigen
    exiv2
    ffmpeg
    flex
    lcms2
    lensfun
    libgphoto2
    libkipi
    libksane
    liblqr1
    libqtav
    libusb1
    libGL
    libGLU
    opencv3
    pcre

    qtbase
    qtxmlpatterns
    qtsvg
    qtwebengine

    akonadi-contacts
    kcalendarcore
    kconfigwidgets
    kcoreaddons
    kfilemetadata
    knotifications
    knotifyconfig
    ktextwidgets
    kwidgetsaddons
    kxmlgui

    breeze-icons
    marble
    oxygen
    threadweaver
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DENABLE_MYSQLSUPPORT=1"
    "-DENABLE_INTERNALMYSQL=1"
    "-DENABLE_MEDIAPLAYER=1"
    "-DENABLE_QWEBENGINE=on"
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ gnumake hugin enblend-enfuse ]})
    gappsWrapperArgs+=(--suffix DK_PLUGIN_PATH : ${placeholder "out"}/${qtbase.qtPluginPrefix}/${pname})
    substituteInPlace $out/bin/digitaglinktree \
      --replace "/usr/bin/perl" "${perl}/bin/perl" \
      --replace "/usr/bin/sqlite3" "${sqlite}/bin/sqlite3"
  '';

  meta = with lib; {
    description = "Photo Management Program";
    license = licenses.gpl2;
    homepage = "https://www.digikam.org";
    platforms = platforms.linux;
  };
}
