#ifndef CUSTOM_H
#define CUSTOM_H

#include <QObject>
#include <QString>
class Custom : public QObject
{
    Q_OBJECT
public:
    explicit Custom(QObject *parent = 0);
    ~Custom();

    static QString  tr_c(const char *text);
signals:

public slots:
};

#endif // CUSTOM_H
