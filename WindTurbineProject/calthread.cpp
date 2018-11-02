#define _USE_MATH_DEFINES
#include "calthread.h"
#include <fftw3.h>
#include "mainwindow.h"

#define REAL(z,i) ((z)[2*(i)])
#define IMAG(z,i) ((z)[2*(i)+1])


CalThread::CalThread()
{
    SampleRate = 44100;
    frameLength = 262144;
    frameCount = 0;
    bufferCount = 0;
    pieceLength = 512;
    smoothLength = 51;
    peakMinPiece = 103;
    peakMaxPiece = 173;
    peakOffsetPiece = 32;
    peakInnerOffsetPiece = 10;
    peakOffsetPoint = peakOffsetPiece * pieceLength;
    peakMaxPoint = peakMaxPiece * pieceLength;
    peakMinPoint = peakMinPiece * pieceLength;
    checkCycle = false;
    energyThreshold = 1.1;
    InnerEnergyRationThreshold = 0.44;
    ampThresh = 100;
    varThreshold = 1000;
    nextStart = 0;
    handleData = new double[262144 * 2];
    lastFrameData = new double[262144]();
    currentFrameData = new double[262144];
    reciveFrameData = new double[262144];
    freqCenterFea = new double[2];
    original = new double[262144 * 2];
    peakEnergy = new double[4097]();
    peakBeforeEnergy = new double[4097]();
    psdValue = new double[4097]();
	corrcoefThreshold = 0.9;
    //emit saveInput(currentFrameData);
    //qDebug()<<"send signal";
}

