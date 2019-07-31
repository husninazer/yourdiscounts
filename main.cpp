#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include<QGeoLocation>

#include<QtWebView>

#include "requisites.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQuickStyle::setStyle("Material");

    QtWebView::initialize();



    QQmlApplicationEngine engine;

     Requisites requisites; engine.rootContext()->setContextProperty("Requisites", &requisites);
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}
