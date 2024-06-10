load forearm
alpha = 0.05;
B = 200;
C = 25;
N = 100;
n = length(forearm);
count1 = 0;
count2 = 0;
count3 = 0;
size1 = zeros(N,1);
size2 = zeros(N,1);
size3 = zeros(N,1);

CI1_skew = zeros(N,2);
CI2_skew = zeros(N,2);
CI3_skew = zeros(N,2);

true_skew = skewness(forearm);

for j = 1:N
    X = forearm;
    ind = unidrnd(n,1,n);
    X = X(ind);

    %classical interval
    [bootreps, bootsam] = bootstrp(B,'skewness',X);
    SE_skew = std(bootreps);
    thetahat_skew = mean(bootreps);
    CI1_skew(j,:) = [thetahat_skew-1.96*SE_skew thetahat_skew+1.96*SE_skew];
    size1(j) = CI1_skew(j,2)-CI1_skew(j,1);
    if (CI1_skew(j,1) <= true_skew && CI1_skew(j,2)>=true_skew)
        count1 = count1 + 1;
    end

    k = B*alpha/2;
    bval = sort(bootreps);
    CI3_skew(j,:) = [bval(k) bval(B-k)];
    size3(j) = CI3_skew(j,2)-CI3_skew(j,1);
    if (CI3_skew(j,1) <= true_skew && CI3_skew(j,2)>= true_skew)
        count3 = count3 + 1;
    end

    %bootstrap t-interval
    sehats = zeros(size(bootreps));
    for i = 1:B
        xstar = forearm(bootsam(:,i));
        bvals(i) = skewness(xstar);
        sehats(i) = std(bootstrp(C,'skewness',xstar));
    end
    zvals = (bootreps - thetahat_skew)./sehats;
    k = B*alpha/2;
    szval = sort(zvals);
    tlo = szval(k);
    thi = szval(B-k);
    CI2_skew(j,:) = [thetahat_skew-thi*SE_skew thetahat_skew-tlo*SE_skew];
    size2(j) = CI2_skew(j,2)-CI2_skew(j,1);
    if (CI2_skew(j,1)<=true_skew && CI2_skew(j,2)>=true_skew)
        count2 = count2 + 1;
    end
end

%histogram of bootstrap replications
histogram(bootreps, 20, "Normalization", "pdf")

%Calculate mean/sd of CI lengths
CI1_skew=mean(CI1_skew), CI2_skew=mean(CI2_skew), CI3_skew=mean(CI3_skew)
MeanWidth1=mean(size1); MeanWidth2=mean(size2);MeanWidth3=mean(size3);
sdWidth1=std(size1);sdWidth2=std(size2);sdWidth3=std(size3);
Mean_Width=[MeanWidth1,MeanWidth2,MeanWidth3]
SD_Width=[sdWidth1,sdWidth2,sdWidth3]

%===Calculate the coverage
Coverage1=count1/N; Coverage2=count2/N; Coverage3=count3/N;
Coverage=[Coverage1,Coverage2,Coverage3]