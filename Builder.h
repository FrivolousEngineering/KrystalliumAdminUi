#pragma once

#include <QObject>
#include <qqmlregistration.h>

#include <Zax/JsonApi/Document.h>

class Builder : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    Builder(QObject *parent = nullptr);

    Q_INVOKABLE static Zax::JsonApi::Document emptyEffect();
    Q_INVOKABLE static Zax::JsonApi::Document emptyRawSample();
    Q_INVOKABLE static Zax::JsonApi::Document emptyRefinedSample();
    Q_INVOKABLE static Zax::JsonApi::Document emptyBloodSample();
    Q_INVOKABLE static Zax::JsonApi::Document emptyEnlisted();

    Q_INVOKABLE Zax::JsonApi::Document randomRawSample();
    Q_INVOKABLE Zax::JsonApi::Document randomRefinedSample();
    Q_INVOKABLE Zax::JsonApi::Document randomBloodSample();
};
