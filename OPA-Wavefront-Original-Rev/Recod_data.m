function [E_S_am,E_I_am,E_P_am,E_S_ph,E_I_ph,E_P_ph,sum_Ep,sum_Es]=Recod_data(E_S_out,E_I_out,E_P_out,num,x,y,t,t0)
% ��¼��λ�������洫������ı仯
% k ����z������
% num ʱ��ȡ������
% E_S_out��E_I_out��E_P_out ����k��Ӧ���봦��������ĵ糡
% E_S_am,E_I_am,E_P_am  ����k��Ӧ���봦��������ĵ糡���м�ʱ�������ĸ����
% E_S_ph��E_I_ph��E_P_ph ����k��Ӧ���봦��������λ
% sum_Ep��sum_Es ����k��Ӧ���봦p���s�������
    const_LBO;
    
    E_S_am=E_S_out(num/2,:,:);
    E_I_am=E_I_out(num/2,:,:);
    E_P_am=E_P_out(num/2,:,:);
    E_S_ph=atan2(imag(E_S_out(num/2,:,:)),real(E_S_out(num/2,:,:)));
    E_I_ph=atan2(imag(E_I_out(num/2,:,:)),real(E_I_out(num/2,:,:)));
    E_P_ph=atan2(imag(E_P_out(num/2,:,:)),real(E_P_out(num/2,:,:)));
    %��¼�źŹ�������������ù��̵ı仯
    Is=(1/2*c*S_R_index(num/2)*ele_c).*E_S_out.*conj(E_S_out);
    Ip=(1/2*c*P_R_index*ele_c).*E_P_out.*conj(E_P_out);
    sum_Ep=trapz(y,squeeze(trapz(x,squeeze(trapz(t,Ip,1)),1)))*1000;
    sum_Es=trapz(y,squeeze(trapz(x,squeeze(trapz(t,Is,1)),1)))*1000;
    