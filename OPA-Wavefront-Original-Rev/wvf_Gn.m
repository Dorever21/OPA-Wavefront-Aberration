function Exy_ph=wvf_Gn(x,y,sgx,A)
%���������λ��
%sgx ��λ�仯�ռ�Ƶ�ʲ�����ͨ��2-12����
%A ���Ʋ�����λ�ķ���

nx=size(x,2);
ny=size(y,2);
sgy=sgx;
[X,Y]=meshgrid(x,y);
a=2*rand(nx,ny)-1;
b=exp(-((X/sgx).^2+(Y/sgy).^2));
Exy_ph=A*conv2(a,b,'same');

