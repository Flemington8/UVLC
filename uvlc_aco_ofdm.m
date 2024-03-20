Null Subcarriers
Instructions are in the task pane to the left. Complete and submit each task one at a time.
This code sets the simulation parameters.
modOrder = 16;  % for 16-QAM
bitsPerSymbol = log2(modOrder)  % modOrder = 2^bitsPerSymbol

mpChan = [0.8; zeros(7,1); -0.5; zeros(7,1); 0.34];  % multipath channel
SNR = 15   % dB, signal-to-noise ratio of AWGN

numCarr = 8192;  % number of subcarriers
cycPrefLen = 32;  % cyclic prefix length

Task 1
numGBCarr = numCarr/16
gbLeft = 1:numGBCarr
gbRight = (numCarr-numGBCarr+1):numCarr


Task 2
dcIdx = (numCarr/2)+1
nullIdx = [gbLeft dcIdx gbRight]'


Task 3
numDataCarr = numCarr - length(nullIdx)
numBits = numDataCarr*bitsPerSymbol;


Create the source bit sequence and modulate using 16-QAM.
if exist("numBits","var")  % code runs after you complete Task 3
    srcBits = randi([0,1],numBits,1);
    qamModOut = qammod(srcBits,modOrder,"InputType","bit","UnitAveragePower",true);
end

Task 4
ofdmModOut = ofdmmod(qamModOut,numCarr,cycPrefLen,nullIdx);


Channel: multipath and AWGN
if exist("ofdmModOut","var")  % code runs after you complete Task 4
    mpChanOut = filter(mpChan,1,ofdmModOut);
    chanOut = awgn(mpChanOut,SNR,"measured");
end

Task 5
ofdmDemodOut = ofdmdemod(chanOut,numCarr,cycPrefLen,cycPrefLen,nullIdx);


Task 6
mpChanFreq = fftshift(fft(mpChan,numCarr));
mpChanFreq(nullIdx) = [];


Task 7
eqOut = ofdmDemodOut ./ mpChanFreq;
scatterplot(eqOut)
title("Frequency Domain Equalizer Output")


Demodulate back into bits, then calculate the BER.
if exist("eqOut","var")  % code runs after you complete Task 7
    qamDemodOut = qamdemod(eqOut,modOrder,"OutputType","bit","UnitAveragePower",true);
    numBitErrors = nnz(srcBits~=qamDemodOut)
    BER = numBitErrors/numBits
end

Further Practice
% specAn = dsp.SpectrumAnalyzer("NumInputPorts",2, ...
%     "SpectralAverages",50,...
%     "ShowLegend",true);
% specAn(ofdmModOut,chanOut)


