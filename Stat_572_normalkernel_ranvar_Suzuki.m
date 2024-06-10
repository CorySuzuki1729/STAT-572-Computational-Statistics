clear;
n=1500;
nx = [200,800,500];
p=nx/n;
mu=[5 10 15];
sigma=[1 1.5 2];
data = zeros(n,1);
% Now generate 1500 random variables. First find
% the number that come from each component.
data(1:nx(1)) = normrnd(mu(1),sigma(1),nx(1),1);
data(nx(1)+1:nx(1)+nx(2)) = normrnd(mu(2),sigma(2),nx(2),1);
data(nx(1)+nx(2)+1:n) = normrnd(mu(3),sigma(3),nx(3),1);

t0 = min(data)-1;
tm = max(data)+1;
x = linspace(t0,tm, 1500);
len = length(data);
h = 2.15*sqrt(var(data))*n^(-1/5);
%Normal Kernel estimation
fhat_norm = zeros(size(x));
sigmadelta = min(std(data), iqr(data)/1.348);
h_norm = 1.06*len^(-1/5)*sigmadelta;

for i = 1:len
    f = normpdf(x, data(i),h_norm);
    fhat_norm = fhat_norm + f/(len);
end

%true density
true_den = zeros(size(x));
for i = 1:3
    true_den = true_den+p(i)*normpdf(x,mu(i), sigma(i));
end

%Take a random sample using
%random numbers (easier than
%uniform).

u = rand(1,n);
ran_sam = [];
for i = 1:n
    index = length(find(u >= (i-1)/n & u < i/n));
    ran_sam(end+1:end+index) = randn(index,1)*h_norm + data(i);
end

%Plot histogram of r.s.
%with normal kernel density
%estimate superimposed.

histogram(ran_sam,'BinWidth', h, 'Normalization', 'pdf')
hold on
plot(x, fhat_norm, 'b')
plot(x, true_den, 'r')
title('Normal kernel r.s.')
legend('Histogram', 'kernel density', 'true density')
hold off