void CalThread::run()
{
    //this->exec();
    while(true)
    {
        mut.lock();
        if(startCalFlag)
        {
        qDebug()<<"begin calculate";
        memcpy(currentFrameData,double_temp,sizeof(double) * frameLength);
//        emit saveInput(currentFrameData,frameLength);

        memcpy(handleData,lastFrameData,frameLength * sizeof(double));
        memcpy(handleData + frameLength,currentFrameData,frameLength * sizeof(double));
        memcpy(lastFrameData,currentFrameData,frameLength * sizeof(double));
        //double *original = new double[frameLength * 2];
        memcpy(original,handleData,2 * frameLength * sizeof(double));
        if(checkCycle)
        {
            double cyc = ExtractCycle(handleData,frameLength * 2,2);
            qDebug()<<"new cycle is"<<cyc<<endl;
            if(cyc != 0)
            {
                peakMinPoint = (cyc/3 - 0.4) * SampleRate;
                peakMaxPoint = (cyc/3 + 0.4) * SampleRate;
                peakMinPiece = peakMinPoint / pieceLength;
                peakMaxPiece = peakMaxPoint / pieceLength;
            }
            checkCycle = false;
        }
        //bandpass filter
        bandPass(handleData,2 * frameLength);//1-3k 不合適 需要做高通濾波
        double *abs_data = abs(handleData,2 * frameLength);
        double handleDataMean = mean(abs_data,2 * frameLength);// 確定野點相對幅度 目前50
        if(handleDataMean>0)
        {
        //envelope
        double* pieceData = envelopeMax(handleData,2 * frameLength,pieceLength);
        //smooth
        int pieceDataLength = 2 * frameLength / pieceLength;
        double* pieceDataSmooth = smooth(pieceData,pieceDataLength,smoothLength);//1024

        //find peak
        QVector<int> peakIndex;
        findPeaksIndex(pieceDataSmooth,pieceDataLength,peakMinPiece,peakIndex);
        //qDebug()<<peakIndex.size();
        QVector<int> peakStartPoint;
        QVector<int> peakStartPiece;
        double *peakDataPiece = new double[peakOffsetPiece * 2];
        //energy ratio
        double *peakData = new double[peakOffsetPoint * 2];
        double *peakBeforeData = new double[peakOffsetPoint * 2];
        double *saveData = new double[peakOffsetPoint * 2 + 4097];
        //qDebug()<<"peakIndex size :"<<peakIndex.size();
		//对每个脉冲位置进行判断
        for(int idxPeak = 0; idxPeak < peakIndex.size();idxPeak++)
        {
            int startPoint = (peakIndex[idxPeak] - peakOffsetPiece) * pieceLength - 1;
            int endPoint = (peakIndex[idxPeak] + peakOffsetPiece) * pieceLength - 1;
            int startPiece = peakIndex[idxPeak] - peakOffsetPiece - 1;
            //check out of range
            if(startPoint >= qMax(2 * peakOffsetPoint,nextStart) && endPoint < 2 * frameLength -1)
            {
                memcpy(peakBeforeData,handleData + startPoint - 2 * peakOffsetPoint,peakOffsetPoint * 2 * sizeof(double));
                //double *peakBeforeData = handleData + startPoint - 2 * peakOffsetPoint;
                memset(peakBeforeEnergy,0,4097 * sizeof(double));
                pwelch(peakBeforeData,peakOffsetPoint * 2,peakBeforeEnergy);
                //double BeforeMaxValue = findMaxValue(handleData + startPoint - 2 * peakOffsetPoint,peakOffsetPoint * 2);
                int energyLength = NFFT((int)floor(2 * peakOffsetPoint / 4.5))/2+1;//??????

                //current peak
                memcpy(peakData,handleData + startPoint,peakOffsetPoint * 2 * sizeof(double));
                //double *peakData = handleData + startPoint;
                memset(peakEnergy,0,4097 * sizeof(double));
                pwelch(peakData,peakOffsetPoint * 2,peakEnergy);
                //double PeakMaxValue = findMaxValue(handleData + startPoint,peakOffsetPoint * 2);

                //calculate energy ratio and peak value
                double *abs_peakData = abs(handleData + startPoint,peakOffsetPoint * 2);
                double peakDataMax = findMaxValue(abs_peakData,peakOffsetPoint * 2);
                double ratio = sum(peakEnergy,energyLength) / sum(peakBeforeEnergy,energyLength);
                //qDebug()<<"BeforeMaxValue :"<<BeforeMaxValue<<";"<<"PeakMaxValue :"<<PeakMaxValue<<endl;
                //inner energy
                double *innerData = new double[peakInnerOffsetPiece * 2 * pieceLength];
                int innerLength = NFFT((int)floor(peakInnerOffsetPiece*2*pieceLength/4.5))/2+1;
                double *innerDataEnergy = new double[innerLength];
                memcpy(innerData,handleData + startPoint+(peakOffsetPiece-peakInnerOffsetPiece)*pieceLength,peakInnerOffsetPiece*2*pieceLength*sizeof(double));
                pwelch(innerData,peakInnerOffsetPiece * 2 * pieceLength,innerDataEnergy);
                double innerRatio = sum(innerDataEnergy,innerLength)/sum(peakEnergy,energyLength);

                qDebug()<<"peakEnergy :"<<sum(peakEnergy,energyLength)
                        <<"peakBeforeEnergy :"<<sum(peakBeforeEnergy,energyLength)
                        <<"ratio :"<<ratio;
                        //<<"innerRatio :"<<innerRatio;
                if(isnan(sum(peakEnergy,energyLength)) || isnan(sum(peakBeforeEnergy,energyLength)))
                //if(true)
                {
                    memcpy(saveData,peakBeforeData,peakOffsetPoint * 2 *sizeof(double));
                    memcpy(saveData + peakOffsetPoint * 2,peakBeforeEnergy,energyLength * sizeof(double));
//                    emit saveInput(saveData,peakOffsetPoint * 2 + energyLength);
                    qDebug()<<"Peakbefore begin point :"<<startPoint - peakOffsetPoint * 2;
                    qDebug()<<"Peakbefore end point :"<<startPoint;
                    qDebug()<<"Peak end point: "<<startPoint + peakOffsetPoint * 2;
                }
				
				//加入内层相关系数判断
								
                if(ratio>energyThreshold && peakDataMax < ampThresh * handleDataMean && innerRatio >= InnerEnergyRationThreshold)
                {	
					
					double* peakSmoothBefore = new double[peakOffsetPiece + 1];
					double* reverseDataBefore = new double[peakOffsetPiece + 1]();
					double* peakSmoothAfter = new double[peakOffsetPiece + 1];
					int peakSmoothStartPoint = peakIndex[idxPeak] - peakOffsetPiece;
					int peakSmoothEndPoint = peakIndex[idxPeak] + peakOffsetPiece;
					memcpy(peakSmoothBefore,pieceDataSmooth + peakSmoothStartPoint,peakOffsetPiece + 1);
					memcpy(peakSmoothAfter,pieceDataSmooth + peakSmoothEndPoint - peakOffsetPiece,peakOffsetPiece+1);
					//前向数组倒序
					for(int smoothIdx = 0;smoothIdx < peakSmoothBefore.length;smoothIdx++)
					{
						reverseDataBefore[peakSmoothBefore.length-smoothIdx] = peakSmoothBefore[smoothIdx];
					}
					double corrcoefValue = corrcoef(reverseDataBefore,peakSmoothAfter);					
					if(corrcoefValue >= corrcoefThreshold)
					{	peakStartPoint.append(startPoint);
						peakStartPiece.append(startPiece);
					}
					delete[] peakSmoothBefore;
					delete[] peakSmoothAfter;				
					delete[] reverseDataBefore;
					
                }
//                delete[] peakBeforeEnergy;
//                delete[] peakEnergy;
                delete[] innerData;
                delete[] innerDataEnergy;
                delete[] abs_peakData;
            }
        }
        //print peakpoint of each peak
        for(int idxPeak = 0; idxPeak < peakStartPoint.size();idxPeak++)
        {
            int peakPoint = peakStartPoint[idxPeak];
            qDebug()<<"peak index :"<<peakPoint;
        }

        nextStart = 0;
        if(peakStartPoint.size() >= 3)
        {
            for(int idxPeak = 1; idxPeak < peakStartPoint.size()-1; idxPeak++)
            {
                int lastPeakDiff = peakStartPoint[idxPeak] - peakStartPoint[idxPeak - 1];
                int nextPeakDiff = peakStartPoint[idxPeak + 1] - peakStartPoint[idxPeak];
                 //find three circles
                if(lastPeakDiff < peakMaxPoint && nextPeakDiff < peakMaxPoint)
                {

                    //caculate freqCenter
                    emit circlePlus();
                    double *freqCenterData = new double[3];
                    for(int j=0; j<3 ; j++)
                    {
                        //memcpy(peakData,handleData+peakStartPoint[idxPeak - 1 + j],peakOffsetPoint * 2 * sizeof(double));
                        //double *peakData = handleData+peakStartPoint[idxPeak - 1 + j];
                        freqCenterData[j] = freqCenter(handleData+peakStartPoint[idxPeak - 1 + j],peakOffsetPoint * 2) * SampleRate / (2*M_PI);
                    }
                    //caculate variance
                    freqCenterFea[0] = var(freqCenterData,3);
                    freqCenterFea[1] = findMaxValue(freqCenterData,3);
                    qDebug()<<"Var :"<<freqCenterFea[0];
                    qDebug()<<"Max FreqCenter :"<<freqCenterFea[1];
                    emit getFea(freqCenterFea);
//                    double *featureData = new double[4]();
//                    featureData[0] = freqCenterVar;
//                    memcpy(featureData+1,freqCenterData,3 * sizeof(double));
                    if(freqCenterFea[0]<=varThreshold)
                    {
                        qDebug()<<"normal cycle";
                    }
                    else
                    {
                        qDebug()<<"faulty cycle";
                        emit faultPlus();
                        //startSaveFlag = 1;
                    }
                    nextStart = peakStartPoint[idxPeak + 1] - frameLength;
                    nextStart = qMax(nextStart,0);

                    idxPeak += 2;
                    delete[] freqCenterData;
                    //delete[] featureData;
                }
                else
                    checkCycle = true;// 若一幀信號中包含3個以上峯值且未滿足週期特性，則重新計算週期
            }
        }
        frameCount++;
        delete[] pieceData;
        delete[] pieceDataSmooth;
        delete[] peakDataPiece;
        delete[] peakData;
        delete[] peakBeforeData;
        delete[] saveData;
        }
        delete[] abs_data;
        startCalFlag = false;
        }
        mut.unlock();
    }
}

