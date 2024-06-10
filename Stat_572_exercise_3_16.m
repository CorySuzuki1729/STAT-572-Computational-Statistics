%Problem 3.16 (Redo)
x = normrnd(3,2,10);
n = length(x);
xbar = mean(x);
loop = 0;
tol = 0.0001;
M = 300;
sigma0 = 2;
%u = inline('(n/sigma) + ((sum(x - 3).^2)/(sigma)^2)','sigma','n','x');
%I_inv = ;

sigma_repeat = [];
for i = 1:M
    sigma_hat = sigma0 + I_inv(sigma0,n)*u(sigma0,n,x_bar);
    while abs(sigma_hat - sigma) > tol
        sigma0 = sigma_hat;
        sigma_hat = sigma0 + I_inv(sigma0,n)*u(sigma0,n,x_bar);
        loop = loop + 1;
    end
    sigma_repeat(end+1) = sigma_hat;
end
sigma_repeat
    