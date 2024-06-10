%problem 3
clear;
n = 100;
M = 200;

pseudo = normrnd(0,1,n,1);
[vk, bc] = hist(pseudo)
h = bc(2)-bc(1);
%Choose x0=2.
x0 = 2;
index = find(bc < x0);
endpoint1 = bc(index(end));
endpoint2 = bc(index(end) + 1);

if (x0-endpoint1) < (endpoint2-x0)
   fhat = vk(index(end))/(n*h);
else
   fhat = vk(index(end) + 1)/(n*h);
end
mse_stor = immse(fhat, normpdf(x0,0,1));
fhat;
mse_stor

%Histogram
% histogram(pseudo, 'Normalization', 'pdf')
% h.FaceColor = 'w'
