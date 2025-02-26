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

inline Zax::JsonApi::Document emptyDocument(const QString &type, const QVariantMap &attributes)
{
    auto document = Zax::JsonApi::Document{};
    document.setType(type);
    document.setAttributes(attributes);
    return document;
}

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

QString randomUuid()
{
    return QUuid::createUuid().toString();
}

Builder::Builder(QObject *parent)
    : QObject(parent)
{

}

Zax::JsonApi::Document Builder::emptyEffect()
{
    return emptyDocument(u"effect"_s, effectAttributes);
}

Zax::JsonApi::Document Builder::emptyRawSample()
{
    return emptyDocument(u"raw"_s, rawSampleAttributes);
}

Zax::JsonApi::Document Builder::emptyRefinedSample()
{
    return emptyDocument(u"refined"_s, refinedSampleAttributes);
}

Zax::JsonApi::Document Builder::emptyBloodSample()
{
    auto document = emptyDocument(u"blood"_s, bloodSampleAttributes);
    document.setRelationships(QVariantMap{
        {u"effect"_s, u"effect"_s},
    });
    return document;
}

Zax::JsonApi::Document Builder::emptyEnlisted()
{
    auto document = emptyDocument(u"enlisted"_s, enlistedAttributes);
    document.setRelationships(QVariantMap{
        {u"effects"_s, u"effect"_s},
    });
    return document;
}

Zax::JsonApi::Document Builder::randomEffect()
{
    auto document = emptyEffect();
    QVariantMap values;
    values[u"action"_s] = randomAction();
    values[u"target"_s] = randomTarget();
    values[u"strength"_s] = randomStrength(1, 6);
    document.setAttributeValues(values);
    return document;
}

Zax::JsonApi::Document Builder::randomRawSample()
{
    auto document = emptyRawSample();
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
    auto document = emptyRefinedSample();
    QVariantMap values;
    values[u"rfid_id"_s] = randomUuid();
    values[u"primary_action"_s] = randomAction();
    values[u"primary_target"_s] = randomTarget();
    values[u"secondary_action"_s] = randomAction();
    values[u"secondary_target"_s] = randomTarget();
    values[u"strength"_s] = randomStrength(2, 12);
    document.setAttributeValues(values);
    return document;
}
