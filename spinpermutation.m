clear;clc;
G1=readmatrix('C:\Users\tangw\Desktop\400p\gradient\Gradient1.csv');
INT=readmatrix('C:\Users\tangw\Desktop\400p\INT\tau\tau.csv');
labeling = load_parcellation('schaefer',400);
labeling = labeling.schaefer_400;
[surf_lh, surf_rh] = load_conte69('inflated');
[sphere_lh, sphere_rh] = load_conte69('spheres');%这里是球面投影，不是surface
rvalue=[];

for nrow=1:46
subjG1=G1(nrow+1,2:401)';
subjINT=INT(nrow+1,2:401)';
% 将数据在球面旋转打乱，看真实相关在随机相关里排多少
n_permutations = 1000; %1000次重取样
y_rand = spin_permutations({labeling(1:32492,1),labeling(32493:64984,1)}, ...
                  {sphere_lh,sphere_rh}, ...
                  n_permutations,'random_state',0);%旋转1000次
parcel_rotated=squeeze([y_rand{1}(:,1,:); y_rand{2}(:,1,:)]);
ExchangeLabel=zeros(64984,n_permutations);%没找到的归为0，在brainspace就是空皮质
G1_parcel_rotated=nan(400,n_permutations);
for perm=1:n_permutations
    for i=1:400
        OverlapElements = parcel_rotated(find(labeling(:,1)==i),perm);
        B = mode(OverlapElements);%找到重叠parcel的最多的label，重新赋值并计算相似性
        ExchangeLabel(find(parcel_rotated(:,perm)==B),perm)=i;%旋转后B与原来的label1覆盖最多，将B parcel赋值为label1，以此类推
        %目标是代替原位置的label参与相关性
        if B~=0
            G1_parcel_rotated(i,perm)=subjG1(B,1);
        end
    end
end
[r_origin, ~] = corr(subjINT,subjG1, ...
                'rows','pairwise','type','Pearson');
[r_rand,~] = corr(subjINT,G1_parcel_rotated, ...
            'rows','pairwise','type','Pearson');%以覆盖率最大的代表原始parcel，计算parcel级别相关性，拒绝过度效应
num=sum(r_origin<r_rand);%有多少随机数比原始相关值大
prctile_rank = mean(r_origin > r_rand);
significant = num/n_permutations;%是否显著
rvalue=[rvalue;[r_origin,fisherz(r_origin),significant]];
end

writematrix(rvalue,"C:\Users\tangw\Desktop\400p\rspintest.csv");