void CalThread::cal(short *frameData)
{
    short short_temp[8192];
    double double_temp[8192];
    memcpy(short_temp,frameData,sizeof(short) * 8192);
    for(int i = 0; i < 8192; i++)
        double_temp[i] = short_temp[i];
    memcpy(reciveFrameData + bufferCount * 8192,double_temp,sizeof(double) * 8192);
    //emit sendRealtimeData(double_temp);
    bufferCount++;
    //qDebug()<<"bufferCount :"<<bufferCount;
    if(bufferCount == 32)
    {
        memcpy(currentFrameData,reciveFrameData,sizeof(double) * frameLength);
        bufferCount = 0;
        startCalFlag = true;
    }
}

bool CalThread::findPeaksIndex(double* data,int length,int minDistance,QVector<int> &result)
{
    QVector<double> peakVector;
    QVector<int> peakLoc;

    for(int i = 1;i < length-1; i++)
    {
        if(data[i-1] < data[i] && data[i] >= data[i+1])
        {
            peakLoc.append(i);
            peakVector.append(data[i]);
        }
    }

    if(!peakLoc.isEmpty())
    {
        for(;;)
        {
            int idx = findMaxIndex(peakVector);
            result.append(peakLoc[idx]);
            for(int i = 0;i < peakLoc.size();i++)
            {
                int diff = fabs(peakLoc[i]-result.last());
                if(diff <= minDistance)
                {
                    peakLoc.remove(i);
                    peakVector.remove(i);
                    i--;
                }
            }
            if(peakLoc.isEmpty())
            {break;}
        }
    }
    qSort(result.begin(),result.end());
    return true;
}

