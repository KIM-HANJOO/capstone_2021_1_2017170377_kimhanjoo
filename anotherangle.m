%clear all; 
clc; clf;

%% 외피의 각, 달(month), 계산할 일사량 범위

angle=70%도
month=9%월
starthour=6%시
lasthour=18%시

%% [2.2.1] modeling the path of sun & the plane of panel
t=angle*pi*1/180;
subplot(2,2,1);
ezplot3('-cos(t)','sin(t)*cos(pi*56/180)','sin(t)*sin(pi*56/180)',[0,pi]);
hold on;%태양의 궤적을 매개변수로 나타내기
[X,Y]=meshgrid(-1:.2:1);
tt=0;
Z=-tan(t)*Y; ZZ=-tan(tt)*Y;
s=surf(X,Y,Z,'FaceAlpha',0.2);%외피를 매개변수로 나타내기(pi*1/3)
ss=surf(X,Y,ZZ,'FaceAlpha',1);%땅 표현
axis([-1 1 -1 1 -1 1])
title('Sun Path & Tilted Panel')

%% [2.2.3] angle of incidence 입사각 그래프
y=inline('acos(sin(a)*sin(pi*56/180+t))','a','t');
%y가 입사각, 함수는 손으로 계산해 넣었습니다.
a=linspace(0,pi,100);
y1=round(y(a,t),2);  %이건 혹시몰라서, 입사각을 소숫점 두자리까지로 반올림
%disp(y1)

subplot(2,2,3);
plot(6 + a*12*1/pi,y(a,t)*180/pi,'o-');
axis([6 18 0 90]);
title('angle of incidence')
xlabel('time');
ylabel('incidence angle');
%disp(y(a,t))

%% [2.2.4] cubic spline angles
x=xlsread('incidences');%입사각 정보 불러오기
A=x(1,:);
i=month+1; %월수가 행렬의 2번째 열부터 등장하기 때문
B=x(i,:);
c=1/720;
xx=0:0.01:90;
yy=spline(A,B,xx); %표에 주어진 값들 사이를 3차 보간법으로 인터폴레이션 
subplot(2,2,4);
plot(A,c*B,'o',xx,c*yy)
axis([0 90 0 7*10^(-3)])
xlabel('incidence angle');
ylabel('solar radiation(kWh/m^2/m)');
title('table(splined)')

%% [2.2.2] 하루에 받는 태양복사에너지의 양을 시간순서로 나타내기
subplot(2,2,2)
aa = 0:1:180;
y12=myfunction(aa*pi*1/180,t);
y123=spline(A,B,y12*180*1/pi);
plot(6+aa*12/180,c*y123,'o-'); hold on;

axis([6 18 0 7*10^(-3)])
xlabel('time')
ylabel('solar radiation')
title('solar rad per day')
%disp(kk)
%% total amount of solar radiation received

t_st=floor((starthour-6)*15+1);
t_la=floor((lasthour-6)*15+1);
totalenergy = sum(y123(t_st:t_la))*4*1/720