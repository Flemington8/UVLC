clc;
close all;

% Generate a random bit stream
numBits = 32768;
srcBits = randi([0,1],numBits,1);

% Modulate the signal
ookModOut = srcBits;

% Add noise to the signal
SNR = 10;
chanOut = awgn(ookModOut,SNR,'measured');

% Demodulate the signal
threshold = 0.5;
ookDemodOut = chanOut > threshold;

% Calculate the bit error rate
numBitErrors = nnz(srcBits~=ookDemodOut);
BER = numBitErrors/numBits;

% Display the results
disp(['Bit error rate: ',num2str(BER)]);