%Problem 1

%Part (a)
%Generate a random sample using the accept
%-reject method of size 100.

n = 100;
alpha = 2;
beta = 3;
%Find maximum of f/g where g is the 
%candidate distribution Unif(0,1) (found graphically).
c = 0.42;
funf = @(x) ((beta/alpha)*(x./alpha).^(beta-1))./(1+(x./alpha).^(beta)).^2;
%Allocate storage for samples.
x_val = zeros(1,n);
xy = zeros(1,n);
rej = zeros(1,n);
rejy = zeros(1,n);
index_rv = 1;
irej = 1;

while index_rv <= n
    y = gamrnd(alpha,beta);
    u = unifrnd(0,1);
    if (u <= (funf(y)/c))
        x_val(index_rv) = y;
        xy(index_rv) = u*c;
        index_rv = index_rv + 1;
    else
        rej(irej) = y;
        rejy(irej) = u*c;
        irej = irej + 1;
    end
end

%Calculate the acceptance rate for random sample.
acceptance_rate = index_rv/(irej + index_rv);
acceptance_rate

figure(1)
h = histogram(x_val, 'Normalization', 'pdf')
xlim([0,8])
%Superimpose true density and empirical CDF 
%of given pdf.
xx = 0:.01:8;
for i = 1:length(xx)
    a = xx(i);
    my_cdf(i) = integral(@(a)funf(a),0,a);
end
hold on
plot(xx, funf(xx))
cdfplot(x_val)
plot(xx, my_cdf, 'k')
legend('Histogram of samples', 'true density', 'empirical cdf', 'theoretical cdf')
hold off

%Part (b) Generate Markov chain of length 1000
% to estimate alpha.
N = 1000;
X_mark = zeros(1,N);
X_mark(1) = rand;
acc_markov = 0;
strg_lik = '(3/alpha)*(X./alpha).^2./(1+(X./alpha).^3).^2';
Lik = inline(strg_lik, 'X', 'alpha');

%Testing two different priors.
for i = 1:(N-1)
    prior = exprnd(3,1);
    %prior = gamrnd(1, beta);
    u = rand;
    num = prod(Lik(x_val, prior));
    den = prod(Lik(x_val, X_mark(i)));
    acc_prob = (num/den);
    if u <= acc_prob && prior > 0
        X_mark(i+1) = prior;
        acc_markov = acc_markov + 1;
    else
        X_mark(i+1) = X_mark(i);
    end
end

%Chose 20 percent burn-in.
index_burn = floor(.20*numel(X_mark))+1;
X_mark = X_mark(index_burn:end);

%Calculated acceptance rate, mean, and
%variance of MCMC for alpha.
acc_markov1 = acc_markov/N
mark_mean = mean(X_mark)
mark_var = var(X_mark)

%Plotted histogram for markov chain.
figure(2)
h2 = histogram(X_mark, 'Normalization', 'pdf')
h2.FaceColor = 'w'

%Plotted markov chain for alpha.
figure(3)
plot(X_mark)

%95 Percent classical CI for alpha.
confint1_low = mark_mean - (1.96*sqrt(mark_var))
confint1_high = mark_mean + (1.96*sqrt(mark_var))

%Part (c) repeat (b) now for inference on beta
%parameter.

X_mark_beta = zeros(1,N);
X_mark_beta(1) = rand;
acc_markov_beta = 0;
strg_lik_beta = '(beta/2)*(X./2).^(beta-1)./(1+(X./2).^(beta)).^2';
Lik_beta = inline(strg_lik_beta, 'X', 'beta');

%Testing two different priors.
for i = 1:(N-1)
    prior2 = exprnd(2,1);
    %prior2 = gamrnd(alpha, 4);
    u = rand;
    num2 = prod(Lik_beta(x_val, prior2));
    den2 = prod(Lik_beta(x_val, X_mark_beta(i)));
    acc_prob2 = (num2/den2);
    if u <= acc_prob2 && prior2 > 0
        X_mark_beta(i+1) = prior2;
        acc_markov_beta = acc_markov_beta + 1;
    else
        X_mark_beta(i+1) = X_mark_beta(i);
    end
end

%Chose 20 percent burn-in.
index_burn2 = floor(.20*numel(X_mark_beta))+1;
X_mark_beta = X_mark_beta(index_burn2:end);

%Calculate acceptance rate, mean, and
%variance of MCMC for beta.
acc_markov2 = acc_markov_beta/N
mark_mean2 = mean(X_mark_beta)
mark_var2 = var(X_mark_beta)

%Plot histogram.
figure(4)
h2 = histogram(X_mark_beta, 'Normalization', 'pdf')
h2.FaceColor = 'w'

%Plot Markov Chain.
figure(5)
plot(X_mark_beta)

%Classical 95 percent CI for beta.
confint2_low = mark_mean2 - (1.96*sqrt(mark_var2))
confint2_high = mark_mean2 + (1.96*sqrt(mark_var2))
