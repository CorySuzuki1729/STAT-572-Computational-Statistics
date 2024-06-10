%Problem 3.1
%n=2
c = 2;
z = randn(c,500);
z_bar = mean(z);
mean_sample_z = mean(z_bar);
var_sample_z = var(z_bar);
subplot(3,1,1)
histfit(z_bar)

%n=15
m = 15;
y = randn(m,500);
y_bar = mean(y);
mean_sample_y = mean(y_bar);
var_sample_y = var(y_bar);
subplot(3,1,2)
histfit(y_bar)

%n=45
n = 45;
x = randn(n,500);
x_bar = mean(x);
mean_sample_x = mean(x_bar);
var_sample_x = var(x_bar);
subplot(3,1,3)
histfit(x_bar)