%LBO���峣��
global c;%����
global ele_c;%ele_c=8.854187817e-12��յ�����
global P_wavelength;%���ֹⲨ��
global S_wavelength;%�źŹⲨ��
global I_wavelength;%���ùⲨ��
global P_R_index;%���ֹ�������
global I_R_index;%���ù�������
global P_O_index;%Ѱ����������
global P_E_index;%�쳣��������
global S_angle;%�źŹ�����ֹ�н�
global P_angle;%˫���������
global a_S;%�źŹ�����ϵ��
global a_P; %���ֹ�����ϵ��
global a_I; %���ù�����ϵ��
%����
%---------------------------------------------------------------------------------------------
c=2.99792e+8;
ele_c=8.8541e-12;%��յ�����
P_wavelength=532e-9;        %���ֹⲨ��
wvl =6.5e-9;    %���װ뼫��ȫ���:m
S_wavelength=1./(1/1053e-9+wvl*t/(t0*(1053e-9)^2));      %�źŹⲨ��
P_w=2*pi*c/P_wavelength;    %���ֹ�Ƶ��
S_w=2*pi*c./S_wavelength;    %�źŹ�Ƶ��
I_w=P_w-S_w;                %���ù�Ƶ��
I_wavelength=2*pi*c./I_w;    %���ùⲨ�� 
S_R_index=sqrt(2.586179+0.013099./((S_wavelength*1e+6).^2-0.011893)-0.017968*(S_wavelength*1e+6).^2-(2.26e-4)*(S_wavelength*1e+6).^4);%�źŹ�������(�糡ǿ��ƫ����y��
I_R_index=sqrt(2.586179+0.013099./((I_wavelength*1e+6).^2-0.011893)-0.017968*(I_wavelength*1e+6).^2-(2.26e-4)*(I_wavelength*1e+6).^4);%���ù�������(�糡ǿ��ƫ����y��
P_X_index=sqrt(2.454140+0.011249/((P_wavelength*1e+6)^2-0.011350)-0.014591*(P_wavelength*1e+6)^2-6.60*1e-5*(P_wavelength*1e+6)^4);
P_Y_index=sqrt(2.539070+0.012711/((P_wavelength*1e+6)^2-0.012523)-0.018540*(P_wavelength*1e+6)^2-2.00*1e-4*(P_wavelength*1e+6)^4);
P_Z_index=sqrt(2.586179+0.017968/((P_wavelength*1e+6)^2-0.011893)-0.017968*(P_wavelength*1e+6)^2-2.26*1e-4*(P_wavelength*1e+6)^4);
S_angle=-0.5*pi/180;         %���ֹ����źŹⲨʸ�н�
P_angle=0.42*pi/180;
I_angle = -asin(S_R_index.*I_wavelength./I_R_index./S_wavelength*sin(S_angle));         %���ֹ������ùⲨʸ�н�
P_R_index=(S_R_index(num/2)./S_wavelength(num/2)*cos(S_angle)+I_R_index(num/2)./I_wavelength(num/2).*cos(I_angle(num/2)))*P_wavelength;
angle=acos(sqrt((1/P_X_index^2-1/P_R_index^2)/(1/P_X_index^2-1/P_Y_index^2)));
P_R_index=(S_R_index(num/2)./S_wavelength(num/2)*cos(S_angle)+I_R_index(num/2)./I_wavelength(num/2).*cos(I_angle(num/2)))*P_wavelength;
d_eff=0.98e-12*cos(angle); %�������̣���Ч������ϵ��
K_con=S_w./sqrt(P_R_index.*S_R_index.*I_R_index)/c.*d_eff;
%-------------------------------------------------------------------------------------------------   
a_S=0.1; %�źŹ�����ϵ��
a_P=0.1; %���ֹ�����ϵ��
a_I=0.1; %���ù�����ϵ��
dk=2*pi*(P_R_index/P_wavelength-S_R_index./S_wavelength*cos(S_angle)-I_R_index./I_wavelength.*cos(I_angle));
% plot(t,dk);hold on