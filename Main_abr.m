% function main
tic
clear all;
%������ʼֵ����
%----------------------------------------------  
% scale_cal=1.5;
num=50;                        %ʱ��ȡ������
nstep=50;                    %z�����ֲ�������
nwav=50;                    %�źŹ����Ƶ��wavelength��������
nx=64;                      %x��ȡ������
ny=nx;                      %y��ȡ������
nvar=3;                      %�������̸���
t0=60e-12;                     %�����ȣ�ns
beta2=-1;
omega=2;

d0=200e-3;                   %���ֱ��:m
crstl_L=45.5e-3;             %���峤��:m
z1=0;                        %�������
z2=crstl_L;                  %�����յ�:m
s=2;                         %���ڿ������
%��ʼ�糡ǿ��
E_P0=8.9e+7;   
E_S0=5.0e+3;
E_I0=0;
%---------------------------------------------------------------------------
dt=s*t0/num;                %ʱ��ȡ���ֱ���
dx=s*d0/nx;                 %x��ȡ���ֱ���
dy=dx;                      %y��ȡ���ֱ���
x=-s*d0/2:dx:s*d0/2-dx;     %x������
y=x;                        %y������ 
t=-s*t0/2:dt:s*t0/2-dt; %t������
%ȫ�ֱ���
%-----------------
const_LBO;         
%----------------
zz=zeros(nstep+1,1);
E_P_out=zeros(num,nx,ny);   %���ֹ�糡ǿ��
E_S_out=zeros(num,nx,ny);   %�źŹ�糡ǿ��
E_I_out=zeros(num,nx,ny);   %���ù�糡ǿ��
E_S_ph=zeros(num,nx,ny);    %�źŹⲨǰ�ڲ������ù����еı仯
E_I_ph=zeros(num,nx,ny);    %���ùⲨǰ�ڲ������ù����еı仯
E_P_ph=zeros(num,nx,ny);    %���ֹⲨǰ�ڲ������ù����еı仯
E_S_am=zeros(num,nx,ny);    %�źŹ�糡ǿ���ڲ������ù����еı仯
E_I_am=zeros(num,nx,ny);    %���ù�糡ǿ���ڲ������ù����еı仯
E_P_am=zeros(num,nx,ny);    %���ֹ�糡ǿ���ڲ������ù����еı仯
E_S_xy=zeros(nx,ny);
E_I_xy=zeros(nx,ny);
E_P_xy=zeros(nx,ny);
Bmxz=zeros(nstep,num);
Bmxy=zeros(nstep,num);
bmx=zeros(1,num);
bmy=zeros(1,num);
v=zeros(nvar,nx,ny);
sum_Es=zeros(nstep,1);
sum_Ep=zeros(nstep,1);
Is=zeros(num,nx,ny);
Ip=zeros(num,nx,ny);
P=zeros(num,1);
[X,Y]=meshgrid(x,y);
% EXY=normrnd(1,0.0625,nx,ny);% EXY=cos(15*(X+Y)/d0)*pi*2;% EXY=normrnd(1,0.0625,nx,ny);%�����������
%���䲨ǰ��������
%-------------------------------------------------------------------------
Exy_ph=wvf_Gn(x,y,8e-2);
save('data\ph_abr2.mat','Exy_ph');
buf=load('data\ph_abr2.mat');
Exy_ph=buf.Exy_ph;
%-------------------------------------------------------------------------
W_F=exp(-(X.^2+Y.^2).^20/(1.3*d0/2/log(2)^(0.025))^40);
%�糡ǿ�ȸ���ֵ
%--------------------------------------------------------------------------
E_S_out=E_S0*pulsegenerator(x,y,t,t0,d0,1,1)/sqrt(S_R_index(num/2));
E_P_out=E_P0*pulsegenerator(x,y,t,t0,d0,5,5)/sqrt(P_R_index);%.*exp(i*0.6*Exy_ph);
%--------------------------------------------------------------------------

for k=1:num 
   E_P_out(k,:,:)=exp(j*0.6*Exy_ph).*squeeze(E_P_out(k,:,:));
