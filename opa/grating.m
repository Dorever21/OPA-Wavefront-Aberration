lambda=500e-9;     %�趨��������Lambda��ʾ����
d=3e-6;            %�趨��դ��������d��ʾ��դ����
a=1e-6;            %�趨�����d��ʾ���
f=0.64;            %�趨���࣬��f��ʾ����
warning off MATLAB:divideByZero
N=4;              %�趨��������N��ʾ����
ym=2*lambda*f/a;   %�趨y����ķ�Χ
xs=ym;            %�趨x����ķ�Χ
n=1001;
ys=linspace(-ym,ym,n);
%�����Բ���������һ��һά����ys��n�Ǵ˴β������ܵ��� 
%�����ķ�Χ��-ymax��ymax����������������Ϊys 
%������װ������Ļ�ϵĲ������������ 
for i=1:n           %����Ļ�ϵ�ȫ�������ѭ�����㣬��Ҫ����n�μ���
  sinphi=ys(i)/f;  %���¼��н��й�ǿ�ļ���
  alpha=pi*a*sinphi/lambda;
  beta=pi*d*sinphi/lambda;
  B(i)=(sin(alpha)./alpha).^2.*(sin(N*beta)./sin(beta)).^2;
  B1=B/max(B);
end
NC=255;           %ȷ��ʹ�õĻҶȵȼ�Ϊ255��
Br=(B/max(B))*NC;  %���꣺ʹ����ǿ��Ӧ�����Ҷȼ�����ɫ��
subplot(2,1,1);       %ѡ�е�һ����������
cla;                %�������ͼ��
image(xs,ys,Br);      %��image��ͼ��������ͼ��
colormap(gray(NC));  %�ûҶȼ���ɫͼ����ɫͼ������
title('��դ��������');        %ȡ��Ϊ��դ��������
subplot(2,1,2);       %ѡ�еڶ�����������
cla;
plot(ys,B1);         %��plot������������
title('��դ��������');       %ȡ��Ϊ��դ��������
