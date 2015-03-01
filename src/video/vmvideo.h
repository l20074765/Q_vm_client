#ifndef VMVIDEO_H
#define VMVIDEO_H
#include <QGraphicsProxyWidget>
#include <Phonon>

class VMVideo : public QGraphicsProxyWidget
{
    Q_OBJECT
public:
    explicit VMVideo(QGraphicsItem *parent = 0);
    ~VMVideo();


signals:
    void    video_finished();
public slots:
    void replay();
    void play(QString videoFile);
    bool isFlinish();
    void pause();
    void stop();
private:
    Phonon::VideoPlayer *m_videoPlayer;
};



#endif // VMVIDEO_H