end

%�����źŹ⡢���ù��ʼʱ�䲨��
figure(1) 
subplot(2,2,1)
I=(1/2*c*ele_c).*P_R_index*abs(E_P_out(:,nx/2,ny/2).^2);
plot(t*1e9,I/max(I),'k-.','LineWidth',1);
xlabel('time (ns)','FontSize',16);ylabel('Normalized intensity','FontSize',16);
hold on;
I=(1/2*c*ele_c).*abs(E_S_out(:,nx/2,ny/2).^2);
plot(t*1e9,I/max(I),'r-.','LineWidth',1);
legend('Initial_E_P','Initial_E_S');

%���ֹ⡢�źŹ��ʼ����

Is=(1/2*c*S_R_index(num/2)*ele_c).*E_S_out.*conj(E_S_out);
Ip=(1/2*c*P_R_index*ele_c).*E_P_out.*conj(E_P_out);
S_En=trapz(y,squeeze(trapz(x,squeeze(trapz(t,Is,1)),1)))*1000;
P_En=trapz(y,squeeze(trapz(x,squeeze(trapz(t,Ip,1)),1)))*1000;
%----------------------------------------------------

%% �����񣭿��������㲨����Z�ᴫ���ı仯
%--------------------------------------------------------------------------
zz(1)=z1;
h=(z2-z1)/nstep;
z=z1+h;
for k=1:1:nstep    
%     if z>3e-2
%        P_angle=-0.42*pi/180;
%        S_angle=0.5*pi/180;
%        I_angle(:)= -asin(S_R_index.*I_wavelength./I_R_index./S_wavelength*sin(S_angle));
%     end
    for j=1:1:num
        %��һ����������ЧӦ��Ӱ��
        %------------------------------------------------------------------
        %���и���Ҷ�任
        E_S_xy=squeeze(E_S_out(j,:,:));
        E_I_xy=squeeze(E_I_out(j,:,:));
        E_P_xy=squeeze(E_P_out(j,:,:));
        
        [E_S_xy,fx,fy]=xy_fft(E_S_xy,x,y);
        [E_I_xy,fx,fy]=xy_fft(E_I_xy,x,y);
        [E_P_xy,fx,fy]=xy_fft(E_P_xy,x,y);
        [FX,FY]=meshgrid(fx,fy); 
        
        E_S_xy = E_S_xy.*exp(((S_angle*i*2*pi)*FY-1/2*a_S)*h).*exp(-i*pi*S_wavelength(num/2)/S_R_index(num/2)*(FX.^2+FY.^2)*h);      
        E_I_xy = E_I_xy.*exp(((I_angle(num/2)*i*2*pi)*FY-1/2*a_I)*h).*exp(-i*pi*I_wavelength(num/2)/I_R_index(num/2)*(FX.^2+FY.^2)*h);     
        E_P_xy = E_P_xy.*exp(((P_angle*i*2*pi)*FY-1/2*a_P)*h).*exp(-i*pi*P_wavelength/P_R_index*(FX.^2+FY.^2)*h);
        %���и���Ҷ��任
        E_S_xy=xy_ifft(E_S_xy,x,y);
        E_I_xy=xy_ifft(E_I_xy,x,y);
        E_P_xy=xy_ifft(E_P_xy,x,y);
        E_S_out(j,:,:)=E_S_xy(:,:);
        E_I_out(j,:,:)=E_I_xy(:,:);
        E_P_out(j,:,:)=E_P_xy(:,:);  
    end
        %----------------------------------------------------------------
        %�ڶ�������ɫɢ��Ӱ��
    
        dispersion=exp(i*0.5*beta2*omega.^2*h);

        E_S_outw=ifft(E_S_out,[],1).*dispersion;
        E_I_outw=ifft(E_I_out,[],1).*dispersion;
        E_P_outw=ifft(E_P_out,[],1).*dispersion;
        
        E_S_out=fft(E_S_outw);
        E_I_out=fft(E_S_outw
        E_p_out=fft(E_S_outw);
    
       %------------------------------------------------------------------
        %����������������ù���
        for j=1:num
        v=[E_S_out(j,:,:);E_I_out(j,:,:);E_P_out(j,:,:)]; 
        v=rk4(v,z,ny,h,P_w,S_w(j),I_w(j),K_con_wav(K_con,j),dk(j));
        E_S_out(j,:,:)=v(1,:,:);
        E_I_out(j,:,:)=v(2,:,:);
        E_P_out(j,:,:)=v(3,:,:);  
        end
    
    [bmx,bmy]=Beam_Quality(x,y,fx,fy,S_wavelength(num/2),E_P_out);
    Bmxz(k,:)=bmx;
    Bmyz(k,:)=bmy;
    
    E_S_am(k,:,:)=E_S_out(num/2,:,:);
    E_I_am(k,:,:)=E_I_out(num/2,:,:);
    E_P_am(k,:,:)=E_P_out(num/2,:,:);
    E_S_ph(k,:,:)=atan2(imag(E_S_out(num/2,:,:)),real(E_S_out(num/2,:,:)));
    E_I_ph(k,:,:)=atan2(imag(E_I_out(num/2,:,:)),real(E_I_out(num/2,:,:)));
    E_P_ph(k,:,:)=atan2(imag(E_P_out(num/2,:,:)),real(E_P_out(num/2,:,:)));
    %��¼�źŹ�������������ù��̵ı仯
    Is=(1/2*c*S_R_index(num/2)*ele_c).*E_S_out.*conj(E_S_out);
    Ip=(1/2*c*P_R_index*ele_c).*E_P_out.*conj(E_P_out);
    sum_Ep(k)=trapz(y,squeeze(trapz(x,squeeze(trapz(t,Ip,1)),1)))*1000;
    sum_Es(k)=trapz(y,squeeze(trapz(x,squeeze(trapz(t,Is,1)),1)))*1000;
    z=z+h;
    zz(k+1)=z; 
end
%% --------------------------------------------------------------------------
%�����Ŵ�������Ĵ��糡ǿ�ȵ�ʱ�䲨��
figure(1)
subplot(2,2,1)
I=(abs(E_S_out(:,nx/2,ny/2))).^2*(1/2*c*ele_c).*S_R_index(:);
plot(t*1e9,I/max(I),'b','LineWidth',1);
%����������Ĵ��糡ǿ����Z��ı仯
subplot(2,2,2)
plot(zz(1:nstep)*1000,sum_Es,'r','LineWidth',1)
xlabel('LBO Crystal Length��mm');ylabel('Output Energy:mJ');
hold on;
for lx=1:1:nx
    for ly=1:1:ny
        I_S=(abs(E_S_out(:,lx,ly))).^2*(1/2*c*ele_c).*S_R_index(:);
        Z(lx,ly)=trapz(t,I_S);
    end
end
Z=Z/max(max(Z));
%
subplot(2,2,3)
pcolor(x,y,Z);
colormap jet,shading interp;
colorbar;
title('ʱ����ֹ����״');
pha=imag(log(E_S_out(:,round(nx/2),round(ny/2))));
subplot(2,2,4)
plot(t*1e9,pha,'r');
title('Phase accumulated in OPA');
hold on
%�����������ú�ǰ�仯
figure(2)
subplot(2,2,1)
title('�ռ�ǿ�ȵ���');
mesh(X*1e3,Y*1e3,abs(Z));
hold on
subplot(2,2,2)
E(:,:)=E_S_ph(nstep,:,:);
mesh(X*1e3,Y*1e3,E.*W_F)
subplot(2,2,3)
E(:,:)=E_I_ph(nstep,:,:);
mesh(X*1e3,Y*1e3,E.*W_F)
subplot(2,2,4)
E(:,:)=E_P_ph(nstep,:,:);
mesh(X*1e3,Y*1e3,E.*W_F)
% �����źų�
save('data\E_S_out.mat','E_S_out');

toc    
