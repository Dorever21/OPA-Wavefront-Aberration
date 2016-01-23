function E=pulsegenerator(x,y,t,t0,d0,mxy,mt,chirp)
%Pulse Generation
% mxy    ��˹��������-�ռ�
% mt     ��˹��������-ʱ��
% x,y,t  ����ռ�ʱ����ɢ����
% t0     ����
% d0     ����ֱ��
% ��д��2008/12/5��

c=2.99792e+8; %����
ele_c=8.8541e-12;%��յ�����
num=size(t,2);
nx=size(x,2);
ny=size(y,2);
E=zeros(num,nx,ny);
[X,Y]=meshgrid(x,y);
T0=t0/(2*log(2)^(1/2/mxy));
D0=d0/(2*log(2)^(1/2/mxy));
dt=t(2)-t(1);
for lt=1:num   
    E(lt,:,:)=exp(-(X.^2+Y.^2).^mxy/D0^(2*mxy))*exp(-0.5*(1+1i*chirp)*(t(lt)/T0)^(2*mt));
end