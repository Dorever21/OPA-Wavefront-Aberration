%��fft����ifft,delta��ʱ���ܴ���
function x=ifftc(x,delta)
if nargin==1;
x=fftshift(fft(fftshift(x)));
elseif nargin==2
x=fftshift(fft(fftshift(x)));
x=x/delta;
else disp('error in ifftc!');
end

    