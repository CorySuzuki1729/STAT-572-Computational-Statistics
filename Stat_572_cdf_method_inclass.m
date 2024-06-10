N = 10000;
n = 20;
p = 0.3;
x = 0:1:20;
k = length(x);
b_cdf = binocdf(x,n,p);
%u_dist = unifrnd(0,1,10000);
%n1 = length(b_cdf(1));
for i = 1:N
    u_dist = rand;
    j = 1;
    while j < k
        if u_dist <= b_cdf(j)
            X(i) = x(j);
            break
        else
            j = j + 1;
        end
    end
end

b_pdf = binopdf(x,20,.3);
[n, b_cdf] = hist(X, x)
rel_freq = n/N;
bar(n, rel_freq)
hold on

plot(n, b_cdf)
hold off