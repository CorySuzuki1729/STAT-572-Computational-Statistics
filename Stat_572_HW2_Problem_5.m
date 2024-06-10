%Problem 4.5
function [] = Suzuki_norm_alt(mu, std_dev)
N = 1000;
%mu = 5;
%std_dev = 2;
x = -20:.01:20;

for i = 2:length(x)
    a = x(i);
    Suzuki_normcdf(i)=integral(@(a)normpdf(a,mu,std_dev),0,a);
end

for i = 1:N
    u=rand;
    placement = Suzuki_normcdf;
    for j=1:length(x)
        if placement(j) < u
            placement(j)=1;
        end
    end
    [c,ind] = min(placement);
    normrv(i)=x(ind);
end
%This is the true density
%to compare with.
y = normpdf(x,mu,std_dev);
%Plot true vs. the alt 
%method estimate
[f,h] = hist(normrv);
f = f/(h(2)-h(1))/N;
subplot(121)
bar(h,f,1,'w')
hold on
plot(x,y,'r')
hold off
title('Normal rs using alt procedure')
xlim([-25,25])