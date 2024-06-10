load forearm
n = length(forearm);
alpha = 0.05;
B = 400;
C = 25;
N = 100;
count1 = 0;
count2 = 0;
count3 = 0;
count4 = 0;
count5 = 0;
count6 = 0;
count7 = 0;
count8 = 0;
count9 = 0;

size1 = zeros(N,1);
size2 = zeros(N,1);
size3 = zeros(N,1);
size4 = zeros(N,1);
size5 = zeros(N,1);
size6 = zeros(N,1);
size7 = zeros(N,1);
size8 = zeros(N,1);
size9 = zeros(N,1);

CI1_skew = zeros(N,2);
CI2_skew = zeros(N,2);
CI3_skew = zeros(N,2);

CI1_kurt = zeros(N,2);
CI2_kurt = zeros(N,2);
CI3_kurt = zeros(N,2);

CI1_mom = zeros(N,2);
CI2_mom = zeros(N,2);
CI3_mom = zeros(N,2);

true1 = 0;
true2 = 0;
true3 = 0;

for j = 1:N
    thetahat1 = skewness(forearm);
    thetahat2 = kurtosis(forearm);
    thetahat3 = mom(forearm);

    %Classical Intervals
    [bootreps1, bootsam1] = bootstrp(B,'skewness',forearm);
    [bootreps2, bootsam2] = bootstrp(B, 'kurtosis',forearm);
    [bootreps3, bootsam3] = bootstrp(B, 'mom', forearm);
    SE_skew = std(bootreps1);
    SE_kurt = std(bootreps2);
    SE_mom = std(bootreps3);
    CI1_skew(j,:) = [thetahat1-1.96*SE_skew thetahat1+1.96*SE_skew];
    size1(j) = CI1_skew(j,2)-CI1_skew(j,1);
    CI1_kurt(j,:) = [thetahat2-1.96*SE_kurt thetahat2+1.96*SE_kurt];
    size4(j) = CI1_kurt(j,2)-CI1_kurt(j,1);
    CI1_mom(j,:) = [thetahat3-1.96*SE_mom thetahat3+1.96*SE_mom];
    size7(j) = CI1_mom(j,2)-CI1_mom(j,1);
    if (CI1_skew(j,1)<=true1 && CI1_skew(j,2)>=true1)
        count1 = count1 + 1;
    end
    if (CI1_kurt(j,1)<=true2 && CI1_kurt(j,2)>=true2)
        count4 = count4 + 1;
    end
    if (CI1_mom(j,1)<=true3 && CI1_mom(j,2)>=true3)
        count7 = count7 + 1;
    end

    %bootsrap percentile intervals
    k = B*alpha/2;
    bval1 = sort(bootreps1);
    bval2 = sort(bootreps2);
    bval3 = sort(bootreps3);
    CI3_skew(j,:) = [bval1(k) bval1(B-k)];
    size3(j) = CI3_skew(j,2)-CI3_skew(j,1);
    CI3_kurt(j,:) = [bval2(k), bval2(B-k)];
    size6(j) = CI3_kurt(j,2)-CI3_kurt(j,1);
    CI3_mom(j,:) = [bval3(k), bval3(B-k)];
    size9(j) = CI3_mom(j,2)-CI3_mom(j,1);
    if (CI3_skew(j,1) <= true1 && CI3_skew(j,2)>= true1)
        count3 = count3 + 1;
    end
    if (CI3_kurt(j,1) <= true2 && CI3_kurt(j,2)>= true2)
        count6 = count6 + 1;
    end
    if (CI3_mom(j,1) <= true3 && CI3_mom(j,2)>= true3)
        count9 = count9 + 1;
    end

    %bootstrap t-intervals
    sehats1 = zeros(size(bootreps1));
    sehats2 = zeros(size(bootreps2));
    sehats3 = zeros(size(bootreps3));
    for i = 1:B
        xstar1 = forearm(bootsam1(:,i));
        xstar2 = forearm(bootsam2(:,i));
        xstar3 = forearm(bootsam3(:,i));
        bvals1(i) = skewness(xstar1);
        bvals2(i) = kurtosis(xstar2);
        bvals3(i) = mom(xstar3);
        sehats1(i) = std(bootstrp(C,'skewness', xstar1));
        sehats2(i) = std(bootstrp(C, 'kurtosis', xstar2));
        sehats3(i) = std(bootstrp(C,'mom', xstar3));
    end
    zvals1 = (bootreps1 - thetahat1)./sehats1;
    zvals2 = (bootreps2 - thetahat2)./sehats2;
    zvals3 = (bootreps3 - thetahat3)./sehats3;
    szvals1 = sort(zvals1);
    szvals2 = sort(zvals2);
    szvals3 = sort(zvals3);
    tlo_1 = szvals1(k);
    thi_1 = szvals1(B-k);
    tlo_2 = szvals2(k);
    thi_2 = szvals2(B-k);
    tlo_3 = szvals3(k);
    thi_3 = szvals3(B-k);
    %bootstrap t interval endpoints
    CI2_skew(j,:) = [thetahat1-tlo_1*SE_skew thetahat1-thi_1*SE_skew];
    size2(j) = CI2_skew(j,2)-CI2_skew(j,1);
    CI2_kurt(j,:) = [thetahat2-tlo_2*SE_kurt thetahat2-thi_2*SE_kurt];
    size5(j) = CI2_kurt(j,2)-CI2_kurt(j,1);
    CI2_mom(j,:) = [thetahat3-tlo_3*SE_mom thetahat3-thi_3*SE_mom];
    size8(j) = CI2_mom(j,2)-CI2_mom(j,1);
    if(CI2_skew(j,1)<=true1 && CI2_skew(j,2)>= true1)
        count2 = count2 + 1;
    end
    if(CI2_kurt(j,1)<=true2 && CI2_kurt(j,2)>=true2)
        count5 = count5 + 1;
    end
    if(CI2_mom(j,1)<=true3 && CI2_mom(j,2)>=true3)
        count8 = count8 + 1;
    end
