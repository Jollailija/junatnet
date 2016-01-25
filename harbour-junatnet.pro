# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-junatnet
# Thanks, kimmoli! For future reference: https://github.com/kimmoli/test5-app/blob/master/test5.pro
TEMPLATE = aux

qml.files = qml/*

qml.path = /usr/share/harbour-junatnet/qml

desktop.files = harbour-junatnet.desktop
desktop.path = /usr/share/applications

OTHER_FILES += \
    qml/* \
    qml/pages/* \
    rpm/harbour-junatnet.spec \
    translations/*.ts \
    harbour-junatnet.desktop \
    harbour-junatnet.png \
    qml/harbour-junatnet.png \
    rpm/harbour-junatnet.changes \
    qml/pages/harbour-junatnet.png \
    qml/harbour-junatnet.png

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

TRANSLATIONS += translations/harbour-junatnet-fi.ts

appicons.path = /usr/share/icons/hicolor/
appicons.files = appicons/*

INSTALLS += appicons qml desktop

DISTFILES += \
    qml/pages/storage.js \
    translations/harbour-junatnet.ts \
    translations/harbour-junatnet-fi.ts
