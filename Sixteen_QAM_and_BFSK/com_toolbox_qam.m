M = 16;                     % Size of signal constellation
k = log2(M);                % Number of bits per symbol
n = 30000;                  % Number of bits to process
numSamplesPerSymbol = 1;    % Oversampling factor
rng default                 % Use default random number generator
dataIn = randi([0 1],n,1);  % Generate vector of binary data
stem(dataIn(1:40),'filled');
title('Random Bits');
xlabel('Bit Index');
ylabel('Binary Value');
dataInMatrix = reshape(dataIn,length(dataIn)/k,k);   % Reshape data into binary k-tuples, k = log2(M)
dataSymbolsIn = bi2de(dataInMatrix);                 % Convert to integers
% Plot the first 10 symbols in a stem plot.

figure; % Create new figure window.
stem(dataSymbolsIn(1:10));
title('Random Symbols');
xlabel('Symbol Index');
ylabel('Integer Value');
EbNo = 10;
snr = EbNo + 10*log10(k) - 10*log10(numSamplesPerSymbol);
dataMod = qammod(dataSymbolsIn,M,'bin');         % Binary coding, phase offset = 0
dataModG = qammod(dataSymbolsIn,M); % Gray coding, phase offset = 0
receivedSignal = awgn(dataMod,snr,'measured');



receivedSignalG = awgn(dataModG,snr,'measured');
sPlotFig = scatterplot(receivedSignal,1,0,'g.');
hold on
scatterplot(dataMod,1,0,'k*',sPlotFig)
dataSymbolsOut = qamdemod(receivedSignal,M,'bin');
dataSymbolsOutG = qamdemod(receivedSignalG,M);
dataOutMatrix = de2bi(dataSymbolsOut,k);
dataOut = dataOutMatrix(:);                   % Return data in column vector
dataOutMatrixG = de2bi(dataSymbolsOutG,k);
dataOutG = dataOutMatrixG(:);        
[numErrors,ber] = biterr(dataIn,dataOut);
fprintf('\nThe binary coding bit error rate = %5.2e, based on %d errors\n', ...
    ber,numErrors)
[numErrorsG,berG] = biterr(dataIn,dataOutG);
fprintf('\nThe Gray coding bit error rate = %5.2e, based on %d errors\n', ...
    berG,numErrorsG)
M = 16;                         % Modulation order
x = (0:15)';                    % Integer input
y1 = qammod(x,16,'bin');        % 16-QAM output
scatterplot(y1)
text(real(y1)+0.1, imag(y1), dec2bin(x))
title('16-QAM, Binary Symbol Mapping')
axis([-4 4 -4 4])
y2 = qammod(x,16,'gray');  % 16-QAM output, Gray-coded
scatterplot(y2)
text(real(y2)+0.1, imag(y2), dec2bin(x))
title('16-QAM, Gray-coded Symbol Mapping')
axis([-4 4 -4 4])
numSamplesPerSymbol = 4;
shape=ones ( numSamplesPerSymbol , 1 ) ;
TxSignal=upfirdn (dataModG , shape , numSamplesPerSymbol ) ;
Fs=100

pwelch(TxSignal)