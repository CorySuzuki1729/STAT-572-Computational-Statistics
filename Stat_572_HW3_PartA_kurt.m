load forearm
alpha = 0.05;
B = 200;
n = length(forearm);
C = 25;
N = 100;
count1 = 0;
count2 = 0;
count3 = 0;
size1 = zeros(N,1);
size2 = zeros(N,1);
size3 = zeros(N,1);

CI1_kurt = zeros(N,2);
CI2_kurt = zeros(N,2);
CI3_kurt = zeros(N,2);

true_kurt = kurtosis(forearm);

for j = 1:N

    X = forearm;
    ind = unidrnd(n,1,n);
    X = X(ind);
    %classical interval
    [bootreps, bootsam] = bootstrp(B,'kurtosis',X);
    thetahat_kurt = mean(bootreps);
    SE_kurt = std(bootreps);
    CI1_kurt(j,:) = [thetahat_kurt-1.96*SE_kurt thetahat_kurt+1.96*SE_kurt];
    size1(j) = CI1_kurt(j,2)-CI1_kurt(j,1);
    if (CI1_kurt(j,1) <= true_kurt && CI1_kurt(j,2)>=true_kurt)
        count1 = count1 + 1;
    end

    k = B*alpha/2;
    bval = sort(bootreps);
    CI3_kurt(j,:) = [bval(k) bval(B-k)];
    size3(j) = CI3_kurt(j,2)-CI3_kurt(j,1);
    if (CI3_kurt(j,1) <= true_kurt && CI3_kurt(j,2)>= true_kurt)
        count3 = count3 + 1;
    end

    %bootstrap t-interval
    sehats = zeros(size(bootreps));
    for i = 1:B
        xstar = forearm(bootsam(:,i));
        bvals(i) = kurtosis(xstar);
        sehats(i) = std(bootstrp(C,'kurtosis',xstar));
    end
    zvals = (bootreps - thetahat_kurt)./sehats;
    k = B*alpha/2;
    szval = sort(zvals);
    tlo = szval(k);
    thi = szval(B-k);
    CI2_kurt(j,:) = [thetahat_kurt-thi*SE_kurt thetahat_kurt-tlo*SE_kurt];
    size2(j) = CI2_kurt(j,2)-CI2_kurt(j,1);
    if (CI2_kurt(j,1)<=true_kurt && CI2_kurt(j,2)>=true_kurt)
        count2 = count2 + 1;
    end
end

%histogram of bootstrap replications
histogram(bootreps, 20, "Normalization", "pdf")

%Calculate mean/sd of CI lengths
CI1_kurt=mean(CI1_kurt), CI2_kurt=mean(CI2_kurt), CI3_kurt=mean(CI3_kurt)
MeanWidth1=mean(size1); MeanWidth2=mean(size2);MeanWidth3=mean(size3);
sdWidth1=std(size1);sdWidth2=std(size2);sdWidth3=std(size3);
Mean_Width=[MeanWidth1,MeanWidth2,MeanWidth3]
SD_Width=[sdWidth1,sdWidth2,sdWidth3]

%===Calculate the coverage
Coverage1=count1/N; Coverage2=count2/N; Coverage3=count3/N;
Coverage=[Coverage1,Coverage2,Coverage3]