# Implementations-of-Digital-and-wireless-communication-systems 
In this respiratory , I will implement multiple modulation/demodulation techniques such as BPSK , QPSK ,QAM ,BFSK  along with their communication systems . The main source  I have used is" simulation of Digital communication by Viswanathan textbook" .

## For Bpsk

### **Code highlights**  :
* Generate data using Randn Matlab function (1s and 0s)  
* Perform data Encoding using polar NRZ scheme using NRZ_Encoder(1 → symbol 1 ,-1  → symbol 0)  
* Bpsk modulation is equivalent to multiplying data by sinusoidal carrier. If symbol 1 is transmitted, it will be cos(2*pi*fc*t)/sin(2*pi*fc*t) . if symbol 0 is transmitted , it will be -cos (2*pi*fc*t)  

* To simulated channel effect , AWGN is summed to Bpsk modulated signals   

* To calculate psd , matlab built-in”psd” function is used.  
* For Bpsk receiver , multiply received bits with carrier elementwise , and then integrate with the aid of Matlab Built -in function Trapz
* To calculate the bit error rate(BER) , Xoring  data with streamed/received  bits and divide it by the total data size to get percentage of error.  
* To plot SNR against BER , we will assume that E_b/N0 in dB  vary from -6 to 10 and calculate corresponding BER using this formula BER =   0.5*erfc(sqrt(10.^(EbN0dB/10)))Generate data using Randn Matlab function (1s and 0s)  


### Bpsk Results 


![GitHub bpsk](/images/bpsk.png)
Format: ![Alt Text](https://drive.google.com/open?id=1J9nPALXr8iXdhVcLeCS5WOq_f_HCoNFh)







