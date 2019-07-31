QT += qml quick quickcontrols2 sql positioning webview location widgets
android:QT += androidextras

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android-sources

CONFIG += c++11

SOURCES += main.cpp \
    qqmlsortfilterproxymodel.cpp \
    mobiledevice.cpp \
    permissions.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    qqmlsortfilterproxymodel.h \
    requisites.h \
    mobiledevice.h \
    permissions.h

DISTFILES += \
    android-sources/AndroidManifest.xml \
    android-sources/gradle/wrapper/gradle-wrapper.jar \
    android-sources/gradlew \
    android-sources/res/values/libs.xml \
    android-sources/build.gradle \
    android-sources/gradle/wrapper/gradle-wrapper.properties \
    android-sources/gradlew.bat \
    qtquickcontrols.conf
