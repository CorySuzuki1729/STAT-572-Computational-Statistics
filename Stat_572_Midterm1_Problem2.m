clear;
%Midterm Question 2
%Part A
%Input data and initialize the median.
data = [7,11,7,3,8,8,10,6,8,5,6,7,10,14,6,2,13,5,8,3,10,7,9,5];
n = length(data);
M = 1000;
alpha = 0.05;
median_obs = median(data);

median_test = zeros(1,M);

%Generating random sample under H0.
for i = 1:M
    xs = poissrnd(6,1,n);
    median_test(i) = median(xs);
end

%Get critical value and p-value.
crit_val = csquantiles(median_test, 1-alpha)
p_val = 1-(length(find(median_test<=median_obs))/M)

%Plot the histogram and mark
%the crit values and test statistic.
figure(1)
h = histogram(median_test, 'Normalization', 'pdf')
h.FaceColor = 'w'
hold on
plot([crit_val, crit_val],[0,2],'--r')
plot(median_obs,0,'xb','MarkerSize',20)

legend('simulate test stat','critical value','Observe test stat')
annotation('textbox',[0.3 0.8 0.1 0.1],'String',"p-value is " + p_val)
hold off

%Part B
sig = 5:.1:15;

%Get Type I Error
type_I = length(find(median_test>=crit_val))/M

%Get Type II Error
type_II = zeros(size(sig));
power = zeros(size(sig));
for j = 1:length(sig)
    for i = 1:M
        xs = poissrnd(sig(j),1,n);
        median_test(i) = median(xs);
    end
    typeII(j) = length(find(median_test<=crit_val))/M;
    power(j) = 1-typeII(j);
end

%Plot the power of the test and Type II Error.
figure(2)
plot(sig,power,'*-',sig,typeII,'ro')
legend('Power', 'Type II Error')