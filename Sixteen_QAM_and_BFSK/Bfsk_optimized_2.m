% ==================================Modulation==============================%
M = 2;
freqSep = 100;
fskMod = comm.FSKModulator(M,freqSep);
fskDemod = comm.FSKDemodulator(M,freqSep);
ch = comm.AWGNChannel('NoiseMethod', ...
    'Signal to noise ratio (SNR)','SNR',-2);
err = comm.ErrorRate;
for counter = 1:100
    data = randi([0 M-1],50,1);
    modSignal = step(fskMod,data);
    noisySignal = step(ch,modSignal);
    receivedData = step(fskDemod,noisySignal);
    errorStats = step(err,data,receivedData);
end
es = 'Error rate = %4.2e\nNumber of errors = %d\nNumber of symbols = %d\n';
%===========================Creating constellation=======================%
scope = comm.ConstellationDiagram('ShowReferenceConstellation', false);
scope_1=comm.ConstellationDiagram('ShowReferenceConstellation', false);
scope(modSignal);
scope_1(noisySignal)
fprintf(es,errorStats)




%============= To calculate simulated BER====================% 
   

data = randi([0 M-1],50,1);
modSignal = step(fskMod,data);
c=1;
w=zeros(length(-6:2:10),1);
BER_handed=zeros(length(-6:2:10),1);
for z=-6:2:10
ch = comm.AWGNChannel('NoiseMethod', ...
    'Signal to noise ratio (SNR)','SNR',z);    
noisySignal= step(ch,modSignal);
receivedData = step(fskDemod,noisySignal);
errorStats = step(err,data,receivedData);
w(c)=errorStats(1);
BER_handed(c)=sum(xor(data,receivedData))/length(data);
c=c+1;
end

%============================== To calculate theoretical BER===============
figure (1)
EbN0dB = -6:2:10;
EbN0 = 10.^(EbN0dB/10)*0.5;
theoreticalBER = 0.5*erfc(sqrt(EbN0));
plot(EbN0dB,log10(theoreticalBER),'r--');
title('SNR per bit (Eb/N0) Vs BER Curve for BFSK Modulation Scheme Theoretically');
xlabel('SNR per bit (Eb/N0) in dB');
ylabel('Bit Error Rate (BER) in dB');

figure (2)
plot (EbN0dB,w,'k*')
title('SNR per bit (Eb/N0) Vs BER Curve for BFSK Modulation Scheme using Simulation');
xlabel('SNR per bit (Eb/N0) in dB');
ylabel('Bit Error Rate (BER) in dB');


%================================To calculate psd 
figure (3)

numSamplesPerSymbol = 10;
shape=ones ( numSamplesPerSymbol , 1 ) ;
TxSignal=upfirdn ( modSignal , shape , numSamplesPerSymbol ) ;
Fs=100;

pwelch(TxSignal)


