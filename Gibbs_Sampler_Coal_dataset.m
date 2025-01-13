load coal
n = length(y);
m = 1100;
a1 = 0.5;
a2 = 0.5;
c1 = 0;
c2 = 0;
d1 = 1;
d2 = 1;
theta = zeros(1,m);
lambda = zeros(1,m);
k = zeros(1,n);
like = zeros(1,n);

k(1) = unidrnd(n,1,1);
theta(1) = 1;
lambda(1) = 1;
b1 = 1;
b2 = 1;
for i = 2:m
    kk = k(i-1);
    t = a1 + sum(y(1:kk));
    lam = kk + b1;
    theta(i) = gamrnd(t, 1/lam,1,1);
    t = a2 + sum(y) - sum(y(1:kk));
    lam = n-kk+b2;
    lambda(i) = gamrnd(t, 1/lam,1,1);
    b1 = gamrnd(a1+c1,1/(theta(i)+d1),1,1);
    b2 = gamrnd(a2+c2,1/(theta(i)+d2),1,1);
    for j = 1:n
        like(j) = exp((lambda(i)-theta(i))*j)*(theta(i)/lambda(i))^sum(y(1:j));
    end
    like = like/sum(like);
    k(i) = cssample(1:n,like,1);
end

figure;
subplot(3,1,1);
plot(theta);
ylabel('Theta');

subplot(3,1,2);
plot(lambda);
ylabel('lambda');

subplot(3,1,3);
plot(k);
ylim([30 60]);
ylabel('Changepoint-k');
