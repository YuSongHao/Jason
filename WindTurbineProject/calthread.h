#ifndef CALTHREAD_H
#define CALTHREAD_H

#include <QtCore>
#include <stdio.h>
#include <iostream>
#include <QDebug>
#include <QFile>
#include <QFileDialog>
#include <QMessageBox>
#include <QVector>
#include <QMutex>
#include <math.h>
#include <malloc.h>
#include <gsl/gsl_errno.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_fft_complex.h>
#include <QDateTime>
#include <fftw3.h>

typedef QVector<short> MyFrameType;


class CalThread : public QThread
{
    Q_OBJECT
public:
    CalThread();
//    static bool startCalFlag;
    void run();  // override run
    bool findPeaksIndex(double* data,int length,int minDistance,QVector<int> &result);
    double* filter(double* b, double* a, int b_a_length, double* x, int x_length);
    int findMaxIndex(double *data, int length);
    double findMaxValue(double *data,int length);
    int findMaxIndex(QVector<double> data);
    double *smooth(double *data,int length,int span);
    double mean(double *data,int start,int end);
    double mean(double *data,int length);
    double mean(QVector<double> &data);
    double *abs(double *data,int length);
    double *hamming(int windowLength);
    void bandPass(double *data,int length);
    double *envelopeMax(double *data,int length,int span);
    double sum(double* data,int length);
    double var(double* data,int length);
    //double *Matrix_division(double* a,double* b,int length);
    double *xcorr(double* a,int length_a);
    double *xcorr(double* a,double* b,int length_a,int length_b,int maxlag);
    bool diff(QVector<int> &a, int pieceLength, QVector<double> &diff);
    bool ismember(QVector<int> &a,int b);
    int NFFT(int length);
    bool FFT(double* data,int length,fftw_complex* out);
    double *psd(double* data,int length);
    void pwelch(double* data,int length,double* energy);
    double freqCenter(double* data,int length);
    double ExtractCycle(double* data,int length,int type);
	double corrcoef(double* databefore, double* dataafter);

public slots:
    void cal(short* frameData);  // get data and calculate

signals:
    void sendFrameData(double* data);
    void sendFeaData(double* data);
    void sendFaulty();
    void findFaulty();
    void sendSave(double* data);
    void saveInput(double* data,int length);
    void circlePlus();
    void faultPlus();
    void getFea(double* fea);

private:

    int SampleRate;
    int frameLength;
    int frameCount;
    int pieceLength;
    int smoothLength;
    int peakMinPiece;
    int peakMaxPiece;
    int peakOffsetPiece;
    int peakInnerOffsetPiece;
    int peakOffsetPoint;
    int peakMaxPoint;
    int peakMinPoint;
    int bufferCount;
    bool checkCycle;
    double varThreshold;
    double energyThreshold;
    double InnerEnergyRationThreshold;
    double ampThresh;
	double corrcoefThreshold;
    int nextStart;
    double *handleData;
    double *lastFrameData;
    double *reciveFrameData;
    double *currentFrameData;
    double *freqCenterFea;
    double *original;
    double *peakEnergy;
    double *peakBeforeEnergy;
    double *psdValue;
    QMutex mut;
};

#endif // CALTHREAD_H
