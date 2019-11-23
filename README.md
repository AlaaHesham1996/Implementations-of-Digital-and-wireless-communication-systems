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

![bpsk_noise](https://user-images.githubusercontent.com/46730861/69485692-9b5b2800-0e4b-11ea-86a1-84f5fdddc719.png)
![SNR](https://user-images.githubusercontent.com/46730861/69485734-381dc580-0e4c-11ea-8fac-51c09dc816c4.png)

### Results comments 
I think all the results make sense :
* For input binary data , they are either 0s or 1s which is the case .
* For polar NRZ encoded data , they have the same shape as binary data except that for symbol 0 they have a negative  amplitude instead of zero .
* For BPSK , they have multiplied by a carrier that is why they have a sinusoidal shape , we could easily detect phase discontinuity .
* For PSD , most power is   concentrated at 2 kH which is apparently carrier frequency . There are side loops as pulse shape in time domain is a rect function so it will be sinc in frequency domain.
* After adding noise with variance equal to 0.5  , we could easily notice that data amplitude is not constant anymore . Since we are doing phase modulation , it will not affect Estimated Binary data that much .
* For constellation , it is as expected have one basis function , and symbol one corresponds to(1* E_b*basis function ) and symbol 0 corresponds to (-1*E_b*basis function)  .Here we have made E_b equals to one .
* For constellation after adding noise , we can see that noise makes data deviate from E_b  and -E_b that is why we use maximum likelihood to decide if a noisy symbol is symbol 0or symbol 1 .
* For the SNR graph versus BER , it makes sense .The more you add power to signal , the distance between symbols increase and hence the probability of error decreases .

## For QPSK 
### Code Highlights :

* Generate data using Randn Matlab function (1s and 0s).
* Divide bits to even bits and odd bits as well as Time so that inphase components are 1/sqrt(2)*cos(2*pi*Fc*evenTime), and quadrature  components are  1/sqrt(2)*sin(2*pi*Fc*oddTime) .
* QPSK modulated signals  is the summation of in-phase and quadrature components .
* To simulated channel effect , AWGN is summed to Qpsk modulated signals.However this noise is now has two components real component to be added to inphase components and imaginary components to be added its magnitude to quadrature components  .
* For Qpsk receiver , multiply received bits with carrier elementwise .For in phase components multiply them by in phase oscillator and for quadrature multiply them by quadrature oscillator  , and then integrate them separately  with the aid of Matlab Built -in function Trapz .
* To calculate psd , matlab built-in”psd” function is used.
* To calculate the bit error rate(BER) , Xoring  data with streamed/received  bits and divide it by the total data size to get percentage of error.

### Qpsk results 

![Qpsk](https://user-images.githubusercontent.com/46730861/69485796-2688ed80-0e4d-11ea-99ad-f741138508b3.png)
![Qpsk _psd](https://user-images.githubusercontent.com/46730861/69485799-2ab50b00-0e4d-11ea-9b85-3442f619d789.png)

![Qpsk_SNR](https://user-images.githubusercontent.com/46730861/69485774-cbef9180-0e4c-11ea-9d1f-db2e2979868e.png)

### Qpsk results comments 

* for input binary data , they are either 0s or 1s which is the case .
* For QPSK , they have multiplied by a carrier that is why they have a sinusoidal shape , we could easily detect phase discontinuity .
* For PSD , I do not think that I have coded right as I was expecting to have two peaks at f+fc , and f-fc so it should be sth like this.
![Qpsk psd expected](https://user-images.githubusercontent.com/46730861/69485834-9eefae80-0e4d-11ea-9cca-b88c0e347697.png)

* After adding noise with variance equal to 0.1 , we could easily notice that data amplitude is not constant anymore . Since we are doing phase modulation , it will not affect Estimated Binary data that much .
* For constellation , it is as expected have two  basis functions and the angle between every symbol is 90 . They are at (E_b,E_b),(-Eb,Eb),(-E_b,-Eb),(Eb,-Eb) where E_b =1 
* For the SNR graph versus BER , it makes sense .The more you add power to signal , the distance between symbols increase and hence the probability of error decreases .

* Q-psk is just like performing two Bpsk . One is for inphase component and the other is for quadrature component.
* By noticing Q-psk and Bpsk BER curves versus SNR , we can easily notice that they have the same probability of error .






