function theta=theta_calculate(alpha,lambdas,lambdap,material,var);
%% ������λƥ��Ƕ�
%1.���룺
%      material���������ƣ��ַ���
%      alpha��    �ǹ��߽ǣ���λ���Ƕ�
%      lambdas: �źŹ����Ĳ�������λ����
%      lambdap:���ֹ����Ĳ�������λ����
%      var:     Ԥ���ӿڣ�DKDPʱ�ǲ���Ũ�ȣ��ٷ���
%2.�����
%      theta����λƥ���
%2012-11-01 ������
%2013-01-09 �޸�
%2013-01-16 �޸�
c=3e8;
alpha=alpha*pi/180;
lambdai=1./(1./lambdap-1./lambdas);



if nargin==4
    no_s=sellmeier(lambdas,material,'o');
ne_s=sellmeier(lambdas,material,'e');

no_i=sellmeier(lambdai,material,'o');
ne_i=sellmeier(lambdai,material,'e');

no_p=sellmeier(lambdap,material,'o');
ne_p=sellmeier(lambdap,material,'e');

elseif nargin==5;
    
    no_s=sellmeier(lambdas,material,'o',var);
ne_s=sellmeier(lambdas,material,'e',var);

no_i=sellmeier(lambdai,material,'o',var);
ne_i=sellmeier(lambdai,material,'e',var);

no_p=sellmeier(lambdap,material,'o',var);
ne_p=sellmeier(lambdap,material,'e',var);

else
    errordlg('���������������','theta_calculate')
end


ks=2*pi*no_s./lambdas;
ki=2*pi*no_i./lambdai;
gamma=asin(ks./ki.*sin(alpha));
kp=ks.*cos(alpha)+ki.*cos(gamma);
sintheta=ne_p./kp.*sqrt(((2*pi./lambdap).^2.*no_p.^2-kp.^2)./(no_p.^2-ne_p.^2));
theta=asin(sintheta);
theta=theta*180/pi;




