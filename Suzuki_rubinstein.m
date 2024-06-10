%Problem 7
function [] = Suzuki_rubinstein(alpha, beta)
n = 1000;
x = 0:.01:1;
i = 1;
sample_mat = zeros(1,n);
while i < n
    y_var1 = unifrnd(0,1)^(1/alpha);
    y_var2 = unifrnd(0,1)^(1/beta);
    if y_var1 + y_var2 <= 1
        sample_mat(i) = y_var1/(y_var1 + y_var2);
        i = i + 1;
    end
end

y = betapdf(x, alpha, beta);
[f,h] = hist(sample_mat)
f = f/(h(2)-h(1))/n;
bar(h,f,1,"w")
hold on
plot(x,y,"r")
hold off