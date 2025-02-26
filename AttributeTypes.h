#pragma once

#include <QJsonValue>
#include <QVariant>

class AttributeTypes
{
public:
    static void registerTypes();

    static QVariant actionFromJson(const QJsonValue &input);
    static QJsonValue actionToJson(const QVariant &input);
    static QVariant targetFromJson(const QJsonValue &input);
    static QJsonValue targetToJson(const QVariant &input);
    static QVariant effectFromJson(const QJsonValue &input);
    static QJsonValue effectToJson(const QVariant &input);
    static QVariant effectListFromJson(const QJsonValue &input);
    static QJsonValue effectListToJson(const QVariant &input);
};

