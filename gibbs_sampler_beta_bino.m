k = 1000; % Number of samples
m = 500;  % Burn-in period
a = 2;    % Beta parameter
b = 4;    % Beta parameter
n = 16;   % Binomial parameter

% Gibbs Sampling
x = zeros(1, k);
y = zeros(1, k);

x(1) = binornd(n, 0.5);
y(1) = betarnd(x(1) + a, n - x(1) + b);
for i = 2:k
    x(i) = binornd(n, y(i-1));
    y(i) = betarnd(x(i) + a, n - x(i) + b);
end

% Compute theoretical marginal density
true_marginal = zeros(1, n+1);
for x_val = 0:n
    true_marginal(x_val+1) = nchoosek(n, x_val) * beta(x_val + a, n - x_val + b) / beta(a, b);
end

% Compute estimated marginal density
x_samples = x(m+1:end); % Discard burn-in samples
estimated_marginal = histcounts(x_samples, 0:n+1, 'Normalization', 'probability');

% Plot histograms
figure;
subplot(2,1,1);
bar(0:n, true_marginal, 'FaceAlpha', 0.5, 'FaceColor', 'blue', 'DisplayName', 'True Marginal Density');
xlabel('x');
ylabel('Density')
legend;
title('True Marginal Density')
subplot(2,1,2);
bar(0:n, estimated_marginal, 'FaceAlpha', 0.5, 'FaceColor', 'red', 'DisplayName', 'Estimated Marginal Density');
xlabel('x');
ylabel('Density');
legend;
title('Estimated Marginal Density');

