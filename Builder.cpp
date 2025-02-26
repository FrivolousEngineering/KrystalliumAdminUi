#include "Builder.h"

#include <random>

#include "Effects.h"

using namespace Qt::StringLiterals;

static const auto effectAttributes = QVariantMap{
    {u"name"_s, u"string"_s},
    {u"action"_s, u"action"_s},
    {u"target"_s, u"target"_s},
    {u"strength"_s, u"int"_s},
};

#define SAMPLE_ATTRIBUTES \
    {u"rfid_id"_s, u"string"_s}, \
    {u"strength"_s, u"int"_s}

static const auto rawSampleAttributes = QVariantMap{
    SAMPLE_ATTRIBUTES,
    {u"positive_action"_s, u"action"_s},
    {u"positive_target"_s, u"target"_s},
    {u"negative_action"_s, u"action"_s},
    {u"negative_target"_s, u"target"_s},
    {u"depleted"_s, u"bool"_s},
};

static const auto refinedSampleAttributes = QVariantMap{
    SAMPLE_ATTRIBUTES,
    {u"primary_action"_s, u"action"_s},
    {u"primary_target"_s, u"target"_s},
    {u"secondary_action"_s, u"action"_s},
    {u"secondary_target"_s, u"target"_s}
};

static const auto bloodSampleAttributes = QVariantMap{
    SAMPLE_ATTRIBUTES
};

static const auto enlistedAttributes = QVariantMap{
    {u"name"_s, u"string"_s},
    {u"number"_s, u"string"_s},
};

static const auto origins = QStringList{
    u"Hroth Gaderas"_s,
    u"Dalvios"_s,
    u"Vysochiya"_s,
    u"Grossmark"_s,
    u"Avros"_s,
    u"Satrios"_s,
    u"Alaverde"_s,
    u"Leofrie"_s,
    u"Kargastan"_s,
};

static std::mt19937_64 s_randomEngine{std::random_device{}()};

Effects::Action randomAction()
{
    std::uniform_int_distribution<int> dist(1, int(Effects::ActionCount) - 1);
    auto action = dist(s_randomEngine);
    return Effects::Action(action);
}

Effects::Target randomTarget()
{
    std::uniform_int_distribution<int> dist(1, int(Effects::TargetCount) - 1);
    auto target = dist(s_randomEngine);
    return Effects::Target(target);
}

int randomStrength(int min, int max)
{
    std::uniform_int_distribution<int> dist(min, max);
    return dist(s_randomEngine);
}

QString randomOrigin()
{
    std::uniform_int_distribution<int> dist(0, origins.size() - 1);
    return origins.at(dist(s_randomEngine));
}

QString randomUuid()
{
    return QUuid::createUuid().toString();
}

Builder::Builder(QObject *parent)
    : QObject(parent)
{

}

Zax::JsonApi::Document Builder::emptyRawSample()
{
    auto document = Zax::JsonApi::Document{};
    document.setAttributes(rawSampleAttributes);
    return document;
}

Zax::JsonApi::Document Builder::emptyRefinedSample()
{
    auto document = Zax::JsonApi::Document{};
    document.setAttributes(refinedSampleAttributes);
    return document;
}

Zax::JsonApi::Document Builder::emptyBloodSample()
{
    auto document = Zax::JsonApi::Document{};
    document.setAttributes(bloodSampleAttributes);
    return document;
}

Zax::JsonApi::Document Builder::randomRawSample()
{
    auto document = Zax::JsonApi::Document{};
    document.setType(u"raw"_s);
    document.setAttributes(rawSampleAttributes);
    QVariantMap values;
    values[u"rfid_id"_s] = randomUuid();
    values[u"positive_action"_s] = randomAction();
    values[u"positive_target"_s] = randomTarget();
    values[u"negative_action"_s] = randomAction();
    values[u"negative_target"_s] = randomTarget();
    values[u"strength"_s] = randomStrength(1, 6);
    values[u"depleted"_s] = false;
    document.setAttributeValues(values);
    return document;
}

Zax::JsonApi::Document Builder::randomRefinedSample()
{
    auto document = Zax::JsonApi::Document{};
    document.setType(u"refined"_s);
    document.setAttributes(refinedSampleAttributes);
    QVariantMap values;
    values[u"rfid_id"_s] = randomUuid();
    values[u"primary_action"_s] = randomAction();
    values[u"primary_target"_s] = randomTarget();
    values[u"secondary_action"_s] = randomAction();
    values[u"secondary_target"_s] = randomTarget();
    values[u"strength"_s] = randomStrength(1, 6);
    document.setAttributeValues(values);
    return document;
}

Zax::JsonApi::Document Builder::randomBloodSample()
{
    auto document = Zax::JsonApi::Document{};
    document.setType(u"blood"_s);
    document.setAttributes(bloodSampleAttributes);
    QVariantMap values;
    values[u"rfid_id"_s] = randomUuid();
    values[u"origin"_s] = randomOrigin();
    values[u"action"_s] = randomAction();
    values[u"target"_s] = randomTarget();
    values[u"strength"_s] = randomStrength(1, 4);
    document.setAttributeValues(values);
    return document;
}
