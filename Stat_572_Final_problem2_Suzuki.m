%Problem 2

%Part (a) Use the custom function to provide
%a histogram of generated Poisson rv's, with
%true density superimposed.

pois_sam = generate_poisson(2, 100);
figure(1)
h = histogram(pois_sam, 'Normalization', 'pdf')
h.FaceColor = 'w'
xx = 0:.01:11;
hold on
plot(xx, poisspdf(xx, 2))
legend('Poisson data', 'True density')
hold off

%Part (b) Providing normal kernel density estimate.
n = length(pois_sam);
x_vals = linspace(floor(min(pois_sam))-5, ceil(max(pois_sam)+5));
sigma_tilde = min(std(pois_sam), iqr(pois_sam)/1.348);
h_norm = 1.06*sigma_tilde*n^(-1/5);
fhat_norm = zeros(size(x_vals));
for i = 1:n
    f = normpdf(x_vals, pois_sam(i), h_norm);
    fhat_norm = fhat_norm + f/(n);
end

%Plot histogram of the sample data with the 
%Normal KDE and the true density superimposed.
figure(2)
h2 = histogram(pois_sam, 'Normalization', 'pdf')
h2.FaceColor = 'w'
hold on
plot(x_vals, fhat_norm)
plot(xx, poisspdf(xx, 2))
legend('Poisson data', 'Normal KDE', 'True density')
hold off

% Part (c) Monte Carlo estimate of MSE.

J = 20;
mcn = 100;
mc = (1-.05)*mcn;
%Initialize points to perform monte carlo.
points = [0,1,2,3,4,5,6,7,8,9,10];
kern = zeros(J, length(points));
h_mc = 1.06*mc^(-1/5);
for j = 1:J
    for i = 1:mc
        fun_mc = normpdf(points, pois_sam(i), h_mc);
        kern(j,:) = kern(j,:)+fun_mc/(mc);
    end
end

true_den = poisspdf(points, 2);
mse = mean((kern-true_den).^2)
