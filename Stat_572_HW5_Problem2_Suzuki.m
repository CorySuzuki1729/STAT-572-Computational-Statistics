%Problem 2

clear;
n_markov = 1000;
n = 200;
accept_norm = 0;

%Generate random samples from
%N(5,1) and N(10,1) of size 200.

u = rand(1,n);
X_norm = zeros(size(u));
for i = 1:n
    if (u == 0.3)
        X_norm = normrnd(5,1,1);
    else
        X_norm = normrnd(10,1,1);
    end
end

X_mark = zeros(1,n_markov);
X_mark(1) = rand;

%Define likelihood function.

strg = 'a*normpdf(X,5,1) + (1-a)*normpdf(X,10,1)';
L = inline(strg,'X','a');

%Testing with different priors.

for i = 1:(n_markov-1)
    lower = max(0, X_mark(i)+0.5);
    upper = min(1, X_mark(i)-0.5);
    %y = unifrnd(lower, upper);
    %y = betarnd(1,1);
    %y = betarnd(2,5);
    y = betarnd(2,10);
    u = rand;
    num = prod(L(X_norm,y));
    den = prod(L(X_norm,X_mark(i)));
    alpha = (num/den);
    if u <= alpha && y > 0
        X_mark(i+1) = y;
        accept_norm = accept_norm + 1;
    else
        X_mark(i+1) = X_mark(i);
    end
end

index_rw = floor(.20*numel(X_mark))+1;
X_mark = X_mark(index_rw:end);

accept_norm1 = accept_norm/n_markov
mark_mean = mean(X_mark)
mark_var = var(X_mark)
histogram(X_mark, 'Normalization', 'pdf')
h.FaceColor = 'w';  
