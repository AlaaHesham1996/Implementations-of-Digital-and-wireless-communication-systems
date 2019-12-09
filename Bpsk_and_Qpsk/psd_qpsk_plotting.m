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
numSamplesPerSymbol = 5;
shape=ones ( numSamplesPerSymbol , 1 ) ;
TxSignal=upfirdn ( qpskModulated , shape , numSamplesPerSymbol ) ;
Fs=100;

pwelch(TxSignal)