double* CalThread::filter(double* b,double* a,int b_a_length,double* x,int x_length)
{//滤波器分子分母系数a、b需等长
    //normalize
    if(fabs(a[0]-1)>1e-8)
    {
        for(int i = 0;i < b_a_length;i++)
        {
            b[i] /= a[0];
            a[i] /= a[0];
        }
    }
    //filter
    double* y = new double[x_length];
    a[0] = 0.0;
    for(int i=0; i<x_length ; i++)
    {
        for(int j=0; i>=j && j<b_a_length;j++)
        {
            y[i] += (b[j]*x[i-j]-a[j]*y[i-j]);
        }
    }
    a[0] = 1.0;
    return y;
}

double* CalThread::smooth(double *data,int length,int span)
{//平滑长度需为奇数 （span - 1）% 2 == 0
    double *result = new double[length];

    for(int i=0; i<length; i++)
    {
        int offset = (span - 1)/2;
        if (i < offset)
            offset = i;
        if (length -1 -i <offset)
            offset = length -1 -i;
        result[i] = mean(data,i-offset,i+offset);
    }
    return result;
}

double CalThread::mean(double *data,int start,int end)
{
    double sum = 0.0;
    for(int i = start;i <= end;i++)
        sum += data[i];
    sum /= (end - start + 1);
    return sum;
}

double CalThread::mean(QVector<double> &data)
{
    double sum = 0.0;
    for(int i = 0;i < data.size();i++)
        sum += data[i];
    sum /= data.size();
    return sum;
}

int CalThread::findMaxIndex(double *data,int length)
{
    int result = 0;
    for(int i = 1;i < length;i++)
    {
        if(data[i] > data[result])
            result = i;
    }
    return result;
}

double CalThread::findMaxValue(double *data,int length)
{
    int maxIndex = findMaxIndex(data,length);
    return data[maxIndex];
}

