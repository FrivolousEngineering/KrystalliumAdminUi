
#include <memory>

#include <QDebug>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QQuickWindow>

#include <Zax/Core/CommandLineParser.h>
#include <Zax/JsonApi/Api.h>
#include <Zax/JsonApi/ApiModel.h>

#include "AttributeTypes.h"

using namespace Qt::StringLiterals;

int main(int argc, char* argv[])
{
    auto app = std::make_shared<QGuiApplication>(argc, argv);
    app->setApplicationName(u"Krystalium Admin"_s);
    // app->setApplicationVersion();
    app->setOrganizationDomain(u"org.frivolousengineering"_s);

    QQuickStyle::setStyle(u"QtQuick.Controls.Material"_s);

    auto parser = Zax::Core::CommandLineParser::instance();
    parser->addOptions({ { u"server"_s, u"Connect to the specified server"_s, QMetaType::QString },
        { u"path"_s, u"Path to the API on the server"_s, QMetaType::QString },
        { u"username"_s, u"Username to use to connect"_s, QMetaType::QString },
        { u"password"_s, u"Password to use to connect"_s, QMetaType::QString },
        { u"autoconnect"_s, u"Immediately try to connect, don't show the connect screen"_s } }); //,
    // { u"page"_s, u""_s } });
    parser->process();

    if (parser->isSet("autoconnect")) {
        auto api = Zax::JsonApi::Api::instance();
        api->setServers({ parser->value<QString>("server") });
        api->setApiPath(parser->value<QString>("path"));
        api->setUserName(parser->value<QString>("username"));
        api->setPassword(parser->value<QString>("password"));
        api->start();
    }

    AttributeTypes::registerTypes();

    auto engine = std::make_shared<QQmlApplicationEngine>();
    QObject::connect(engine.get(), &QQmlApplicationEngine::objectCreationFailed, app.get(), &QCoreApplication::quit);
    engine->loadFromModule("Krystal.Admin", "Main");

    return app->exec();
}
