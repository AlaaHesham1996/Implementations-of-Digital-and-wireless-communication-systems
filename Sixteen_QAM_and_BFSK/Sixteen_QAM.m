N=10000; %Number of input symbols
EbN0dB = -6:2:12; %Define EbN0dB range for simulation
M=16; %for 16-QAM modulation.
%---------------------------------------------
refArray =1/sqrt(10)*[-3-3j,-3-1j,-3+3j,-3+1j,-1-3j,-1-1j,-1+3j,-1+1j,3-3j,3-1j,3+3j,3+1j,1-3j,1-1j,1+3j,1+1j];
symErrSimulated = zeros(1,length(EbN0dB));
k=log2(M);
EsN0dB = EbN0dB + 10*log10(k);
%---Generating a uniformly distributed random numbers in the set [0,1,2,..,M-1]
data=ceil(M.*rand(N,1))-1;
s=refArray(data+1); %16-QAM Constellation mapping with Gray coding
refI = real(refArray);
refQ = imag(refArray);
%---Place holder for Symbol Error values for each Es/N0 for particular M value--
index=1;
figure(1);
subplot(1,2,1);
plot(real(s),imag(s),'r*');
title('Constellation diagram for Transmitted Symbols');
xlabel('Inphase component');
ylabel('Quadrature component');
subplot(1,2,2);
for x=EsN0dB
%-------------------------------------------
%Channel Noise for various Es/N0
%-------------------------------------------
%Adding noise with variance according to the required Es/N0
noiseVariance = 1/(10.^(x/10));%Standard deviation for AWGN Noise
noiseSigma = sqrt(noiseVariance/2);
%Creating a complex noise for adding with M-QAM modulated signal
%Noise is complex since M-QAM is in complex representation
noise = noiseSigma*(randn(size(s))+1i*randn(size(s)));
received = s + noise;
%-------------I-Q Branching---------------
r_i = real(received);
r_q = imag(received);
%---Decision Maker-Compute (r_i-s_i)^2+(r_q-s_q)^2 and choose the smallest
r_i_repmat = repmat(r_i,M,1);
r_q_repmat = repmat(r_q,M,1);
plot(r_i,r_q,'*');
title(['Constellation diagram for Received Symbols Eb/N0=' num2str(x-10*log10(k)) 'dB']);
xlabel('Inphase component');
ylabel('Quadrature component');
pause;
distance = zeros(M,N); %place holder for distance metric
minDistIndex=zeros(N,1);
for j=1:N
%---Distance computation - (r_i-s_i)^2+(r_q-s_q)^2 --------------
distance(:,j) = (r_i_repmat(:,j)-refI').^2+(r_q_repmat(:,j)-refQ').^2;
%---capture the index in the array where the minimum distance occurs
[dummy,minDistIndex(j)]=min(distance(:,j));
end
y = minDistIndex - 1;%The index becomes the decoded symbol
%--------------Symbol Error Rate Calculation-------------------------------
dataCap = y;
symErrSimulated(1,index) = sum(dataCap~=data)/N;
index=index+1;
end
%----- Compute Theoretical Symbol Error Rates ---------------------
%EsN0lin = 10.^(EsN0dB/10);
EbN0lin = 10.^(EbN0dB/10);
symErrTheory = 2*(1-1/sqrt(M))*erfc(sqrt(3/2*k*EbN0lin/(M-1)));
%---------------Plotting commands-----------------------
figure(2);
semilogy(EbN0dB,symErrTheory,'r-');hold on;
semilogy(EbN0dB,symErrSimulated,'b*');
legend('16QAM-Theory','16QAM-Sim');
xlabel('Eb/N0(dB)');
ylabel('Symbol Error Rate (Ps)');
grid on;
