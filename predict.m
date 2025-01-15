%% 初始化参数
clear;
load mor_test.mat
clc;
go=[mor_test(:,3) mor_test(:,2) mor_test(:,1)];
%arr=readmatrix('晚高峰.xlsx','Sheet','到达');
cgo=zeros(1,3);
%carr=zeros(1,3);
%% 读取两点的坐标并删除离群值(经度在前，纬度在后)
ego=rmoutliers(go);
%earr=rmoutliers(arr);
lego=length(ego);
%learr=length(earr);

for i=1:10
%% 聚类分析
[idx,vgo]=kmeans(ego,2000);
lvgo=length(vgo);
xvgo=vgo(:,1);
yvgo=vgo(:,2);
%{
[idy,varr]=kmeans(earr,2000);
lvarr=length(varr);
xvarr=varr(:,1);
yvarr=varr(:,2);
%}

%% 计算每一类的热力值，选出前10位热门中心
for i=1:lego
    vgo(idx(i),3)=vgo(idx(i),3)+ego(i,3);
end
%{
for i=1:learr
    varr(idy(i),3)=varr(idy(i),3)+earr(i,3);
end
%}

vgo=sortrows(vgo,3,"descend");
vgo=vgo(1:10,:);
cgo=[cgo
     vgo];

%{
varr=sortrows(varr,3,"descend");
varr=varr(1:10,:);
carr=[carr
      varr];
%}
end

%% 第二层聚类
clc
cgo=cgo(1:100,1:2);
%carr=carr(1:100,1:2);
[idgo]=dbscan(cgo,0.025,3);%调整参数以使idgomax=10
%[idarr]=dbscan(carr,0.01,3);%调整参数以使idarrmax=10
idgomax=max(idgo);
%idarrmax=max(idarr);
centergo=zeros(idgomax,2);
%centerarr=zeros(idarrmax,2);
for i=1:idgomax
    for j=1:100
        if idgo(j)==i
            if centergo(i,:)==[0 0]
                centergo(i,:)=cgo(j,:);
            else
                centergo(i,:)=(centergo(i,:)+cgo(j,:))/2;
            end
        end
    end
end
%{
for i=1:idarrmax
    for j=1:100
        if idarr(j)==i
        if centerarr(i,:)==[0 0]
            centerarr(i,:)=carr(j,:);
        else
            centerarr(i,:)=(centerarr(i,:)+carr(j,:))/2;
        end
        end
    end
end
%}

xgo=centergo(:,1);
ygo=centergo(:,2);
%xarr=centerarr(:,1);
%yarr=centerarr(:,2);
geoscatter(ygo,xgo,'red');
hold on
%geoscatter(yarr,xarr,'blue');
legend('出发')
hold on
title('test集 早高峰热门出发地');

