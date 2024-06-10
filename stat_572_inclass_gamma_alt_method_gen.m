N = 1000;
alpha = 3;
beta = 2;
%k = alpha*beta*5;
x = 0:.01:20;

for i = 2:length(x)
    a = x(i);
    Suzuki_gamcdf(i)=integral(@(a)gampdf(a,alpha,beta),0,a);
end
%runtime is O(n^2)  
%nested for loops
for i = 1:N
    u=rand;
    placement = Suzuki_gamcdf;
    for j=1:length(x)
        if placement(j) < u
            placement(j)=1;
        end
    end
    [c,ind] = min(placement);
    gamrv(i)=x(ind);
end
%This is the true density
%to compare with.
y = gampdf(x,alpha,beta);
%Plot true vs. the alt 
%method estimate
[f,h] = hist(gamrv);
f = f/(h(2)-h(1))/N;
subplot(121)
bar(h,f,1,'w')
hold on
plot(x,y,'r')
hold off
title('Gamma rs using alt procedure')
xlim([0,30])
%Alternatively can use histogram()
subplot(122)
h = histogram(gamrnd(alpha,beta,N,1),15,'Normalization','pdf');
h.FaceColor='w'
%facecolor=
hold on
plot(x,y,'b')
hold off
title('Gamma rs using Gamma rnd')
xlim([0,30])