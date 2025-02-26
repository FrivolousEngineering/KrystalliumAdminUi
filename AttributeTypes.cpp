#include "AttributeTypes.h"

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
        qDebug() << entry;
        result.append(effectFromJson(entry));
    }
    qDebug() << result;
    return result;
}

QJsonValue AttributeTypes::effectListToJson(const QVariant& input)
{
    return QJsonValue{};
}


// QVariant AttributeTypes::actionType(const QVariant& input)
// {
//     qDebug() << input;
//     if (input.metaType().id() == QMetaType::QString) {
//         auto action = Effects::actionFromString(input.toString());
//         return QVariant::fromValue(action);
//     } else if (input.metaType().id() == QMetaType::Int) {
//         auto action = Effects::actionToString(Effects::Action(input.toInt()));
//         return QVariant::fromValue(action);
//     } else {
//         return QVariant{};
//     }
// }
//
// QVariant AttributeTypes::targetType(const QVariant& input)
// {
//     if (input.metaType().id() == QMetaType::QString) {
//         auto target = Effects::targetFromString(input.toString());
//         return QVariant::fromValue(target);
//     } else if (input.metaType().id() == QMetaType::Int) {
//         auto target = Effects::targetToString(Effects::Target(input.toInt()));
//         return QVariant::fromValue(target);
//     } else {
//         return QVariant{};
//     }
// }

// QVariant AttributeTypes::effectType(const QVariant& input)
// {
//     auto data = input.value<QVariantMap>();
//     if (data.isEmpty()) {
//         return QVariant{};
//     }
//
//     auto document = Builder::emptyEffect();
//     document.setId(data.value(u"id"_s).toString());
//     document.setAttributeValues(data);
//
//     return QVariant::fromValue(document);
// }
//
// QVariant AttributeTypes::effectListType(const QVariant& input)
// {
//     auto data = input.value<QVariantList>();
//     if (data.isEmpty()) {
//         return QVariant{};
//     }
//
//     QVariantList result;
//     for (auto entry : data) {
//         result.append(effectType(entry));
//     }
//
//     return result;
// }
