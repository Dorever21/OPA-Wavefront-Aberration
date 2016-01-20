% function main
tic
clear all;
%������ʼֵ����
%----------------------------------------------  
% 1��ʼ��

crstl_L=45.5e-3;             %���峤��:m
z1=0;                        %�������
z2=crstl_L;                  %�����յ�:m
s=2;                         %���ڿ������


Dias=2e-3;                   %�źŹ�ά��
Diap=2e-3;                   %�źŹ�ά��
mts=1;                        %�źŹ�ʱ��ֲ�����
mtp=5;                        %���ֹ�ʱ��ֲ�����
mxys=5;                      %�źŹ�ռ�ֲ�����
mxyp=5;                      %���ֹ�ռ�ֲ�����     
P_wavelength=532e-9;         %���ֹⲨ��
S_wavelength0=1053e-9;       %[zzx]�źŹ����Ĳ���


nstep=round(2e3*crstl_L);    %z�����ֲ�������
h=crstl_L/nstep;

nt=1024*4.5;          %FFT ��ʹ��ڳߴ�

% 4��ʼ������ 
tao_ftl=30*1e-15;            %���ӹ�ʱ�� FWHM     
tao_ps=400*1e-12;            %չ���ʱ�� FWHM   
tao_pp=1625*1e-12;           %���ֹ�ʱ�� FWHM
chirp_s=-sqrt((tao_ps/tao_ftl)^2-1);
chirp_p=0;
T=5*tao_pp;
dt=T/nt;
t=(-nt/2:nt/2-1)*dt;
omega=2*pi*(1/T)*[(0:nt/2-1) (-nt/2:-1)];%frequency grid
num=numel(t);                 %ʱ��ȡ������
nwav=50;                    %����ȡ������
nx=64;                      %x��ȡ������
ny=nx;                      %y��ȡ������
nvar=3;                      %�������̸���

%ȫ�ֱ���
%-----------------
 const_LBO;         
%----------------

% %��ʼ�糡ǿ��
E_P0=8.9e+7;   
E_S0=5.0e+3;
E_I0=0;

d0=max(Dias,Diap);                   
%---------------------------------------------------------------------------

dx=s*d0/nx;                 %x��ȡ���ֱ���
dy=dx;                      %y��ȡ���ֱ���
x=-s*d0/2:dx:s*d0/2-dx;     %x������
y=x;                        %y������ 


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
E_S_w=zeros(num,nx,ny);
E_I_w=zeros(num,nx,ny);
E_P_w=zeros(num,nx,ny);
E_S_xy=zeros(nx,ny);
E_I_xy=zeros(nx,ny);
E_P_xy=zeros(nx,ny);
E_S_w_dot=zeros(num,1);
E_I_w_dot=zeros(num,1);
E_P_w_dot=zeros(num,1);
S_dispersion=zeros(num,1);
I_dispersion=zeros(num,1);
P_dispersion=zeros(num,1);
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
% Exy_ph=wvf_Gn(x,y,8e-2);
% save('data\ph_abr2.mat','Exy_ph');
buf=load('data\ph_abr2.mat');
Exy_ph=buf.Exy_ph;
%-------------------------------------------------------------------------
W_F=exp(-(X.^2+Y.^2).^20/(1.3*d0/2/log(2)^(0.025))^40);
%�糡ǿ�ȸ���ֵ
%--------------------------------------------------------------------------
E_S_out=E_S0*pulsegenerator(x,y,t,tao_ps,Dias,mxys,mts,chirp_s);
E_P_out=E_P0*pulsegenerator(x,y,t,tao_pp,Diap,mxyp,mtp,chirp_p);%.*exp(i*0.6*Exy_ph);
%--------------------------------------------------------------------------

for k=1:num 
   E_P_out(k,:,:)=exp(j*0.6*Exy_ph).*squeeze(E_P_out(k,:,:));
end

%�����źŹ⡢���ù��ʼʱ�䲨��
figure;
mesh(x,y,squeeze(E_S_out(round(size(E_S_out,1)/2),:,:)).*conj(squeeze(E_S_out(round(size(E_S_out,1)/2),:,:))));


Is=(1/2*c*S_R_index0*ele_c)*(E_S_out.*conj(E_S_out));
Ii=(1/2*c*S_R_index0*ele_c)*(E_I_out.*conj(E_I_out));
Ip=(1/2*c*P_R_index0*ele_c)*(E_P_out.*conj(E_P_out));


h_spect=figure;
subplot(311);
plot(S_wavelength*1e9,Is(:,nx/2,ny/2)/max(Is(:,nx/2,ny/2)),'r');
axis([0.8*S_wavelength0*1e9 1.2*S_wavelength0*1e9 0 inf]);
xlabel('wavelength /nm');
ylabel('Normalized Power');
subplot(312);
plot(I_wavelength*1e9,Ii(:,nx/2,ny/2)/max(Ii(:,nx/2,ny/2)),'g');
axis([0.8*I_wavelength0*1e9 1.2*I_wavelength0*1e9 0 inf]);
xlabel('wavelength /nm');
ylabel('Normalized Power');
subplot(313);
plot(P_wavelength*1e9,Ip(:,nx/2,ny/2)/max(Ip(:,nx/2,ny/2)),'b');
axis([0.8*P_wavelength0*1e9 1.2*P_wavelength0*1e9 0 inf]);
xlabel('wavelength /nm');
ylabel('Normalized Power');
hold on;


