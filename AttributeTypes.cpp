#include "AttributeTypes.h"

#include <QJsonArray>

#include <Zax/JsonApi/Document.h>

#include "Builder.h"
#include "Effects.h"

using namespace Qt::StringLiterals;

void AttributeTypes::registerTypes()
{
    Zax::JsonApi::Document::registerAttributeType(u"action", AttributeTypes::actionFromJson, AttributeTypes::actionToJson);
    Zax::JsonApi::Document::registerAttributeType(u"target", AttributeTypes::targetFromJson, AttributeTypes::targetToJson);
    Zax::JsonApi::Document::registerAttributeType(u"effect", AttributeTypes::effectFromJson, AttributeTypes::effectToJson);
    Zax::JsonApi::Document::registerAttributeType(u"effectlist", AttributeTypes::effectListFromJson, AttributeTypes::effectListToJson);
}

QVariant AttributeTypes::actionFromJson(const QJsonValue& input)
{
    if (input.isString()) {
        return Effects::actionFromString(input.toString());
    }
    if (input.isDouble()) {
        return Effects::Action(input.toInt());
    }
    return QVariant{};
}

QJsonValue AttributeTypes::actionToJson(const QVariant& input)
{
    if (input.typeId() == QMetaType::QString) {
        return input.toString().toLower();
    }
    if (input.typeId() == QMetaType::Int) {
        return Effects::actionToString(Effects::Action(input.toInt())).toLower();
    }
    return QJsonValue{};
}

QVariant AttributeTypes::targetFromJson(const QJsonValue& input)
{
    if (input.isString()) {
        return Effects::targetFromString(input.toString());
    }
    if (input.isDouble()) {
        return Effects::Target(input.toInt());
    }
    return QVariant{};
}

QJsonValue AttributeTypes::targetToJson(const QVariant& input)
{
    if (input.typeId() == QMetaType::QString) {
        return input.toString().toLower();
    }
    if (input.typeId() == QMetaType::Int) {
        return Effects::targetToString(Effects::Target(input.toInt())).toLower();
    }
    return QJsonValue{};
}

QVariant AttributeTypes::effectFromJson(const QJsonValue& input)
{
    if (!input.isObject()) {
        return QVariant{};
    }

    auto document = Builder::emptyEffect();
    return QVariant::fromValue(Zax::JsonApi::Document::fromJsonObject(input.toObject(), document));
}

QJsonValue AttributeTypes::effectToJson(const QVariant& input)
{
    if (input.canConvert<Zax::JsonApi::Document>()) {
        return input.value<Zax::JsonApi::Document>().id();
    }
    return QJsonValue{};
}

QVariant AttributeTypes::effectListFromJson(const QJsonValue& input)
{
    if (!input.isArray()) {
        return QVariant{};
    }

    QVariantList result;
    for (auto entry : input.toArray()) {
        result.append(effectFromJson(entry));
    }
    return result;
}

QJsonValue AttributeTypes::effectListToJson(const QVariant& input)
{
    Q_UNUSED(input);
    // TODO
    return QJsonValue{};
}
