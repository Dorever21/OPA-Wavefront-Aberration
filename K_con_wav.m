function [ K_conwav] = K_con_wav( K_con,j)
%K_CON_wav �������������������������Ĳ�����ָ������ʱ��ȡֵ[zzx]
%   K_conΪԪ������ 
%   K_con{1}ΪS�������������沨���ı仯
%   K_con{2}ΪI�������������沨���ı仯
%   K_con{3}ΪP�������������沨���ı仯
%   i ����������
%   j ����������
%   size(K_con(j),2)==1 OR numel(t)

 
for i=1:numel(K_con)
    if size(K_con{i},2)==1
        K_conwav(i)=K_con{i};
    else
        temp_K_con=K_con{i};
        K_conwav(i)=temp_K_con(j);
        end
    end
end

