function [fx,fy]=spati_vector(nx,ny,x,y)
%�����ռ�Ƶ������ 
Y=y(ny)-y(1);      
dfy=1/Y;            %�ռ�Ƶ�ʷֱ���
fy=(-ny/2:(ny/2-1))*dfy;           %�ռ�Ƶ������
X=x(nx)-x(1);      
dfx=1/X;            %�ռ�Ƶ�ʷֱ���
fx=(-nx/2:(nx/2-1))*dfx;           %�ռ�Ƶ������
end