int CalThread::findMaxIndex(QVector<double> data)
{
    int result = 0;
    for(int i = 1;i < data.size();i++)
    {
        if(data[i] > data[result])
            result = i;
    }
    return result;
}

double* CalThread::abs(double *data, int length)
{
    double *result = new double[length];
    for(int i = 0; i < length;i++)
    {
        result[i] = fabs(data[i]);
    }
    return result;
}

double* CalThread::hamming(int windowLength)
{
    double *window = new double[windowLength];
    for(int i = 0;i < windowLength; i++)
        window[i] = 0.54 - 0.46 * cos(2 * M_PI * i / (windowLength -1));
    return window;
}

void CalThread::bandPass(double *data,int length)
{
    double numerator[12] = {0.160173,0,-0.160173,
                            0.160173,0,-0.160173,
                            0.148663,0,-0.148663,
                            0.148663,0,-0.148663};
    double denominator[12] = {1,-1.654943,0.808912,
                              1,-1.947480,0.955044,
                              1,-1.827619,0.840246,
                              1,-1.547690,0.627149};
    double *a = new double[3];
    double *b = new double[3];
    for(int i = 0; i < 4 ; i++)
    {
        memcpy(b, numerator + i*3, 3*sizeof(double));
        memcpy(a, denominator + i*3, 3*sizeof(double));
        double *newData = filter(b , a, 3, data, length);
        memcpy(data, newData , length*sizeof(double));
        delete[] newData;
    }
    delete[] a;
    delete[] b;
//    delete[] numerator;
//    delete[] denominator;
}

double* CalThread::envelopeMax(double *data,int length,int span)
{
    double *tempData = new double[span];
    int pieceCount = length/span;
    double *result = new double[pieceCount];
    for(int i = 0; i< pieceCount;i++)
    {
        memcpy(tempData, data + i*span, span * sizeof(double));
        result[i] = findMaxValue(tempData,span);
    }
    delete[] tempData;
    return result;
}

double CalThread::sum(double* data,int length)
{
    double sum = 0.0;
    for(int i = 0; i < length;i++)
        sum += data[i];
    return sum;
}

double CalThread::mean(double* data,int length)
{
    double result = sum(data,length)/length;
    return result;
}

double CalThread::var(double* data,int length)
{
    double dataMean = mean(data,length);
    double result = 0.0;
    for(int i=0; i < length; i++)
        result += pow(data[i] - dataMean,2);
    result /= length;
    return result;
}

//double* CalThread::Matrix_division(double* a,double* b,int length)
//{//点除，数组长度需一致
//    double* y = new double[length];
//    for(int i = 0;i < length; i++)
//        y[i] = a[i]/b[i];
//    return y;
//}

double* CalThread::xcorr(double* a,int length_a)
{
    return xcorr(a,a,length_a,length_a,length_a-1);
}

double* CalThread::xcorr(double* a,double* b,int length_a,int length_b,int maxlag)
{
    double *y = new double[2*maxlag+1]();
    double *c = new double[2*maxlag+1];
    double *result = new double[2 * maxlag + 1];

    for(int lag = length_b-1,idx = maxlag-length_b+1;lag > -length_a;lag--,idx++)
    {
        if(idx < 0)
            continue;

        if(idx >= 2*maxlag+1)
            break;

        int start = 0;
        if(lag < 0) start = -lag;

        int end = length_a - 1;
        if(end > length_b-lag-1) end = length_b-lag-1;

        for(int n = start; n <= end; n++)
            y[idx] += a[n] * b[lag+n];

        for(int m=0; m < 2*maxlag+1; m++)
        {
            if(m <= maxlag)
                c[m] = m + 1;
            else c[m] = 2*maxlag-m+1;
            result[m] = y[m]/c[m];
        }
        //result = Matrix_division(y,c,2*maxlag+1);
    }
    delete[] y;
    delete[] c;
    return result;
}

bool CalThread::diff(QVector<int> &a,int pieceLength,QVector<double> &diff)
{
    for(int i = 0;i < a.size()-1; i++)
    {
        double temp = (double)a[i+1] - a[i];
        temp = temp * pieceLength / 44100;
        diff.append(temp);
    }
    return true;
}

