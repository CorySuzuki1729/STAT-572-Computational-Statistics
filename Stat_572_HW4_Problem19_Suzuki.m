%Problem 9.19

%Load the data and specify x-values.
clear;
load geyser 
geyser_data = geyser;
n = length(geyser_data);
x_vals = linspace(floor(min(geyser_data))-10, ceil(max(geyser_data)+10));

%Providing normal kernel density estimate.
sigma_tilde = min(std(geyser_data), iqr(geyser_data)/1.348);
h_norm = 1.06*sigma_tilde*n^(-1/5);
fhat_norm = zeros(size(x_vals));
for i = 1:n
    f = normpdf(x_vals, geyser_data(i), h_norm);
    fhat_norm = fhat_norm + f/(n);
end

%Generating random sample from normal kernel
%density estimate.

u = rand(1,n);
ran_sam = [];
for i = 1:n
    index = length(find(u >= (i-1)/n & u <i/n));
    ran_sam(end+1 : end+index) = randn(index,1)*h_norm + geyser_data(i);
end

%Plotted histogram of data with kernel
%density estimate superimposed.

figure(1)
subplot(121)
histogram(geyser_data, 'Normalization', 'pdf')
h.FaceColor = 'w'
hold on
plot(x_vals, fhat_norm)
title('Histogram of geyser data with normal kernel')
legend('Geyser data', 'Normal kernel')
hold off

%Histogram of generated random sample
%from normal kernel density estimate.

binh = 2.15*sqrt(var(ran_sam))*n^(-1/5);
subplot(122)
histogram(ran_sam, 'BinWidth', binh, 'Normalization', 'pdf')
hold on
plot(x_vals,fhat_norm)
title('Histogram of random sample from normal kernel density estimate')
legend('Normal kernel r.s.', 'Normal kernel')
hold off