#include "Effects.h"

#include <QMetaEnum>
#include <QString>

using namespace Qt::StringLiterals;

template <typename T>
QString enumToString(T value)
{
    auto metaEnum = QMetaEnum::fromType<T>();
    return QString::fromUtf8(metaEnum.key(int(value)));
}

template <typename T>
T enumFromString(QStringView string)
{
    auto metaEnum = QMetaEnum::fromType<T>();
    auto key = string.toUtf8();
    for (int i = 0; i < metaEnum.keyCount(); ++i) {
        if (qstricmp(metaEnum.key(i), key.data()) == 0) {
            return T(i);
        }
    }

    return T(0);
}

QVariantList Effects::actions() const
{
    auto metaEnum = QMetaEnum::fromType<Action>();
    QVariantList result;
    result.append(QVariantMap{
        {u"text"_s, u"Invalid"_s},
        {u"value"_s, 0},
    });
    for (int i = 1; i < ActionCount; ++i) {
        result.append(QVariantMap{
            {u"text"_s, QString::fromUtf8(metaEnum.key(i))},
            {u"value"_s, i},
        });
    }
    return result;
}

QVariantList Effects::targets() const
{
    auto metaEnum = QMetaEnum::fromType<Target>();
    QVariantList result;
    result.append(QVariantMap{
        {u"text"_s, u"Invalid"_s},
        {u"value"_s, 0},
    });
    for (int i = 1; i < TargetCount; ++i) {
        result.append(QVariantMap{
            {u"text"_s, QString::fromUtf8(metaEnum.key(i))},
            {u"value"_s, i},
        });
    }
    return result;
}

QString Effects::actionToString(Action action)
{
    return enumToString(action).toLower();
}

Effects::Action Effects::actionFromString(const QString& name)
{
    return enumFromString<Action>(name);
}

QString Effects::actionDisplayString(Action action)
{
    return enumToString(action);
}

QString Effects::targetToString(Target target)
{
    return enumToString(target).toLower();
}

Effects::Target Effects::targetFromString(const QString& name)
{
    return enumFromString<Target>(name);
}

QString Effects::targetDisplayString(Target target)
{
    return enumToString(target);
}
