clear;
%Midterm Question 1

%Part A: Inverse CDF method

%Set-up storage/initialize
%appropriate parameters.
n = 1000;
alpha = 1;
beta = 5;
xs = 0:15; %Chosen x-values.
x = zeros(1,n);
j = 1;
% Set while loops to generate variables.
while (j <= n)
    flag = 1;
    u = rand(1);
    i = 0;
    p = (1+alpha)^(-beta);
    F = p;
    while flag
        if u <= F  %accept r.v. if condition met.
            x(j) = i;
            flag = 0;
            j = j + 1;
        else %Define recursive ratio here.
            p = (((i+beta)*alpha)*p)/((1+alpha)*(i+1));
            i = i + 1;
            F = F + p;
        end
    end
end

%Graph the histogram and true density
%superimposed.

h = histogram(x,'Normalization', 'pdf')
h.FaceColor='w'
xlim([0,15])
xs = 0:15;
hold on
func_y = @(z) (factorial(z+beta-1).*(alpha).^z)./(factorial(beta-1).*factorial(z).*(1+alpha).^(z+beta));
plot(xs,func_y(xs),'r','LineWidth', 5)
hold off

%Part B
%Use immse to find MSE between
%estimates and actuals.

%x variable holding the r.v.
%already accounts for i = 0,
%so set indexing for actual
%function value by indexing first
%at k-1 to plug in func_y(0).
%Matlab indexing starts at 1
%by default.

for k = 1:10
    mse_vec(k) = immse(x(k),func_y(k-1));
end
mse_vec