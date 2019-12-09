numSamplesPerSymbol = 5;
shape=ones ( numSamplesPerSymbol , 1 ) ;
TxSignal=upfirdn ( bpskModulated , shape , numSamplesPerSymbol ) ; % make sure to run Bpsk_modulator_demodulator before running this code 
Fs=100;

pwelch(TxSignal)