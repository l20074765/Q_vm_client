#include "vmvideo.h"
#include <QtDebug>
#include <QFile>
#include <QDir>
VMVideo::VMVideo(QGraphicsItem *parent)
    : QGraphicsProxyWidget(parent)
{
    m_videoPlayer = new Phonon::VideoPlayer(Phonon::VideoCategory);
    Phonon::VideoWidget *videoW = m_videoPlayer->videoWidget();
    videoW->setScaleMode(Phonon::VideoWidget::ScaleAndCrop);
    m_videoPlayer->show();
    m_videoPlayer->raise();

    QPalette palette;
    palette.setColor(QPalette::Background,QColor(Qt::white));
    m_videoPlayer->setPalette(palette);
    this->setWidget(m_videoPlayer);

    connect(m_videoPlayer,SIGNAL(finished()),
            this,SIGNAL(video_finished()));

}

VMVideo::~VMVideo()
{

}



void VMVideo::pause()
{
    if(m_videoPlayer->isPlaying())
        m_videoPlayer->pause();
}

void VMVideo::stop()
{
    if(m_videoPlayer->isPlaying())
        m_videoPlayer->stop();
}

bool VMVideo::isFlinish()
{
    if(m_videoPlayer->isPlaying())
    {
        return false;
    }
    else
    {
        return true;
    }

}

void VMVideo::play(QString videoFile)
{
    Phonon::MediaObject *videoObj = m_videoPlayer->mediaObject();
    videoObj->stop();
    videoObj->clear();
    m_videoPlayer->play(Phonon::MediaSource(videoFile));
}

void VMVideo::replay()
{
    m_videoPlayer->play();
}
