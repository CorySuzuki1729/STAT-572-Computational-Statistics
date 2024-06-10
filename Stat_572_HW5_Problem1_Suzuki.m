%Problem 1

clear;

%Generate a r.s. of size 100
%from Ber(0.2).
n = 100;
u = rand(1,n);
X_ber = zeros(size(u));
X_ber(u <= 0.2) = 1;
ber_sum = sum(X_ber);

acc_rate = 0;

%Use Metropolis-Hastings
%sampler to generate size
%2000 Markov Chain.
n_markov = 2000;
likelihood = inline('theta^sumx*(1-theta)^(n-sumx)', 'theta', 'n', 'sumx');
X_metha = zeros(1,n_markov);
X_metha(1) = rand;

for i = 1:(n_markov-1)
    upper = min(1, X_metha(i)+(0.5/sqrt(12)));
    lower = max(0, X_metha(i)-(0.5/sqrt(12)));
    y = unifrnd(lower, upper);
    u = rand;
    num = likelihood(y, n, ber_sum);
    den = likelihood(X_metha(i), n, ber_sum);
    acc_prob = min(1, (num/den));
    if u <= acc_prob
        X_metha(i+1) = y;
        acc_rate = acc_rate + 1;
    else
        X_metha(i+1) = X_metha(i);
    end
end

%Mean and variance of Markov chains
%with histograms.

acc_rate1 = acc_rate/n_markov
X_metha2 = X_metha(501:end);
mean_first = mean(X_metha2)
var_first = var(X_metha2)

%Generate Beta(sum+1, n-sum+1)
n_beta = length(X_metha2);
X_beta = zeros(1,n_beta);
X_beta(1) = rand;
acc_rate2 = 0;
for i = 1:(n_beta-1)
    cand = X_beta(i)+(unifrnd(-0.5,0.5)/sqrt(12));
    cand_y = max(cand, 0);
    u = rand;
    num_beta = betapdf(cand_y, ber_sum+1, n-ber_sum+1);
    den_beta = betapdf(X_beta(i), ber_sum+1, n-ber_sum+1);
    acc_prob2 = min(1, (num_beta/den_beta));
    if u <= acc_prob2
        X_beta(i+1) = cand_y;
        acc_rate2 = acc_rate2 + 1;
    else
        X_beta(i+1) = X_beta(i);
    end
end

X_beta2 = X_beta(501:end);
acc_rate_beta = acc_rate2/n_beta
mean_second = mean(X_beta2)
var_second = var(X_beta2)

%Histogram comparison
figure(1)
clf;
subplot(121)
h1 = histogram(X_metha2, 'Normalization', 'pdf')
h1.FaceColor = 'w'
title('Metropolis-Hastings Sampler')

subplot(122)
h2 = histogram(X_beta2, 'Normalization', 'pdf')
h2.FaceColor = 'b'
title('Random Walk Sampler')