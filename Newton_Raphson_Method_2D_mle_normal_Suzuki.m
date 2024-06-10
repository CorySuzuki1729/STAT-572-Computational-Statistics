r = normrnd(3,2,1000,1);
n = length(r);
ybar = mean(r);
mu0 = 1;
sigma0 = 3;
theta0 = [mu0, sigma0]
I0 = [n/sigma0 0; 0 n/(2*(sigma0^2))];
U0 = [(n*(ybar-mu0))/sigma0; (-n/(2*sigma0))+sum((r-mu0).^2)/(2*sigma0^2)];
theta_hat = theta0 + (inv(I0) * U0)
tol = [0.00001, 0.00001];
iter = 1;
while abs(theta_hat-theta0) > tol
    theta0 = theta_hat;
    mu0 = theta0(1);
    sigma0 = theta0(2);
    I0 = [n/sigma0 0; 0 n/(2*(sigma0^2))];
    U0 = [(n*(ybar-mu0))/sigma0; (-n/(2*sigma0))+sum((r-mu0).^2)/(2*sigma0^2)];
    theta_hat = theta0 + (inv(I0)*U0);
    iter = iter + 1;
end

theta_hat = [theta_hat(1), sqrt(theta_hat(2))]
iter
mle_hat = mle('normal',r)