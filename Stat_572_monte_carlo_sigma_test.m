%In-class Example
load mcdata 
sigma0 = 7.8;
mu = mean(mcdata);
samvar = var(mcdata);

M = 1000;
n = length(mcdata);
Tobs = ((n-1)*(samvar))/sigma0;
Tm = zeros(1,M);
for i = 1:M
    xs = normrnd(mu, sigma0, 1, n);
    Tm(i) = ((n-1)*(var(xs)))/sigma0;
end

alpha = 1-0.05;
ind = find(Tm >= Tobs);
pval = length(ind)/M;
pval

cv = csquantiles(Tm, alpha);
figure(1)
h = histogram(Tm, 'normalization', 'pdf')
h.FaceColor = 'w';
hold on
plot(cv, 0, '*', 'MarkerSize', 20)
plot(Tobs, 0, 'ob')
hold off

%Unclear about this part.
sig = 6:.01:15;
TypeII = zeros(size(sig));
power = zeros(size(sig));
for j = 1:length(sig)
    for i = 1:M
        xs = normrnd(mu, sig(j), 1,n);
        samvar = var(xs);
        Tm(i) = ((n-1)*(samvar))/sigma0;
    end
    TypeII(j) = length(find(Tm<=cv))/M;
    power(j) = 1 - TypeII(j);
end

figure(2)
plot(sig,power,'*-',sig,TypeII,'ro-')