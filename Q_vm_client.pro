QT+=core gui sql network
QT+=declarative
QT += phonon
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
            $$PWD/src/video \
            $$PWD/src/qrencode \
            $$PWD/src/log


LIBS +=  -L$$PWD -L$$PWD/libs

DEFINES +=VM_DECLARATIVE

win32{
    LIBS+= $$PWD/libs/EVprotocol.dll

}



QML_IMPORT_PATH += $$PWD/plugins  \



SOURCES += \
    src/main.cpp \
    src/custom.cpp \
    src/vmc/vmcmainflow.cpp \
    src/alipay/alipayapi.cpp \
    src/alipay/alipayconfig.cpp \
    src/jsoncpp/json_internalarray.inl \
    src/jsoncpp/json_internalmap.inl \
    src/jsoncpp/json_reader.cpp \
    src/jsoncpp/json_value.cpp \
    src/jsoncpp/json_valueiterator.inl \
    src/jsoncpp/json_writer.cpp \
    src/video/vmvideo.cpp \
    src/alipay/alixmlobj.cpp \
    src/alipay/qrenwidget.cpp \
    src/alipay/qrenpixwidget.cpp \
    src/setting.cpp \
    src/vmc/vmcobj.cpp \
    src/sql/vmsqlite.cpp \
    src/sql/sqlproduct.cpp \
    src/sql/sqlproductlist.cpp \
    src/mainflow.cpp \
    src/sql/sqlcolumn.cpp \
    src/sql/sqlcolumnlist.cpp \
    src/sql/order.cpp \
    src/sql/orderlist.cpp \
    src/mainview.cpp \
    src/sql/sqlcabinet.cpp \
    src/sql/sqlcabinetlist.cpp

HEADERS += \
    src/vmc/EVprotocol.h \
    src/custom.h \
    src/vmc/vmcmainflow.h \
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
    src/jsoncpp/writer.h \
    src/video/vmvideo.h \
    src/alipay/alixmlobj.h \
    src/alipay/qrenwidget.h \
    src/alipay/qrenpixwidget.h \
    src/setting.h \
    src/vmc/vmcobj.h \
    src/sql/vmsqlite.h \
    src/sql/sqlproduct.h \
    src/sql/sqlproductlist.h \
    src/mainflow.h \
    src/sql/sqlcolumn.h \
    src/sql/sqlcolumnlist.h \
    src/sql/order.h \
    src/sql/orderlist.h \
    src/mainview.h \
    src/sql/sqlcabinet.h \
    src/sql/sqlcabinetlist.h


DISTFILES += \
    qml/main.qml \
    qml/ads/VMAdsPage.qml \
    qml/custom/Product.qml \
    qml/custom/VMStatusbar.qml \
    qml/custom/VMTitlebar.qml \
    qml/custom/VMWidget.qml \
    qml/trade/VMFaultPage.qml \
    qml/trade/VMGoodsListPage.qml \
    qml/trade/VMPayPage.qml \
    qml/trade/VMTradeFailPage.qml \
    qml/trade/VMTradeoutPage.qml \
    qml/trade/VMTradeWidget.qml \
    qml/trade/VMTransactionPage.qml \
    qml/maintain/MTButton.qml \
    qml/maintain/MTMain.qml \
    qml/maintain/MTMainTainPage.qml \
    qml/maintain/MTProductPage.qml \
    qml/maintain/MTColumnPage.qml \
    qml/maintain/MTTradeManage.qml \
    qml/maintain/MTSystemManage.qml \
    qml/maintain/MTTradeManagePage.qml \
    qml/maintain/MTDeviceManagePage.qml \
    qml/maintain/MTSystemManagePage.qml \
    qml/maintain/MTProductDetailPage.qml \
    qml/maintain/MTColumn/Column.js \
    qml/maintain/MTColumn/MyButton.qml \
    qml/maintain/MTColumn/VMCabinet.qml \
    qml/maintain/MTColumn/VMColumn.qml \
    qml/maintain/MTColumn/VMColumnEdit.qml \
    qml/maintain/MTColumn/VMColumnText.qml \
    qml/maintain/MTColumn/VMCoumnTextInput.qml \
    qml/maintain/MainTain.js \
    qml/custom/ProductList.qml \
    qml/custom/MyTextInput.qml \
    qml/maintain/MTProductPicList.qml \
    qml/custom/LoadingMask.qml




include("./src/qrencode/qrencode.pri")

RESOURCES += \
    vm.qrc

