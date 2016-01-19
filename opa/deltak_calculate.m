function deltak=deltak_calculate(alpha,theta,lambdas,lambdap,material,var);
%typeI ����λƥ��  ��λʧ��������
%1.���룺
%      alpha    �� �ǹ��߼нǣ���
%      theta    :��λƥ��ǣ���
%      lambdas:  �źŹⲨ������
%      lambdap�� ���ֹⲨ������
%      material: �������ƣ��ַ���
%      var:      Ԥ���ӿڣ�DKDPʱΪ����Ũ��
%2.�����
%      deltak:   ��λʧ����
% 2012-01-08 ������
%2013-01-16 �޸�
c=3e8;
diel=8.854e-12; 

alpha=alpha*pi/180;
theta=theta*pi/180;
lambdai=1./(1./lambdap-1./lambdas);

if nargin==5
    no_s=sellmeier(lambdas,material,'o');
ne_s=sellmeier(lambdas,material,'e');

no_i=sellmeier(lambdai,material,'o');
ne_i=sellmeier(lambdai,material,'e');

no_p=sellmeier(lambdap,material,'o');
ne_p=sellmeier(lambdap,material,'e');

elseif nargin==6;
    
no_s=ellmeier(lambdas,material,'o',var);
ne_s=sellmeier(lambdas,material,'e',var);

no_i=sellmeier(lambdai,material,'o',var);
ne_i=sellmeier(lambdai,material,'e',var);

no_p=sellmeier(lambdap,material,'o',var);
ne_p=sellmeier(lambdap,material,'e',var);

else
    errordlg('���������������','theta_calculate')
end



np=sqrt(1./(cos(theta).^2./no_p.^2+sin(theta).^2./ne_p.^2));%���ֹ�������
kp=2*pi.*np./lambdap;

ks=2*pi*no_s./lambdas;

kie=2*pi*no_i./lambdai;%�������غ�õ��Ĳ�ʸ,e��������energy
kip=sqrt(ks.^2+kp.^2-2*ks.*kp.*cos(alpha));%�ɶ����غ�õ��Ĳ�ʸ,p������

deltak=kip-kie;

