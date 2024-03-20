clc;
close all;

% Set the parameters
numBits = 32768;  % number of bits to be transmitted
modOrder = 16;  % for 16-QAM
bitsPerQAMSymbol = log2(modOrder);  % modOrder = 2^bitsPerQAMSymbol

dataLen = numBits/bitsPerQAMSymbol;  % length of each symbol, which is the same as the number of carriers and the number of FFT bins
numCarr = dataLen;  % number of subcarriers
numFFTbins = dataLen;  % number of FFT bins
cycPrefLen = 32;  % cyclic prefix length
symLen = dataLen + cycPrefLen;  % length of each symbol after adding the cyclic prefix

numSym = 1024;  % number of OFDM symbols to be transmitted in one frame, as well as the number of IFFT operations

% Generate a random bit stream
srcBits = randi([0,1],numBits * numSym);

% Map the bits to 16-QAM symbols
qamModOut = qammod(srcBits,modOrder,"InputType","bit","UnitAveragePower",true);

% Computation of Hermitian Symmetry Criteria
qamModOutmat = zeros(numFFTbins,numSym);
qamModOutmat(2:numFFTbins / 2,:) = reshape(qamModOut,[dataLen / 2 - 1,numSym]); % Performing serial to parallel conversion
qamModOutmat(numFFTbins / 2 + 2:numFFTbins,:) = conj(flipud(qamModOutmat(2:numFFTbins / 2,:)));

% Perform IFFT
ifftOut = ifft(qamModOutmat,numFFTbins,1);

% Add cyclic prefix
txSig = [ifftOut(end - cycPrefLen + 1:end,:);ifftOut];

% Calculate DC bias
bdc = 7;
clip = sqrt((10 .^ (bdc / 10)) - 1);
bdcc = clip *sqrt(txSig .* txSig);
dcBias = txSig + bdcc;


