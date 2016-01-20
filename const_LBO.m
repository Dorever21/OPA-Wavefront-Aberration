%LBO���峣��
global c;%����
global ele_c;%ele_c=8.854187817e-12��յ�����
global P_wavelength;%���ֹⲨ��
global S_wavelength;%�źŹⲨ��
global I_wavelength;%���ùⲨ��
global P_R_index;%���ֹ�������
global S_R_index;%�źŹ�������[zzx]
global I_R_index;%���ù�������
global P_O_index;%Ѱ����������
global P_E_index;%�쳣��������
global S_angle;%�źŹ�����ֹ�н�
global P_angle;%˫���������
global a_S;%�źŹ�����ϵ��
global a_P; %���ֹ�����ϵ��
global a_I; %���ù�����ϵ��
global wvl; %���װ뼫��ȫ���:m
global K_con0; %���Ĳ�������������
global K_con; %��ͬ������������
global Vg; %�洢Ⱥ�ٶ�
global Cd; %�洢����ʱ��Ƶ��������ɫɢ�Ĳ���
%����
%---------------------------------------------------------------------------------------------
%2 ��������
c=2.99792e+8;
ele_c=8.8541e-12;%��յ�����

% %
% %������Ƶ�����Ĳ���
P_wavelength0=P_wavelength;
P_w0=2*pi*c/P_wavelength0;    %���ֹ�����Ƶ��
S_w0=2*pi*c/S_wavelength0;    %�źŹ�����Ƶ��
I_w0=P_w0-S_w0;              %���ù�����Ƶ��
I_wavelength0=2*pi*c/I_w0;   %���ù����Ĳ��� 

% 
% lambda0
% deltav=0.5/duration;
% deltalambdainv=deltav/3e8;
% wvl=lambda0^2*deltalambdainv;
% wvl =6.5e-9;    %���װ뼫��ȫ���:m

tao_gs=tao_ps./sqrt(2*log(2));
S_w=S_w0-2*chirp_s.*t/tao_gs^2;     %�źŹ�Ƶ��

