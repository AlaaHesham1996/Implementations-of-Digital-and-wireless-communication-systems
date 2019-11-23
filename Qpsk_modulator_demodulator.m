clear; %clear all stored variables
N=100; %number of data bits
noiseVariance = 0.1; %Noise variance of AWGN channel
Rb=1e3; %bit rate
amplitude=1; % Amplitude of NRZ data
data=randn(1,N)>=0; %Generate uniformly distributed random data
oddBits = data(1:2:end);
evenBits= data(2:2:end);
[evenTime,evenNrzData,Fs]=NRZ_Encoder(evenBits,Rb,amplitude,'Polar');
[oddTime,oddNrzData]=NRZ_Encoder(oddBits,Rb,amplitude,'Polar');
Fc=2*Rb;
inPhaseOsc = 1/sqrt(2)*cos(2*pi*Fc*evenTime);
quadPhaseOsc = 1/sqrt(2)*sin(2*pi*Fc*oddTime);
qpskModulated = oddNrzData.*quadPhaseOsc + evenNrzData.*inPhaseOsc;
Tb=1/Rb;
subplot(3,2,1);
stem(data);
xlabel('Samples');
ylabel('Amplitude');
title('Input Binary Data');
axis([0,N,-0.5,1.5]);
subplot(3,2,3);
plotHandle=plot(qpskModulated);
xlabel('Samples');
ylabel('Amplitude');
title('QPSK modulated Data');
%xlimits = XLIM;
%ylimits = YLIM;
%axis([xlimits,ylimits(1)-0.5,ylimits(2)+0.5]) ;
grid on;
%-------------------------------------------
%Adding Channel Noise
%-------------------------------------------
noise = sqrt(noiseVariance)*randn(1,length(qpskModulated));
received = qpskModulated + noise;
subplot(3,2,5);
plot(received);
xlabel('Time');ylabel('Amplitude');
title('QPSK Modulated Data with AWGN noise');
%-------------------------------------------
%QPSK Receiver
%-------------------------------------------
%Multiplying the received signal with reference Oscillator
iSignal = received.*inPhaseOsc;
qSignal = received.*quadPhaseOsc;
%Integrator
integrationBase = 0:1/Fs:Tb-1/Fs;
for i = 0:(length(iSignal)/(Tb*Fs))-1
inPhaseComponent(i+1)=trapz(integrationBase,iSignal(int32(i*Tb*Fs+1):int32((i+1)*Tb*Fs)));
end
for i = 0:(length(qSignal)/(Tb*Fs))-1
quadraturePhaseComponent(i+1)=trapz(integrationBase,qSignal(int32(i*Tb*Fs+1):int32((i+1)*Tb*Fs)));
end
%Threshold Comparator
estimatedInphaseBits=(inPhaseComponent>=0);
estimatedQuadphaseBits=(quadraturePhaseComponent>=0);
finalOutput=reshape([estimatedQuadphaseBits;estimatedInphaseBits],1,[]);
BER = sum(xor(finalOutput,data))/length(data);
subplot(3,2,2);
stem(finalOutput);
xlabel('Samples');
ylabel('Amplitude');
title('Detected Binary Data after QPSK demodulation');
axis([0,N,-0.5,1.5]);
%Constellation Mapping at transmitter and receiver
%constellation Mapper at Transmitter side
subplot(3,2,4);
plot(evenNrzData,oddNrzData,'ro');
xlabel('Inphase Component');
ylabel('Quadrature Phase component');
title('QPSK Constellation at Transmitter');
axis([-1.5,1.5,-1.5,1.5]);
h=line([0 0],[-1.5 1.5]);
set(h,'Color',[0,0,0])
h=line([-1.5 1.5],[0 0]);
set(h,'Color',[0,0,0])
%constellation Mapper at receiver side
subplot(3,2,6);
%plot(inPhaseComponent/max(inPhaseComponent),quadraturePhaseComponent/max(quadraturePhaseC
plot(2*estimatedInphaseBits-1,2*estimatedQuadphaseBits-1,'ro');
xlabel('Inphase Component');
ylabel('Quadrature Phase component');
title(['QPSK Constellation at Receiver when AWGN Noise Variance =',num2str(noiseVariance)]);
axis([-1.5,1.5,-1.5,1.5]);
h=line([0 0],[-1.5 1.5]);
set(h,'Color',[0,0,0]);
h=line([-1.5 1.5],[0 0]);
set(h,'Color',[0,0,0]);
% ================================here========================================

%---------Input Fields------------------------
N=1000000;%Number of input bits
EbN0dB = -4:2:10; % Eb/N0 range in dB for simulation
%---------------------------------------------
data=randn(1,N)>=0; %Generating a uniformly distributed random 1s and 0s
oddData = data(1:2:end);
evenData = data(2:2:end);
qpskModulated = sqrt(1/2)*(1i*(2*oddData-1)+(2*evenData-1)); %QPSK Mapping
M=4; %Number of Constellation points M=2^k for QPSK k=2
Rm=log2(M); %Rm=log2(M) for QPSK M=4
Rc=1; %Rc = code rate for a coded system. Since no coding is used Rc=1
BER = zeros(1,length(EbN0dB)); %Place holder for BER values for each Eb/N0
index=1;
for i=EbN0dB
%-------------------------------------------
%Channel Noise for various Eb/N0
%-------------------------------------------
%Adding noise with variance according to the required Eb/N0
EbN0 = 10.^(i/10); %Converting Eb/N0 dB value to linear scale
noiseSigma = sqrt(1./(2*Rm*Rc*EbN0)); %Standard deviation for AWGN Noise
%Creating a complex noise for adding with QPSK modulated signal
%Noise is complex since QPSK is in complex representation
noise = noiseSigma*(randn(1,length(qpskModulated))+1i*randn(1,length(qpskModulated)));
received = qpskModulated + noise;
%-------------------------------------------
%Threshold Detector
detected_real = real(received)>=0;
detected_img = imag(received)>=0;
estimatedBits=reshape([detected_img;detected_real],1,[]);
%------------------------------------------
%Bit Error rate Calculation
BER(index) = sum(xor(data,estimatedBits))/length(data);
index=index+1;
end
%Plot commands follows
plotHandle=plot(EbN0dB,log10(BER),'r--');
set(plotHandle,'LineWidth',1.5);
title('SNR per bit (Eb/N0) Vs BER Curve for QPSK Modulation Scheme');
xlabel('SNR per bit (Eb/N0) in dB');
ylabel('Bit Error Rate (BER) in dB');
grid on;
hold on;
theoreticalBER =0.5*erfc(sqrt(10.^(EbN0dB/10)));
plotHandle=plot(EbN0dB,log10(theoreticalBER),'b*');
set(plotHandle,'LineWidth',1.5);
legend('Simulated','Theoretical-QPSK','Theoretical-QPSK');
grid on;
% To calculate power specturm psd uncomment following three lines 

%Hpsd = psd(h,qpskModulated,'Fs',Fs);
%plot(Hpsd);

%title('PSD of QPSK modulated Data');
