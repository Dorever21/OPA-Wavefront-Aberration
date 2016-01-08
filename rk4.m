function yout=rk4(y,z,ny,h,P_w,S_w,I_w,K_con,dk)
%y����ֵ
%n�����̸���
%z����������
%h�����ֲ���
%�����Ľ�Runge-Kutta����΢�ַ���
%dy/dx=f(x,y) ,x belong to [a,b]
%y(x0)=y0
%����ֵ��
%---------------
%Yk+1=Yk+h/6*(K1+2K2+2K3+K4)
%K1=f(Xk,Yk)
%K2=f(Xk+h/2,Yk+h/2*K1)
%K3=f(Xk+h/2,Yk+h/2*K2)
%K4=f(Xk+h,Yk+h*K3)
%----------------

n=size(y);
dydz=zeros(n);
yt=zeros(n);
dyt=zeros(n);
dym=zeros(n);
dy4=dym;
yout=zeros(n);
hh=h*0.5;
h6=h/6.0;
zh=z+hh;
dydz=derivs(z,y,P_w,S_w,I_w,K_con,dk);%��Ӧk1
yt=y+hh.*dydz;
dyt=derivs(zh,yt,P_w,S_w,I_w,K_con,dk);%��Ӧk2
yt=y+hh.*dyt;
dym=derivs(zh,yt,P_w,S_w,I_w,K_con,dk);%��Ӧk3
yt=y+h.*dym;
dy4=derivs(z+h,yt,P_w,S_w,I_w,K_con,dk);%��Ӧk4
yout=y+h6.*(dydz+2.0.*dyt+2.0.*dym+dy4);%�������ֵ