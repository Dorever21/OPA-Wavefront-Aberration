function [ K_conwav] = K_con_wav( K_con )
%K_CON_wav �������������������������Ĳ�����ָ������ʱ��ȡֵ[zzx]
%   K_conΪԪ������ 
%   K_con{1}ΪS�������������沨���ı仯
%   K_con{2}ΪI�������������沨���ı仯
%   K_con{3}ΪP�������������沨���ı仯
%   size(K_con(j),2)==1 OR numel(t)
for j=1:numel(K_con)
    if size(K_con{j},2)==1
        K_conwav(j)=K_con{j};
    else
        temp_K_con=K_con{j};
        idx=numel(temp_K_con)/2;
        if(idx~=0)
            idx=ceil(idx);
        K_conwav(j)=temp_K_con(idx);
        else
        K_conwav(j)=mean([temp_K_con(idx),temp_K_con(idx+1)]);
        end
    end
end

