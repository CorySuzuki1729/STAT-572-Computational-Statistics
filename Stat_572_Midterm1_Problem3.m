clear;
%Midterm Question 3
%Set up data and initialize
%storage for counts and CI's.
data = [7,11,7,3,8,8,10,6,8,5,6,7,10,14,6,2,13,5,8,3,10,7,9,5];
n = length(data);
alpha = 0.05; 
B = 200;
C = 25;
N = 100;
count1 = 0;
count2 = 0;
size1 = zeros(N,1);
size2 = zeros(N,1);
CI1 = zeros(N,2);
CI2 = zeros(N,2);

%Set the true probability.
theta_prob = Stat_572_Midterm1_theta(data);
true_prob = 1/4;

for j = 1:N
    ind = unidrnd(n,1,n);
    newdata = data(ind);
    [bootreps, bootsam] = bootstrp(B,'Stat_572_Midterm1_theta',newdata);
    thetahat_prob = mean(bootreps);
    SE_prob = std(bootreps);
    %Create bootstrap percentile CI
    k = B*alpha/2;
    bval = sort(bootreps);
    CI2(j,:) = [bval(k) bval(B-k)];
    size2(j) = CI2(j,2)-CI2(j,1);
    if (CI2(j,1)<=true_prob && CI2(j,2)>=true_prob)
        count2 = count2 + 1;
    end

    %Create bootstrap t-interval.
    sehats_prob = zeros(size(bootreps));
    for i = 1:B
        xstar = data(bootsam(:,i));
        bvals(i) = Stat_572_Midterm1_theta(xstar);
        sehats_prob(i) = std(bootstrp(C, 'Stat_572_Midterm1_theta', xstar));
    end
    zvals = (bootreps - thetahat_prob)./sehats_prob;
    szval = sort(zvals);
    tlo = szval(k);
    thi = szval(B-k);
    CI1(j,:) = [thetahat_prob-thi*SE_prob, thetahat_prob-tlo*SE_prob];
    size1(j) = CI1(j,2)-CI1(j,1);
    if (CI1(j,1)<=true_prob && CI1(j,2)>=true_prob)
        count1 = count1 + 1;
    end
end

%histogram of bootstrap replications.
histogram(bootreps, 'Normalization', 'pdf')

%Calculate means and std's of CI lengths.
CI1_prob = mean(CI1), CI2_prob = mean(CI2)
meanwidth1 = mean(size1); meanwidth2 = mean(size2);
sdwidth1 = std(size1); sdwidth2 = std(size2);
MeanWidths = [meanwidth1, meanwidth2]
SdWidths = [sdwidth1, sdwidth2]

%Calculate coverages of CI's.
coverage1 = count1/N; coverage2 = count2/N;
Coverages = [coverage1, coverage2]