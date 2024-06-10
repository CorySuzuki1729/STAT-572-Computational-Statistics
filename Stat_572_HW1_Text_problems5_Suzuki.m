%Problem 3.5
n= 2000;
x = randn(1,n);
% Find the mean of the sample.
mu = mean(x);
% Find the numerator and denominator 
% to get skewness.
num1 = (1/n)*sum((x-mu).^3);
den1 = (1/n)*sum((x-mu).^2);
gam1 = num1/den1^(3/2);

% Numerator and denominator for
%kurtosis.
num2 = (1/n)*sum((x-mu).^4);
den2 = (1/n)*sum((x-mu).^2);
gam2 = num2/den2^2;

gam1, gam2

%For this sample, skewness is
%0.0284 and kurtosis is 3.0048.
%We can see that for large n,
%the skewness tells us that the
%distribution is symmetrical
%as its close to 0, and the 
%kurtosis being close to 3
%confirms our standard normal
%distribution.