bool CalThread::ismember(QVector<int> &a,int b)
{
    for(int i = 0;i < a.size();i++)
    {
        if(a[i] == b) return true;
    }
    return false;
}

int CalThread::NFFT(int length)
{
    int nfft = (int)pow(2,ceil(log(length)/log(2)));
    return nfft;
}

bool CalThread::FFT(double* data,int length,fftw_complex* out)
{
    int nfft = NFFT(length);
    double* newData = new double[nfft * 2]();
    for(int i=0;i<length;i++)
        newData[2*i] = data[i];
    fftw_complex *in;
    fftw_plan p;
    in = (fftw_complex*) fftw_malloc(sizeof(fftw_complex)*nfft);
    for(int i = 0;i < nfft;i++)
    {
        in[i][0] = newData[2*i];
        in[i][1] = newData[2*i+1];
    }
    p = fftw_plan_dft_1d(nfft,in,out,FFTW_FORWARD,FFTW_ESTIMATE);
    fftw_execute(p);
    fftw_destroy_plan(p);
    fftw_free(in);
    delete[] newData;
    //qDebug()<<data[0]<<data[1];
    //qDebug()<<out[0][0]<<out[0][1];
    return true;
}

double* CalThread::psd(double* data,int length)
{
    int nfft = NFFT(length);
    fftw_complex *out;
    out = (fftw_complex*) fftw_malloc(sizeof(fftw_complex)*nfft);
    FFT(data,length,out);
    double* result = new double[nfft];
    for(int i=0;i<nfft;i++)
        result[i] = pow(out[i][0],2) + pow(out[i][1],2);
    fftw_free(out);
    //delete[] freqData;
    return result;
}

void CalThread::pwelch(double* data, int length, double *energy)
{
    int windowLength = (int)floor(length/4.5);
    int overlap = (int)floor(0.5*windowLength);
    double *hamWindow = hamming(windowLength);
    int segmentCount = (length - overlap)/(windowLength - overlap);
    int nfft = NFFT(windowLength);

    double windowPower = 0.0;
    for(int i=0;i<windowLength;i++)
        windowPower += pow(hamWindow[i],2);

    //double *result = new double[nfft/2+1];
    double *windowData = new double[windowLength];
    for(int i=0;i<segmentCount;i++)
    {
        memcpy(windowData,data+i*(windowLength-overlap),windowLength*sizeof(double));

        //hamming window
        for(int j=0;j<windowLength;j++)
            windowData[j] *= hamWindow[j];

        //psd
        double* psdValue = psd(windowData,windowLength);
        for(int j=0;j<(nfft/2+1);j++)
            energy[j] += psdValue[j] / windowPower;
            //result[j] = psdValue[j];
        delete[] psdValue;
    }
    //average
    energy[0] /= segmentCount;
    energy[nfft/2] /= segmentCount;
    for(int i=1;i<(nfft/2);i++)
        energy[i] *= (2.0 / segmentCount);

    for(int i=0;i<(nfft/2+1);i++)
        energy[i] /= (2 * M_PI);

    delete[] hamWindow;
    delete[] windowData;
    //return result;
}

double CalThread::freqCenter(double* data,int length)
{
    int psd_length = NFFT((int)floor(length/4.5))/2+1;
    memset(psdValue,0,sizeof(double) * 4097);
    pwelch(data,length,psdValue);
    double result = 0.0;
    for(int i=0;i<psd_length;i++)
        result += (double)(i+1)/psd_length*M_PI*psdValue[i];
    result /= sum(psdValue,psd_length);
    //delete[] psdValue;
    return result;
}