S_wavelength=2*pi*c./S_w;
P_w=2*pi*c/P_wavelength;    %���ֹ�Ƶ�� 
I_w=P_w-S_w;                %���ù�Ƶ��
I_wavelength=2*pi*c./I_w;    %���ùⲨ�� 
S_R_index=sqrt(2.586179+0.013099./((S_wavelength*1e+6).^2-0.011893)-0.017968*(S_wavelength*1e+6).^2-(2.26e-4)*(S_wavelength*1e+6).^4);%�źŹ�������(�糡ǿ��ƫ����y��
I_R_index=sqrt(2.586179+0.013099./((I_wavelength*1e+6).^2-0.011893)-0.017968*(I_wavelength*1e+6).^2-(2.26e-4)*(I_wavelength*1e+6).^4);%���ù�������(�糡ǿ��ƫ����y��
P_X_index=sqrt(2.454140+0.011249/((P_wavelength*1e+6)^2-0.011350)-0.014591*(P_wavelength*1e+6)^2-6.60*1e-5*(P_wavelength*1e+6)^4);
P_Y_index=sqrt(2.539070+0.012711/((P_wavelength*1e+6)^2-0.012523)-0.018540*(P_wavelength*1e+6)^2-2.00*1e-4*(P_wavelength*1e+6)^4);
P_Z_index=sqrt(2.586179+0.017968/((P_wavelength*1e+6)^2-0.011893)-0.017968*(P_wavelength*1e+6)^2-2.26*1e-4*(P_wavelength*1e+6)^4);
S_angle=-0.5*pi/180;         %���ֹ����źŹⲨʸ�н�
P_angle=0.42*pi/180;          %[zzx]�źŹ������ùⲨʸ�н�
I_angle = -asin(S_R_index.*I_wavelength./I_R_index./S_wavelength*sin(S_angle));         %���ֹ������ùⲨʸ�н�
%-------------------------------------------------------------------------------------------------   
a_S=0.1; %�źŹ�����ϵ��
a_P=0.1; %���ֹ�����ϵ��
a_I=0.1; %���ù�����ϵ��

Rt=1+1e-6;  %����������ʸ����ʱ�����仯�Ĳ���
            %DeltaWavelength=Rt*Wavelength0-Wavelength0
%------����������Ƶ�ʴ���������--------%
S_R_index0=sqrt(2.586179+0.013099./((S_wavelength0*1e+6).^2-0.011893)-0.017968*(S_wavelength0*1e+6).^2-(2.26e-4)*(S_wavelength0*1e+6).^4);%�źŹ�������Ƶ�ʴ�������(�糡ǿ��ƫ����y��
I_R_index0=sqrt(2.586179+0.013099./((I_wavelength0*1e+6).^2-0.011893)-0.017968*(I_wavelength0*1e+6).^2-(2.26e-4)*(I_wavelength0*1e+6).^4);%���ù�������Ƶ�ʴ�������(�糡ǿ��ƫ����y��
S_angle0=S_angle;
I_angle0 = -asin(S_R_index0*I_wavelength0/I_R_index0/S_wavelength0*sin(S_angle0)); %����Ƶ�ʴ����ֹ�����Ƶ�Ⲩʸ�н�
P_R_index0=(S_R_index0./S_wavelength0*cos(S_angle)+I_R_index0./I_wavelength0.*cos(I_angle0))*P_wavelength0;%���ֹ�������Ƶ�ʴ�������
%------�����ڲ����仯һ��С�����ӦƵ�ʴ���������--------%
S_R_index_step=sqrt(2.586179+0.013099./((Rt*S_wavelength0*1e+6).^2-0.011893)-0.017968*(Rt*S_wavelength0*1e+6).^2-(2.26e-4)*(Rt*S_wavelength0*1e+6).^4);%�źŹ�����΢ƫ������Ƶ�ʴ�������(�糡ǿ��ƫ����y��
I_R_index_step=sqrt(2.586179+0.013099./((Rt*I_wavelength0*1e+6).^2-0.011893)-0.017968*(Rt*I_wavelength0*1e+6).^2-(2.26e-4)*(Rt*I_wavelength0*1e+6).^4);%���ù�����΢ƫ������Ƶ�ʴ�������(�糡ǿ��ƫ����y��
I_angle0 = -asin(S_R_index_step*Rt*I_wavelength0/I_R_index_step/(Rt*S_wavelength0)*sin(S_angle0)); %��΢ƫ������Ƶ�ʴ����ֹ�����Ƶ�Ⲩʸ�н�
P_R_index_step=(S_R_index_step./(Rt*S_wavelength0)*cos(S_angle0)+I_R_index_step./(Rt*I_wavelength0).*cos(I_angle0))*Rt*P_wavelength0;%���ֹ�����΢ƫ������Ƶ�ʴ�������

%--------�����������Ĳ��������Ե�Ⱥ�ٶ�--------------%
dks=2*pi*S_R_index_step/(Rt*S_wavelength0)-2*pi*S_R_index0/S_wavelength0;
dws=2*pi*c/(S_R_index_step*Rt*S_wavelength0)-2*pi*c/(S_R_index0*S_wavelength0);
Vgs=1/(dks/dws);
dki=2*pi*I_R_index_step/(Rt*I_wavelength0)-2*pi*I_R_index0/I_wavelength0;
dwi=2*pi*c/(I_R_index_step*Rt*I_wavelength0)-2*pi*c/(I_R_index0*I_wavelength0);
Vgi=1/(dki/dwi);
dkp=2*pi*P_R_index_step/(Rt*P_wavelength0)-2*pi*P_R_index0/P_wavelength0;
dwp=2*pi*c/(P_R_index_step*Rt*P_wavelength0)-2*pi*c/(P_R_index0*P_wavelength0);
Vgp=1/(dkp/dwp);
Vg=[Vgs;Vgi;Vgp];

%�Ա��ֹ��Ⱥ�ٶ�Ϊ�ο����в�����任��������������ʱ��Ƶ�������ƵĲ���
Cd=[1/Vgs-1/(cos(S_angle0)*Vgs);
    1/Vgs-1/(cos(I_angle0)*Vgi);    
    1/Vgs-1/Vgp];
% plot(t,dk);hold on
P_R_index=(S_R_index0./S_wavelength0*cos(S_angle)+I_R_index0./I_wavelength0.*cos(I_angle0))*P_wavelength;
angle=acos(sqrt((1/P_X_index^2-1/P_R_index^2)/(1/P_X_index^2-1/P_Y_index^2)));
d_eff=0.98e-12*cos(angle); %�������̣���Ч������ϵ��


% 
% K_con_S0=S_w0*d_eff/(c*S_R_index0.*cos(S_angle0));
% K_con_I0=I_w0*d_eff/(c*I_R_index0.*cos(I_angle0));
% K_con_P0=P_w0*d_eff/(c*P_R_index0);
% K_con0=[K_con_S0;K_con_I0;K_con_P0];

%-------------------------------------------------%

%����������������������еĲ���[zzx]
K_con_S=S_w*d_eff./(c*S_R_index.*cos(S_angle));
K_con_I=I_w*d_eff./(c*I_R_index.*cos(I_angle));
K_con_P=P_w*d_eff./(c*P_R_index);
K_con={K_con_S;K_con_I;K_con_P};
dk=2*pi*(P_R_index/P_wavelength-S_R_index./S_wavelength*cos(S_angle)-I_R_index./I_wavelength.*cos(I_angle));