%INT
%SCD
clear;clc;
cd /home/weissley/桌面/timeseries/
SCD= readmatrix('INT_SCD.csv');
SCD=SCD(1:1000,:);
labeling = load_parcellation('schaefer',1000);
labeling = labeling.schaefer_1000;
[surf_lh, surf_rh] = load_conte69('inflated');
load('vikO.mat');
%clim([5 13]);
%NC
NC= readmatrix('INT_NC.csv');
NC=NC(1:1000,:);
h1=plot_hemispheres([SCD(:,3),NC(:,3)],{surf_lh,surf_rh}, ...
             'parcellation', labeling, ...
             'labeltext',{'SCD ACW_0','NC ACW_0'});
colormap(h1.handles.figure,[.7 .7 .7;vikO]);
%clim([5 13]);