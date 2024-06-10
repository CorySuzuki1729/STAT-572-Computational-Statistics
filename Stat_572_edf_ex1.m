x = normrnd(0,1,50,1);
sorted_list = sort(x);
n = length(x);
phat = (1:n)/n-.5/n;
interp1(phat, x, .475)
