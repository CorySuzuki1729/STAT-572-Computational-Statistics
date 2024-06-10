X = [7,11,7,3,8,8,10,6,8,5,6,7,10,14,6,2,13,5,8,3,10,7,9,5];
n = length(X); %sample size
theta_hat = Stat_572_Midterm1_theta(X); %calculate theta hat = P(X>=10) using theta.m
alpha = .05; %alpha

% Bootstrap:
B = 250; %number of Bootstrap trials
M = 150; %number of Monte Carlo trials
inds = unidrnd(n,n,B); %indices for Bootstrap resampling
X_b = X(inds); %Bootstrap resamples
%Monte Carlo aglorithm:
for j = 1:M
    %Generate Bootstrap replicates and sample using bootstrp.m:
    [theta_b, X_b] = bootstrp(B,'Stat_572_Midterm1_theta',X); 
    se_b = std(theta_b); %Bootstrap standard error
    bias_b = theta_hat - mean(theta_b); %Bootstrap bias
    %Repeat bootstrap for Bootstrap-t CI:
    for i = 1:B 
        xstar = X(X_b(:,i)); %extract resample from the data
        %Calculate SE hats using bootstrp.m:
        [theta_bb, X_bb] = bootstrp(25,'Stat_572_Midterm1_theta',xstar);
        sehats(i) = std(theta_bb);
    end
    zvals = (theta_b - theta_hat)./sehats'; %z scores
    k = ceil(B*alpha/2); %index of critical value
    szval = sort(zvals); %sorted z vals
    thi = szval(k); %upper critical value
    tlo = szval(B-k); %lower critical value
    %boott_hi(j) = theta_hat - thi * se_b; %upper Boot-t CI limit
    boott_hi(j) = mean(theta_b) - thi * se_b
    %boott_lo(j) = theta_hat - tlo * se_b; %lower Boot-t CI limit
    boott_lo(j) = mean(theta_b) - tlo * se_b
    
    %Bootstrap percentile CI:
    t1 = ceil(B*alpha/2); %lower t score
    t2 = ceil(B-k); %upper t score
    stheta_b = sort(theta_b); %sorted bootstrap replicates
    bootp_lo(j) = stheta_b(t1) %Bootstrap percentile CI lower limit
    bootp_hi(j) = stheta_b(t2) %Bootstrap percentile CI upper limit
end

theta_true = .15;
boott_cover = 0;
bootp_cover = 0;
for j = 1:M
    if boott_lo(j) < theta_true && boott_hi(j) > theta_true
        boott_cover = boott_cover + 1;
    end
    if bootp_lo(j) < theta_true && bootp_hi(j) > theta_true
        bootp_cover = bootp_cover + 1;
    end
end
boott_cover = boott_cover/M
bootp_cover = bootp_cover/M