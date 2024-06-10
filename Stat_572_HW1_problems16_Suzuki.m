%Problem 3.16

n=1000; 

data = randn(1,n); 

x_bar = mean(data);
sigma_hat_sq = mean( ( data - x_bar ).^2 ); 
sigma_hat_sq = var(data,1);    % using a biased estimator 
sigma_hat_sq = var(data);     % using an unbiased estimator 

bias = mean(sigma_hat_sq) - 1