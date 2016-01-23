function [Exy,fx,fy]=xy_fft(Exy,x,y)
% ������������ά��������������и���Ҷ�任��
%-----------------------------
% Ey��Ϊ�������糡ǿ�ȣ�
% y��Ϊ����y�����������
% EfyΪ��y������пռ丵��Ҷ�任������ֵ��
% fy��Ϊ�ռ�Ƶ��������
%-------------------------------
[nx,ny]=size(Exy);   
Y=y(ny)-y(1);      
dy=Y/(ny-1);            %�ռ�ֱ���
dfy=1/Y;            %�ռ�Ƶ�ʷֱ���
fy=(-ny/2:(ny/2-1))*dfy;           %�ռ�Ƶ������
X=x(nx)-x(1);      
dx=X/(nx-1);            %�ռ�ֱ���
dfx=1/X;            %�ռ�Ƶ�ʷֱ���
fx=(-nx/2:(nx/2-1))*dfx;           %�ռ�Ƶ������
Exy=fftshift(Exy);  %FFT�㷨��Ҫ�ڵ�һ������λ�ô�������ֵ��Ӧ��������
                    %Ӧ��FFT֮ǰshift������������������������
Exy=fft2(Exy)*dx*dy; %�Խ�����Բ������ʹ������ƽ�����ʽ�ĸ���Ҷ�任����
Exy=fftshift(Exy);  %����Ƶ�������м�λ��