h1=figure; 
subplot(2,2,1)

plot(t*1e9,Ip(:,nx/2,ny/2)/max(Ip(:,nx/2,ny/2)),'k-.','LineWidth',1);
xlabel('time (ns)','FontSize',16);ylabel('Normalized intensity','FontSize',16);
hold on;

plot(t*1e9,Is(:,nx/2,ny/2)/max(Is(:,nx/2,ny/2)),'r-.','LineWidth',1);
legend('Initial_E_P','Initial_E_S');

%���ֹ⡢�źŹ��ʼ����


S_En=trapz(y,squeeze(trapz(x,squeeze(trapz(t,Is,1)),1)))*1000;
P_En=trapz(y,squeeze(trapz(x,squeeze(trapz(t,Ip,1)),1)))*1000;
%----------------------------------------------------

%% �����񣭿��������㲨����Z�ᴫ���ı仯
%--------------------------------------------------------------------------
%scheme:1/2N->D->1/2N;first step nonlinear

dispersion=exp(Cd*(-i*omega)*h);
M=numel(x);N=numel(y);
matlabpool local 4  %����matlabpool �߳���

   parfor j=1:num
        v=[E_S_out(j,:,:);E_I_out(j,:,:);E_P_out(j,:,:)]; 
        v=rk4(v,0,h/2,P_w,S_w(j),I_w(j),K_con_wav(K_con,j),dk(j));
        E_S_out(j,:,:)=v(1,:,:);
        E_I_out(j,:,:)=v(2,:,:);
        E_P_out(j,:,:)=v(3,:,:);  
  end


zz(1)=z1;
z=z1+h;
for k=1:1:nstep    
%     if z>3e-2
%        P_angle=-0.42*pi/180;
%        S_angle=0.5*pi/180;
%        I_angle(:)= -asin(S_R_index.*I_wavelength./I_R_index./S_wavelength*sin(S_angle));
%     end

%----------------���пռ�Ƶ����任---------------%
    for j=1:1:num
        E_S_xy=squeeze(E_S_out(j,:,:));
        E_I_xy=squeeze(E_I_out(j,:,:));
        E_P_xy=squeeze(E_P_out(j,:,:));
        
        [E_S_xy,fx,fy]=xy_fft(E_S_xy,x,y);
        [E_I_xy,fx,fy]=xy_fft(E_I_xy,x,y);
        [E_P_xy,fx,fy]=xy_fft(E_P_xy,x,y);
        
        E_S_w(j,:,:)=E_S_xy(:,:);
        E_I_w(j,:,:)=E_I_xy(:,:);
        E_P_w(j,:,:)=E_P_xy(:,:);  
    end
          
  
%----------------����ʱ��Ƶ����任---------------%
        E_S_w=ifft(E_S_w,[],1);
        E_I_w=ifft(E_I_w,[],1);
        E_P_w=ifft(E_P_w,[],1);
        
       %--------����ɫɢӰ��----------% 
      
       parfor j=1:num;
        E_S_wxy=squeeze(E_S_w(j,:,:));
        E_I_wxy=squeeze(E_I_w(j,:,:));
        E_P_wxy=squeeze(E_P_w(j,:,:));
        
        E_S_wxy=E_S_wxy.*dispersion(1,j);
        E_I_wxy=E_I_wxy.*dispersion(2,j);
        E_P_wxy=E_P_wxy.*dispersion(3,j);
        
        E_S_w(j,:,:)=E_S_wxy;
        E_I_w(j,:,:)=E_I_wxy;
        E_P_w(j,:,:)=E_P_wxy;  
           
       end
      %--------�������������Ӱ��----------%    
        [FX,FY]=meshgrid(fx,fy); 
     parfor j=1:num 
        E_S_xy=squeeze(E_S_w(j,:,:));
        E_I_xy=squeeze(E_S_w(j,:,:));
        E_P_xy=squeeze(E_S_w(j,:,:));
        E_S_xy = E_S_xy.*exp(((S_angle*i*2*pi)*FY-1/2*a_S)*h/2).*exp(-i*pi*S_wavelength(num/2)/S_R_index(num/2)*(FX.^2+FY.^2)*h/2);      
        E_I_xy = E_I_xy.*exp(((I_angle(num/2)*i*2*pi)*FY-1/2*a_I)*h/2).*exp(-i*pi*I_wavelength(num/2)/I_R_index(num/2)*(FX.^2+FY.^2)*h/2);     
        E_P_xy = E_P_xy.*exp(((P_angle*i*2*pi)*FY-1/2*a_P)*h/2).*exp(-i*pi*P_wavelength/P_R_index*(FX.^2+FY.^2)*h/2);
        E_S_w(j,:,:)=E_S_xy(:,:);
        E_I_w(j,:,:)=E_I_xy(:,:);
        E_P_w(j,:,:)=E_P_xy(:,:);  
     end
     
 %----------------����ʱ��Ƶ���򷴱任---------------%        
        E_S_w=fft(E_S_w,[],1);
        E_I_w=fft(E_I_w,[],1);
        E_P_w=fft(E_P_w,[],1);

