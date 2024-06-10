%Get random samples and create artificial data.
n = 1000;
nx = [200,800,500];
p = nx/n;
mu = [5, 10, 15];
sigma = [1, 1.5, 2];
data = zeros(1,n);

data(1:nx(1)) = normrnd(mu(1),sigma(1),nx(1));
data(nx(1):nx(2)) = normrnd(mu(2),sigma(2),nx(2));
data(nx(2):nx(3)) = normrnd(mu(3),sigma(3),nx(3));

%EDA Histograms to preview distributions
histogram(data, 'Normalization', 'pdf')

muin = [12, 18, 19];
varin = [1,1,1];
pies = [(1/3), (1/3), (1/3)];

maxit = 100;
tol = 0.0001;

[pies, mus, vars] = csfinmix(data, muin, varin, pies, maxit, tol);
mus;
pies;
sds = std(vars);

n = 300;

xx = 0:.1:25;
fhat = zeros(size(xx));
for i = 1:3
    fhat = fhat+pies*normpdf(xx, mus(i), sds(i));
end

truef = zeros(size(xx));
for i = 1:3
    truef = 0;
end

%Normal kernel pdf estimate
h = 2.15*var(data)*n^(-1/5);
fhat_norm = zeros(size(xx));
sigdelta = min(std(data), iqr(data)/1.348);

for i = 1:n
    fhat_norm =