%INT
%SCD
clear;clc;
SCD= readmatrix('/home/weissley/桌面/400p/INT/tau/SCD/sub-9005_tau.csv');
SCD=SCD(1:400,:);
labeling = load_parcellation('schaefer',400);
labeling = labeling.schaefer_400;
[surf_lh, surf_rh] = load_conte69('inflated');
load('vikO.mat');
%NC
NC= readmatrix('/home/weissley/桌面/400p/INT/tau/NC/sub-9004_tau.csv');
NC=NC(1:400,:);
h1=plot_hemispheres([SCD(:,4),NC(:,4)],{surf_lh,surf_rh}, ...
             'parcellation', labeling, ...
             'labeltext',{'SCD tau','NC tau'});
colormap(h1.handles.figure,[.4 .4 .4 ;vikO]);
%1-31, 201-230 visual