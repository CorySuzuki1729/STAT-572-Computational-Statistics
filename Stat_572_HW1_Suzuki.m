%In-Class HW Problem
sample_frame = gamrnd(3,5,1000,1);
n = length(sample_frame);
ybar = mean(sample_frame);
beta0 = 3;
theta0 = [3, beta0];
I0 = 0;
U0 = 0;
theta_hat = 0;
tol = [0.00001, 0.00001];
iter = 1;
while abs(theta_hat-theta0) > tol
    theta0 = theta_hat;
    beta0 = theta0(2);
    I0 = 0;
    U0 = 0;
    theta_hat = theta0 + (inv(I0)*U0);
    iter = iter + 1;
end
theta_hat = [3, theta_hat(2)]
iter
%Below is the mle built-in function
%which is used to verify correctness
mle_hat = mle('gamma', sample_frame)