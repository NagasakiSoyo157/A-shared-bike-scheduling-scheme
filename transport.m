%% 数据初始化
clear
clc
close all
dis=readmatrix("dis1.xls");
we=readmatrix("we1.xls");
we=we';
dis=dis';
y=zeros(63,7);

s=4;%更改此参数以生成第s-3天的运输矩阵
%% 产量销量
c=sortrows([we(:,1) we(:,s)],2);
d=[0 0];%产地及其地址
e=[0 0];%销地及其地址
for i=1:16
    if c(i,2)>=0
        if d==[0 0]
            d=c(i,:);
        else
            d=[d
               c(i,:)];
        end
    else
        if e==[0 0]
            e=c(i,:);
        else
            e=[e
               c(i,:)];
        end
    end
end
ld=length(d);
le=length(e);

%% 运价表
g=[];
for i=1:ld
    for j=1:le
        g(i,j)=dis(d(i,1),e(j,1));
    end
end

%% 系数矩阵
m1=ld;
n1=le;
a=[];
for i=1:m1
a1=zeros(m1,n1);
a1(i,:)=ones(1,n1);
a=[a a1];
end
b1=[];
for i=1:m1
a10=eye(n1,n1);
b1=[b1 a10];
end
fin=[a;b1];

%% 求解线性规划
f=g(1,:);
for i=2:ld
    f=[f g(i,:)];
end

A=fin(1:ld,:);
b=d(:,2);
lb=zeros(le*ld);
Aeq=fin(ld+1:ld+le,:);
beq=-e(:,2);
ub=[];
x = linprog(f,A,b,Aeq,beq,lb,ub);
y=zeros(ld,le);
for i=1:ld
    for j=1:le
        y(i,j)=x((i-1)*le+j);
    end
end
y=[d(:,1) y];
y=[0 e(:,1)'
    y];
