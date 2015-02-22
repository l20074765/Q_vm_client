QT+=core gui sql network
QT+=declarative
CONFIG += release warn_on

TEMPLATE = app
VERSION = 1.1.1
TARGET = vmclient


UI_DIR =$$PWD/build/ui
MOC_DIR=$$PWD/build/moc
OBJECTS_DIR=$$PWD/build/obj
RCC_DIR=$$PWD/build/rcc
DESTDIR=$$PWD/build/bin

INCLUDEPATH +=$$PWD \
              $$PWD/src \
              $$PWD/src/vmc \
              $$PWD/src/sql \
              $$PWD/src/alipay \
            $$PWD/src/jsoncpp \


LIBS +=  -L$$PWD -L$$PWD/libs

DEFINES +=VM_DECLARATIVE

SOURCES += \
    src/main.cpp \
    src/mainwindow.cpp \
    src/custom.cpp \
    src/mainobject.cpp \
    src/vmc/vmcmainflow.cpp \
    src/sql/productobject.cpp \
    src/sql/vmsql.cpp \
    src/alipay/alipayapi.cpp \
    src/alipay/alipayconfig.cpp \
    src/jsoncpp/json_internalarray.inl \
    src/jsoncpp/json_internalmap.inl \
    src/jsoncpp/json_reader.cpp \
    src/jsoncpp/json_value.cpp \
    src/jsoncpp/json_valueiterator.inl \
    src/jsoncpp/json_writer.cpp

HEADERS += \
    src/mainwindow.h \
    src/vmc/EVprotocol.h \
    src/custom.h \
    src/mainobject.h \
    src/vmc/vmcmainflow.h \
    src/sql/productobject.h \
    src/sql/vmsql.h \
    src/alipay/alipayapi.h \
    src/alipay/alipayconfig.h \
    src/jsoncpp/autolink.h \
    src/jsoncpp/config.h \
    src/jsoncpp/features.h \
    src/jsoncpp/forwards.h \
    src/jsoncpp/json.h \
    src/jsoncpp/json_batchallocator.h \
    src/jsoncpp/reader.h \
    src/jsoncpp/value.h \
    src/jsoncpp/writer.h


QML_IMPORT_PATH += $$PWD/plugins


DISTFILES += \
    qml/main.qml \
    qml/VMAdsPage.qml \
    qml/VMWidget.qml \
    qml/VMStatusbar.qml \
    qml/VMTitlebar.qml \
    qml/Product.qml \
    qml/VMPayPage.qml \
    qml/VMTradeWidget.qml \
    qml/VMTransactionPage.qml \
    qml/VMGoodsListPage.qml \
    qml/VMTradeoutPage.qml \
    qml/VMTradeFailPage.qml


