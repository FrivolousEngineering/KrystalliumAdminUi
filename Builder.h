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

    Q_INVOKABLE Zax::JsonApi::Document emptyRawSample();
    Q_INVOKABLE Zax::JsonApi::Document emptyRefinedSample();
    Q_INVOKABLE Zax::JsonApi::Document emptyBloodSample();

    Q_INVOKABLE Zax::JsonApi::Document randomRawSample();
    Q_INVOKABLE Zax::JsonApi::Document randomRefinedSample();
    Q_INVOKABLE Zax::JsonApi::Document randomBloodSample();
};
