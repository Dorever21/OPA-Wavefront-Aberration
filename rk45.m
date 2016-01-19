function  [Ats,Ati,Atp]=rk45(Ats,Ati,Atp,ws,wi,wp,ns,ni,np,dk,deff,z,dz)
c=3e8;

%RK45 �˳�����Ҫ���������,����һ����Ƭ���ڲ�ͬ���ʵĹ�֮������,���������µĹⳡ�ֲ�
%��һ��
dAts1=1i*dz*ws.*deff.*Atp.*conj(Ati).*exp(-1i*dk.*z)./(ns*c);
dAti1=1i*dz*wi.*deff.*Atp.*conj(Ats).*exp(-1i*dk.*z)./(ni*c);
dAtp1=1i*dz*wp.*deff.*Ats.*Ati.*exp(1i*dk.*z)./(np*c);
%�ڶ���
dAts2=1i*dz*ws.*deff.*(Atp+.5*dAtp1).*conj(Ati+.5*dAti1).*exp(-1i*dk.*(z+.5*dz))./(ns*c);
dAti2=1i*dz*wi.*deff.*(Atp+.5*dAtp1).*conj(Ats+.5*dAts1).*exp(-1i*dk.*(z+.5*dz))./(ni*c);
dAtp2=1i*dz*wp.*deff.*(Ats+.5*dAts1).*(Ati+.5*dAti1).*exp(1i*dk.*(z+.5*dz))./(np*c);
%������
dAts3=1i*dz*ws.*deff.*(Atp+.5*dAtp2).*conj(Ati+.5*dAti2).*exp(-1i*dk.*(z+.5*dz))./(ns*c);
dAti3=1i*dz*wi.*deff.*(Atp+.5*dAtp2).*conj(Ats+.5*dAts2).*exp(-1i*dk.*(z+.5*dz))./(ni*c);
dAtp3=1i*dz*wp.*deff.*(Ats+.5*dAts2).*(Ati+.5*dAti2).*exp(1i*dk.*(z+.5*dz))./(np*c);
%������
dAts4=1i*dz*ws.*deff.*(Atp+dAtp3).*conj(Ati+dAti3).*exp(-1i*dk.*(z+dz))./(ns*c);
dAti4=1i*dz*wi.*deff.*(Atp+dAtp3).*conj(Ats+dAts3).*exp(-1i*dk.*(z+dz))./(ni*c);
dAtp4=1i*dz*wp.*deff.*(Ats+dAts3).*(Ati+dAti3).*exp(1i*dk.*(z+dz))./(np*c);

%�ܵı仯��
dAts=(dAts1+2*dAts2+2*dAts3+dAts4)/6;
dAti=(dAti1+2*dAti2+2*dAti3+dAti4)/6;
dAtp=(dAtp1+2*dAtp2+2*dAtp3+dAtp4)/6;

%��������dz֮������
Ats=Ats+dAts;
Ati=Ati+dAti;
Atp=Atp+dAtp;
end

