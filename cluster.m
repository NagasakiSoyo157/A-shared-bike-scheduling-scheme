%% 初始化参数
clear;
clc;
go=readmatrix('早高峰.xlsx','Sheet','出发');%导入您的数据，如果只包
% 含一组出发或到达的数据，请在arr类变量前全部加上注释符号
arr=readmatrix('早高峰.xlsx','Sheet','到达');
c=zeros(1,3);

%% 读取两点的坐标并删除离群值(经度在前，纬度在后)
ego=rmoutliers(go);
earr=rmoutliers(arr);
lego=length(ego);
learr=length(earr);

for i=1:20
    disp(i)%展示循环进度到第i次

%% 第一层聚类
[idx,vgo]=kmeans(ego,2000);
lvgo=length(vgo);
xvgo=vgo(:,1);
yvgo=vgo(:,2);
[idy,varr]=kmeans(earr,2000);
lvarr=length(varr);
xvarr=varr(:,1);
yvarr=varr(:,2);

%% 计算每一类的热力值，选出前10位热门中心
for i=1:lego
    vgo(idx(i),3)=vgo(idx(i),3)+ego(i,3);
end

for i=1:learr
    varr(idy(i),3)=varr(idy(i),3)+earr(i,3);
end

v=[vgo
   varr];
v=sortrows(v,3,"descend");
v=v(1:10,:);
c=[c
   v];%如果要将出发与到达分开展示，请将v，c复制，并分别命名为go和arr类变量

end

%% 第二层聚类
% 在第一层聚类的大循环执行完后，您只需要对本小节不断运行以调试，无需全局debug
clc
c=c(1:200,1:2);
[id]=dbscan(c,0.01412,3);%调整参数以使idmax=10，扩大第二个参数会使idmax减少
% ，缩小会使其增大，使用二分法或可以使其接近10
idmax=max(id);%第二层聚类数
center=zeros(idmax,2);
for i=1:idmax
    for j=1:200
        if id(j)==i
            if center(i,:)==[0 0]
                center(i,:)=c(j,:);
            else
                center(i,:)=(center(i,:)+c(j,:))/2;
            end
        end
    end
end

x=center(:,1);
y=center(:,2);
geoscatter(y,x,'blue');
hold on
%如果您将到达和出发分别输出，请使用不同颜色，并用legend函数加以标注
title('早高峰热门中心');
