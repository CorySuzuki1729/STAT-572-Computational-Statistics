load forearm
alpha = 0.05;
n = length(forearm);
B = 200;
C = 25;
N = 100;
count1 = 0;
count2 = 0;
count3 = 0;
size1 = zeros(N,1);
size2 = zeros(N,1);
size3 = zeros(N,1);

CI1_mom = zeros(N,2);
CI2_mom = zeros(N,2);
CI3_mom = zeros(N,2);

true_mom = mom(forearm);

for j = 1:N
    X = forearm;
    ind = unidrnd(n,1,n);
    X = X(ind);

    %classical interval
    [bootreps, bootsam] = bootstrp(B,'mom',X);
    thetahat_mom = mean(bootreps);
    SE_mom = std(bootreps);
    CI1_mom(j,:) = [thetahat_mom-1.96*SE_mom thetahat_mom+1.96*SE_mom];
    size1(j) = CI1_mom(j,2)-CI1_mom(j,1);
    if (CI1_mom(j,1) <= true_mom && CI1_mom(j,2)>=true_mom)
        count1 = count1 + 1;
    end

    k = B*alpha/2;
    bval = sort(bootreps);
    CI3_mom(j,:) = [bval(k) bval(B-k)];
    size3(j) = CI3_mom(j,2)-CI3_mom(j,1);
    if (CI3_mom(j,1) <= true_mom && CI3_mom(j,2)>= true_mom)
        count3 = count3 + 1;
    end

    %bootstrap t-interval
    sehats = zeros(size(bootreps));
    for i = 1:B
        xstar = forearm(bootsam(:,i));
        bvals(i) = mom(xstar);
        sehats(i) = std(bootstrp(C,'mom',xstar));
    end
    zvals = (bootreps - thetahat_mom)./sehats;
    k = B*alpha/2;
    szval = sort(zvals);
    tlo = szval(k);
    thi = szval(B-k);
    CI2_mom(j,:) = [thetahat_mom-thi*SE_mom thetahat_mom-tlo*SE_mom];
    size2(j) = CI2_mom(j,2)-CI2_mom(j,1);
    if (CI2_mom(j,1)<=true_mom && CI2_mom(j,2)>=true_mom)
        count2 = count2 + 1;
    end
end

%histogram of bootstrap replications
histogram(bootreps, 25, "Normalization", "pdf")

%Calculate mean/sd of CI lengths
CI1_mom=mean(CI1_mom), CI2_mom=mean(CI2_mom), CI3_mom=mean(CI3_mom)
MeanWidth1=mean(size1); MeanWidth2=mean(size2);MeanWidth3=mean(size3);
sdWidth1=std(size1);sdWidth2=std(size2);sdWidth3=std(size3);
Mean_Width=[MeanWidth1,MeanWidth2,MeanWidth3]
SD_Width=[sdWidth1,sdWidth2,sdWidth3]

%===Calculate the coverage
Coverage1=count1/N; Coverage2=count2/N; Coverage3=count3/N;
Coverage=[Coverage1,Coverage2,Coverage3]