%Problem 21
clear;
load forearm
forearm_data = forearm;
n = length(forearm);
h = 2.15*sqrt(var(forearm_data))*n^(-1/5);
x = linspace(floor(min(forearm_data))-10, ceil(max(forearm_data))+10);

%Check the data using a preliminary histogram
figure(1)
histogram(forearm_data, 'Normalization', 'pdf')
title('Histogram of raw data (EDA)')

%Normal Kernel 
fhat_norm = zeros(size(x));
sigmadelta = min(std(forearm_data), iqr(forearm_data)/1.348);
h_norm = 1.06*n^(-1/5)*sigmadelta;

for i = 1:n
    f = normpdf(x, forearm_data(i),h_norm);
    fhat_norm = fhat_norm + f/(n);
end

% Epanechnikov Kernel
fhat_epan = zeros(size(x));
h_epan = h_norm*(30*sqrt(pi))^0.2;
for i = 1:n
    domain = (x-forearm_data(i))/h_epan;
    for j = 1:length(x)
        if abs(domain(j)) <= 1
            f(j) = (3/4)*(1-((x(j)-forearm_data(i))/h_epan).^2)/h_epan;
        else
            f(j) = 0;
        end
    end
    fhat_epan = fhat_epan + f/(n);
end

figure(2)
plot(x,fhat_norm,'b',x,fhat_epan,'r');
hold on
histogram(forearm_data, 'Normalization', 'pdf')
legend('Normal Kernel','Epanechnikov Kernel','Histogram')
hold off

%Finite Mixture Method (nterm = 2)
p0 = [0.7, 0.7];
mu0 = [20, 18];
sigma_sq = [1, 1];
max_iter = 100;
tol = 0.0001;

[pies2, mus2, vars2] = csfinmix(x, mu0, sigma_sq, p0, max_iter, tol);

%Finite Mixture Method (nterm = 3)
p_0 = [1/3, 1/3, 1/3];
mu_0 = [17, 18, 19];
sigma2sq = [1, 1, 1];
max_iterations = 100;

[pies3, mus3, vars3] = csfinmix(x, mu_0, sigma2sq, p_0, max_iterations, tol);

%Generating r.s. from normal
%kernel density.

u = rand(1,n);
ran_sam = [];
for i = 1:n
    index = length(find(u >= (i-1)/n & u < i/n));
    ran_sam(end+1 : end+index) = randn(index,1)*h_norm + forearm_data(i);
end

%Generating r.s. from finite mixture.
U = rand(1,n);
index1 = length(find(U <= pies2(1)));
index2 = length(find(U > pies2(1)));
sam_finmix(1:index1) = randn(index1,1)*sqrt(vars2(1)) + mus2(1);
sam_finmix(index1+1 : index1 + index2) = randn(index2,1)*sqrt(vars2(2)) + mus2(2);
fhat_sam = zeros(size(x));
for i = 1:2
    fhat_sam = fhat_sam + pies2(i)*normpdf(x, mus2(i), sqrt(vars2(i)));
end

figure(3)
histogram(forearm_data, 'Normalization', 'pdf')
hold on
plot(x, fhat_sam)
title('2 Term Finite Mixture Estimate')
legend('Histogram', '2 Term FM')
hold off

%Generating r.s. from 3 term FM
index_1 = length(find(U <= pies3(1)));
index_2 = length(find(U > pies3(1) & U <= pies3(1)+pies3(2)));
index_3 = length(find(U > pies3(1)+pies3(2)));
samfinmix3(1:index_1) = randn(index_1,1)*sqrt(vars3(1))+mus3(1);
samfinmix3(index_1+1:index_1+index_2) = randn(index_2,1)*sqrt(vars3(2))+mus3(2);
samfinmix3(index_1+index_2+1:index_1+index_2+index_3) = randn(index_3,1)*sqrt(vars3(3))+mus3(3);
fhat_sam3 = zeros(size(x));
for i = 1:3
    fhat_sam3 = fhat_sam3 + pies3(i)*normpdf(x, mus3(i), sqrt(vars3(i)));
end

figure(4)
histogram(forearm_data, 'Normalization', 'pdf')
hold on
plot(x, fhat_sam3)
title('3 Term Finite Mixture Estimate')
legend('Histogram', '3 Term FM')
hold off

%Histograms of finite mixture r.s.
%and the Normal r.s.

%Normal kernel r.s.
figure(5)
subplot(131)
histogram(ran_sam, 'BinWidth', h, 'Normalization', 'pdf')
hold on
title('Normal Kernel r.s.')
legend('Normal Kernel r.s.')
hold off

%2-Term FM r.s.
subplot(132)
histogram(sam_finmix, 'Normalization', 'pdf')
hold on
title('2 Term Finite Mixture Random Sample')
legend('2 Term FM r.s.')
hold off

%3-Term FM r.s.
subplot(133)
histogram(samfinmix3, 'Normalization', 'pdf')
hold on
title('3 Term Finite Mixture Random Sample')
legend('3 Term FM r.s.')
hold off