double CalThread::ExtractCycle(double* data,int length,int type)
{
    qDebug()<<"begin Extract Cycle!";
    double cyc = 0.0,cycLoLimit = 0.0,cycUpLimit = 0.0;
    int pieceLength = 512,smoothLength = 51;
    QVector<int> LowerCheck,UpperCheck;
    if(type == 1.5)
    {
        cycLoLimit = 3.9;
        cycUpLimit = 5.8;
    }
    else if(type == 2)
    {
        cycLoLimit = 4.3;
        cycUpLimit = 8.6;
    }
    else
    {
        cycLoLimit = 7.0;
        cycUpLimit = 8.6;
    }
    double b[9] = {2.15209512141093e-05,0,-8.60838048564371e-05,0,0.000129125707284656,0,-8.60838048564371e-05,0,2.15209512141093e-05};
    double a[9] = {1,-7.16724071346125,22.9052562700252,-42.5910085210018,50.3741251499111,-38.8005815092689,19.0099471806714,-5.41920898111322,0.688887685664053};
    double *newData = filter(b,a,9,data,length);
    //envelope
    double *pieceData = envelopeMax(newData,length,pieceLength);
    int pieceData_length = length/pieceLength;
    //smooth
    double *pieceDataSmooth = smooth(pieceData,pieceData_length,smoothLength);
    double *C = xcorr(pieceDataSmooth,pieceData_length);
    //double *C = xcorr(pieceDataSmooth,pieceDataSmooth,pieceData_length,pieceData_length,pieceData_length-1);
    double *C_half = new double[pieceData_length];
    memcpy(C_half,C+pieceData_length-1,pieceData_length*sizeof(double));
    double *SmoothC = smooth(C_half,pieceData_length,smoothLength);
    QVector<int> locs;
    findPeaksIndex(SmoothC,pieceData_length,103,locs);
    for(int i=0;i<locs.size();i++)
    {
        if(locs[i]<100||locs[i]>pieceData_length-100)
        {
            locs.remove(i);
            i--;
        }
    }
    QVector<double> x;
    diff(locs,pieceLength,x);
    if(x.isEmpty()) {}
    else if(locs.size()>=3)
    {
        for(int i=0;i<x.size();i++)
        {
            if(x[i]<=cycUpLimit/3) UpperCheck.append(1);
            else UpperCheck.append(0);
            if(x[i]>=cycLoLimit/3) LowerCheck.append(1);
            else LowerCheck.append(0);
        }
        if(ismember(UpperCheck,0)||ismember(LowerCheck,0)){}
        else cyc = mean(x) * 3;
    }
    else
    {
        for(int i=0;i<x.size();i++)
        {
            if(x[i]<=cycUpLimit) UpperCheck.append(1);
            else UpperCheck.append(0);
            if(x[i]>=cycLoLimit) LowerCheck.append(1);
            else LowerCheck.append(0);
        }
        if(ismember(UpperCheck,0)||ismember(LowerCheck,0)){}
        else cyc = mean(x);
    }

    delete[] newData;
    delete[] pieceData;
    delete[] pieceDataSmooth;
    delete[] C;
    delete[] C_half;
    delete[] SmoothC;
    return cyc;
}
//Correlation coefficient
double CalThread::corrcoef(double* peakSmoothBefore, double* peakSmoothAfter)
{
	double peakSmoothBeforeMean = mean(peakSmoothBefore,0,peakOffsetPiece);
	double peakSmoothAfterMean = mean(peakSmoothAfter,0,peakOffsetPiece);
	double *covMat = new double[peakOffsetPiece+1];
	for(int covIdx=0;covIdx<peakSmoothBefore.length;covIdx++)
	{
		covMat[covIdx = (peakSmoothBefore[covIdx]-peakSmoothBeforeMean)*(peakSmoothAfter[covIdx]-peakSmoothAfterMean);
	}
	double cov = sum(covMat,covMat.length)/(covMat.length);//covMat.length-1???
	double varBefore = var(peakSmoothBefore,peakSmoothBefore.length);
	double varAfter = var(peakSmoothAfter,peakSmoothAfter.length);
	double sqrtVar = sqrt(varBefore*varAfter);
	double corrcoefValue = cov/sqrtVar;
	delete covMat[];
	return corrcoefValue;
}