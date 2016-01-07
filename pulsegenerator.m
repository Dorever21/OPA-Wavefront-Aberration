function E=pulsegenerator(x,y,t,t0,d0,mxy,mt)
%Pulse Generation
% mxy    ��˹��������-�ռ�
% mt     ��˹��������-ʱ��
% x,y,t  ����ռ�ʱ����ɢ����
% t0     ����
% d0     ����ֱ��
% ��д��2008/12/5��
num=size(t,2);
nx=size(x,2);
ny=size(y,2);
E=zeros(num,nx,ny);
[X,Y]=meshgrid(x,y);
for lt=1:num   
    E(lt,:,:)=sqrt(exp(-(X.^2+Y.^2).^mxy/(d0/(2*log(2)^(1/2/mxy)))^(2*mxy))*exp(-t(lt)^(2*mt)/(t0/2/log(2)^(1/2/mt))^(2*mt)));
end