end

%Histograms of Bootstrap Replications
figure(1)
histogram(bootreps1, 20, 'Normalization', 'pdf')
figure(2)
histogram(bootreps2, 20, 'Normalization', 'pdf')
figure(3)
histogram(bootreps3, 20, 'Normalization', 'pdf')

%means and stds of CI lengths
CI1_skew = mean(CI1_skew);
CI1_kurt = mean(CI1_kurt);
CI1_mom = mean(CI1_mom);
CI2_skew = mean(CI2_skew);
CI2_kurt = mean(CI2_kurt);
CI2_mom = mean(CI2_mom);
CI3_skew = mean(CI3_skew);
CI3_kurt = mean(CI3_kurt);
CI3_mom = mean(CI3_mom);
meanwidth1 = mean(size1);
meanwidth2 = mean(size2);
meanwidth3 = mean(size3);
meanwidth4 = mean(size4);
meanwidth5 = mean(size5);
meanwidth6 = mean(size6);
meanwidth7 = mean(size7);
meanwidth8 = mean(size8);
meanwidth9 = mean(size9);
sdwidth1 = std(size1);
sdwidth2 = std(size2);
sdwidth3 = std(size3);
sdwidth4 = std(size4);
sdwidth5 = std(size5);
sdwidth6 = std(size6);
sdwidth7 = std(size7);
sdwidth8 = std(size8);
sdwidth9 = std(size9);
mean_width = [meanwidth1, meanwidth2, meanwidth3, meanwidth4, meanwidth5, meanwidth6, meanwidth7, meanwidth8, meanwidth9]
std_width = [sdwidth1, sdwidth2, sdwidth3, sdwidth4, sdwidth5, sdwidth6, sdwidth7, sdwidth8, sdwidth9]

%Coverage Calculation
coverage1 = count1/N;
coverage2 = count2/N;
coverage3 = count3/N;
coverage4 = count4/N;
coverage5 = count5/N;
coverage6 = count6/N;
coverage7 = count7/N;
coverage8 = count8/N;
coverage9 = count9/N;
coverage = [coverage1, coverage2, coverage3, coverage4, coverage5, coverage6, coverage7, coverage8, coverage9]
