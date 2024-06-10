%Problem 3.9
function [q] = Suzuki_quantiles(p)
n = 100;
x = rand(1,n);
n = length(x);
p_hat = ((1:n)-0.5)/n;
sorted_sampling = sort(x);
q = interp1(p_hat, sorted_sampling, p);
end