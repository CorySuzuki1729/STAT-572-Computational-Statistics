%In-class Example for
%Monte Carlo Integration
n = 200;
M = 200;
gamma_rs = gamrnd(3,2,1,n);

for i = 1:M
    GX_trim = trimmean(gamma_rs, 20);
    GX_quarts = quartiles(gamma_rs);
    gx_thirdq = GX_quarts(3);
end

%Expected values
expected_gx_trim = (1/n)*sum(GX_trim(:))
expected_gx_quart = (1/n)*sum(gx_thirdq(:))

%Variances
var_gx_trim = (1/(n-1))*sum((GX_trim-expected_gx_trim).^2)
var_gx_quart = (1/(n-1))*sum((gx_thirdq-expected_gx_quart).^2)