%----------------���пռ�Ƶ���򷴱任---------------%     
 parfor j=1:num
        E_S_xy=squeeze(E_S_w(j,:,:));
        E_I_xy=squeeze(E_I_w(j,:,:));
        E_P_xy=squeeze(E_P_w(j,:,:));
        
        E_S_xy=xy_ifft(E_S_xy,x,y);
        E_I_xy=xy_ifft(E_I_xy,x,y);
        E_P_xy=xy_ifft(E_P_xy,x,y);
        
        E_S_out(j,:,:)=E_S_xy(:,:);
        E_I_out(j,:,:)=E_I_xy(:,:);
        E_P_out(j,:,:)=E_P_xy(:,:);  
 end
       
    
       %------------------------------------------------------------------
        %����������������ù���
        parfor j=1:num
        v=[E_S_out(j,:,:);E_I_out(j,:,:);E_P_out(j,:,:)]; 
        v=rk4(v,z,h,P_w,S_w(j),I_w(j),K_con_wav(K_con,j),dk(j));
        E_S_out(j,:,:)=v(1,:,:);
        E_I_out(j,:,:)=v(2,:,:);
        E_P_out(j,:,:)=v(3,:,:);  
        end
    %��¼��λ�仯    
    E_S_am(k,:,:)=E_S_out(num/2,:,:);
    E_I_am(k,:,:)=E_I_out(num/2,:,:);
    E_P_am(k,:,:)=E_P_out(num/2,:,:);
    E_S_ph(k,:,:)=atan2(imag(E_S_out(num/2,:,:)),real(E_S_out(num/2,:,:)));
    E_I_ph(k,:,:)=atan2(imag(E_I_out(num/2,:,:)),real(E_I_out(num/2,:,:)));
    E_P_ph(k,:,:)=atan2(imag(E_P_out(num/2,:,:)),real(E_P_out(num/2,:,:)));
    %��¼�źŹ�������������ù��̵ı仯
    Is=(1/2*c*S_R_index0*ele_c)*(E_S_out.*conj(E_S_out));
    Ip=(1/2*c*P_R_index*ele_c)*(E_P_out.*conj(E_P_out));
    sum_Ep(k)=trapz(y,squeeze(trapz(x,squeeze(trapz(t,Ip,1)),1)))*1000;
    sum_Es(k)=trapz(y,squeeze(trapz(x,squeeze(trapz(t,Is,1)),1)))*1000;
    z=z+h;
    zz(k+1)=z; 
end

 parfor j=1:num
        v=[E_S_out(j,:,:);E_I_out(j,:,:);E_P_out(j,:,:)]; 
        v=rk4(v,z+h/2  nb,-h/2,P_w,S_w(j),I_w(j),K_con_wav(K_con,j),dk(j));
        E_S_out(j,:,:)=v(1,:,:);
        E_I_out(j,:,:)=v(2,:,:);
        E_P_out(j,:,:)=v(3,:,:);  
 end


%     [bmx,bmy]=Beam_Quality(x,y,fx,fy,S_wavelength(num/2),E_P_out);
%     Bmxz(k,:)=bmx;
%     Bmyz(k,:)=bmy;
    

matlabpool close
%% --------------------------------------------------------------------------
%�����Ŵ�������Ĵ��糡ǿ�ȵ�ʱ�䲨��
figure(h1)
subplot(2,2,1)
  
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
figure
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

Is=(1/2*c*S_R_index0*ele_c)*(E_S_out.*conj(E_S_out));
Ii=(1/2*c*S_R_index0*ele_c)*(E_I_out.*conj(E_I_out));
Ip=(1/2*c*P_R_index0*ele_c)*(E_P_out.*conj(E_P_out));


figure(h_spect);
subplot(311);
plot(S_wavelength*1e9,Is(:,nx/2,ny/2)/max(Is(:,nx/2,ny/2)),'r');
axis([0.8*S_wavelength0*1e9 1.2*S_wavelength0*1e9 0 inf]);
xlabel('wavelength /nm');
ylabel('Normalized Power');
subplot(312);
plot(I_wavelength*1e9,Ii(:,nx/2,ny/2)/max(Ii(:,nx/2,ny/2)),'g');
axis([0.8*I_wavelength0*1e9 1.2*I_wavelength0*1e9 0 inf]);
xlabel('wavelength /nm');
ylabel('Normalized Power');
subplot(313);
plot(P_wavelength*1e9,Ip(:,nx/2,ny/2)/max(Ip(:,nx/2,ny/2)),'b');
axis([0.8*P_wavelength0*1e9 1.2*P_wavelength0*1e9 0 inf]);
xlabel('wavelength /nm');
ylabel('Normalized Power');
hold on;

% �����źų�
save('data\E_S_out.mat','E_S_out');

toc    
