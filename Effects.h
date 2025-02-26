#pragma once

#include <QObject>
#include <qqmlregistration.h>

class Effects : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    enum Action {
        InvalidAction,
        Increasing,
        Decreasing,
        Creating,
        Destroying,
        Expanding,
        Contracting,
        Fortifying,
        Deteriorating,
        Lightening,
        Encumbering,
        Cooling,
        Heating,
        Conducting,
        Insulating,
        Absorbing,
        Releasing,
        Solidifying,
        ActionCount,
    };
    Q_ENUM(Action)

    enum Target {
        InvalidTarget,
        Energy,
        Flesh,
        Sound,
        Gas,
        Krystal,
        Light,
        Liquid,
        Mind,
        Plant,
        Solid,
        TargetCount,
    };
    Q_ENUM(Target)

    Q_PROPERTY(QVariantList actions READ actions CONSTANT)
    QVariantList actions() const;

    Q_PROPERTY(QVariantList targets READ targets CONSTANT)
    QVariantList targets() const;

    Q_INVOKABLE static QString actionToString(Action action);
    Q_INVOKABLE static Action actionFromString(const QString &name);
    Q_INVOKABLE static QString actionDisplayString(Action action);
    Q_INVOKABLE static QString targetToString(Target target);
    Q_INVOKABLE static Target targetFromString(const QString &name);
    Q_INVOKABLE static QString targetDisplayString(Target target);
};
