function dk = d_k(alpha,theta,lamdas,lamdap,material,type)
%DK �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��



lamdai=1./(1./lamdap-1./lamdas);

switch type
    case 'ooe'
%         no_s=Sellmeier(lamdas,material,'o');
%         no_i=Sellmeier(lamdai,material,'o');
%         no_p=Sellmeier(lamdap,material,'o');
%         ne_p=Sellmeier(lamdap,material,'e');
no_s=sellmeier(lamdas,material,'o');
ne_s=sellmeier(lamdas,material,'e');

no_i=sellmeier(lamdai,material,'o');
ne_i=sellmeier(lamdai,material,'e');

no_p=sellmeier(lamdap,material,'o');
ne_p=sellmeier(lamdap,material,'e');
np=sqrt(1./(cosd(theta).^2./no_p.^2+sind(theta).^2./ne_p.^2));%���ֹ�������

        kp=2*pi*np./lamdap;
        ks=2*pi*no_s./lamdas;
        kie=2*pi*no_i./lamdai;%�������غ�õ��Ĳ�ʸ
        
        kip=sqrt(ks.^2+kp.^2-2*ks.*kp.*cosd(alpha));%�ɶ����غ�õ��Ĳ�ʿ
        dk=kip-kie;

% kp=2*pi.*np./lamdap;
% 
% ks=2*pi*no_s./lamdas;
% 
% kie=2*pi*no_i./lamdai;%�������غ�õ��Ĳ�ʸ,e��������energy
% kip=sqrt(ks.^2+kp.^2-2*ks.*kp.*cosd(alpha));%�ɶ����غ�õ��Ĳ�ʸ,p������
% dk=kip-kie;




    case 'oee'
        no_s=sellmeier(lamdas,material,'o');
        ne_it=sellmeier(lamdai,material,'t',theta);
        ne_pt=sellmeier(lamdap,material,'t',theta);
        
        kp=2*pi*ne_pt./lamdap;
        ks=2*pi*no_s./lamdas;
        
        kie=2*pi*ne_it./lamdai;
%         [delta_ip1,delta_sp1,alpha]=gvm_delta(N,lamdas,lamdap,theta,material,type);
        kip=sqrt(ks.^2+kp.^2-2*ks.*kp.*cosd(alpha));
        dk=kip-kie;        
        
        
        
    case 'eoe'
        ne_st=sellmeier(lamdas,material,'t',theta);
        no_i=sellmeier(lamdai,material,'o');
        ne_pt=sellmeier(lamdap,material,'t',theta);
        
        kp=2*pi*ne_pt./lamdap;
        ks=2*pi*ne_st./lamdas;
        
        kie=2*pi*no_i./lamdai;
%         [delta_ip1,delta_sp1,alpha]=gvm_delta(N,lamdas,lamdap,theta,material,type);
        kip=sqrt(ks.^2+kp.^2-2*ks.*kp.*cosd(alpha));
        dk=kip-kie;        
        
        
end

















end

