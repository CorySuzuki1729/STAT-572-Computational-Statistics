lam = 2;
n = 1000;
uni = rand(1,n);
X = -log(uni)/lam;
x = 0:.1:(10/lam);
y = exppdf(x,(1/2));
[N,h] = hist(X,10);
N = N/(h(2)-h(1))/n;
bar(h,N,1,'w')
hold on
plot(x,y)
hold off
xlabel('X')
ylabel('f(x) - Exponential')