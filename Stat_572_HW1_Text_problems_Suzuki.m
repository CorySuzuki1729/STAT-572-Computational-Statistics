%Problem 3.1
x = randn(2,500);
x_bar = mean(x)
y = randn(15,500);
y_bar = mean(y)
z = randn(45,500);
z_bar = mean(z)
histfit(x_bar)
histfit(y_bar) 
histfit(z_bar) 