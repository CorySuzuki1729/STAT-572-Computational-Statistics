% data = chi2rnd(5,200,1);
% n = length(data);
% alpha = 0.05;
% xbar = mean(data);
% B = 200;
% N = 100;
% k = B*alpha/2;
% size_mean = zeros(N,1);
% bootper = zeros(N,2);
% count_mean = 0;
% true_mean = 5;
% true_sd = sqrt(10);
% true_median = chi2rnd(5,10000,1);
% 
% bootreps_mean = bootstrp(B, 'mean', data);
% bootbias1 = mean(bootreps_mean)-mean(data);
% bootse1 = std(bootreps);
% 
% for i = 1:N
%     bval = sort(bootreps_mean);
%     bootper(i,:) = [bval(k) bval(B-k)];
%     size_mean(i) = bootper(i,2)-bootper(i,1);
%     if (bootper(i,1)<=true_mean && bootper(i,2)>=true_mean)
%         count_mean = count_mean + 1;
%     end
% end
% 
% [b1, se1, jvals] = csjack(data, 'mean');
% jvalinf = mean(jvals) + sqrt(n-1)*(jvals-mean(jvals));
% jackbias1 = (n-1)*(mean(jvals)-mean(data));
% jackse1 = std(jvalinf,1);
% 
% figure(1)
% subplot(321)
% histogram(bootreps_mean)
% axis([5-1 5+1 0 100])
% title('bootstrap mean')
% 
% subplot(322)
% histogram(jvalinf)
% axis([5-1 5+1 0 100])
% title('inflated jacknife: mean')
% 
% [jlo,jhi, jvalue, zo, ahat] = csbootbca(data,'mean',B,alpha)
% 
% bootreps_median = bootstrp(B,'median',data);
% 
% [b2 se2 jvals2] = csjack(data, 'median')
% jvalinf2 = mean(jvals2) + sqrt(n-1)*(jvals2-mean(jvals2));
% jackbias2 = (n-1)*(mean(jvals2)-mean(data));
% jackse2 = std(jvalinf2,1);
% 
% figure(2)
% subplot(321)
% histogram(bootreps_median)
% axis([5-1 5+1 0 100])
% title('bootstrap median')
% 
% subplot(322)
% histogram(jvalinf2)
% axis([5-1 5+1 0 100])
% title('inflated jacknife: median')
% 
% bootreps_sd = bootstrp(B,'std',data);
% 
% [b3 se3 jvals3] = csjack(data, 'std')
% jvalinf3 = mean(jvals3) + sqrt(n-1)*(jvals3-mean(jvals3));
% jackbias3 = (n-1)*(mean(jvals3)-mean(data));
% jackse3 = std(jvalinf3,1);
% 
% figure(3)
% subplot(321)
% histogram(bootreps_sd)
% axis([0 5 0 100])
% title('bootstrap std')
% 
% subplot(322)
% histogram(jvalinf3)
% axis([0 5 0 100])
% title('inflated jacknife: std')
% 
% bootper = mean(bootper);
% meanwidth_boot = mean(size_mean);
% sdwidth_mean = std(size_mean);
% coverage_mean = count_mean/N

lambda=5;
data=chi2rnd(lambda,200,1);
n=length(data);
alpha=.05;
N=100;

%========================================================%
%=========== Mean =======================================%
%========================================================%

%%%%#1 Bootstrap Bias and SE%%%%%%%%%%%%%%%%%%%
bootreps=bootstrp(n,'mean',data);
bootbias1=mean(bootreps)-mean(data)
bootse1=std(bootreps)

%%%%#2 Jack Bias and SE%%%%%%%%%%%%%%%%%%%
[b1,se1,jvals]=csjack(data,'mean');
jvalinf=mean(jvals)+sqrt(n-1)*(jvals-mean(jvals));
jackbias1=(n-1)*(mean(jvals)-mean(data))
jackse1=std(jvalinf,1)

figure(1)
subplot(321)
histogram(bootreps)
axis([lambda-1 lambda+1 0 100])
title('bootstrap:mean')

subplot(322)
histogram(jvalinf)
axis([lambda-1 lambda+1 0 100])
title('inflated jackknief:mean')

%%%%%%#3 Boot Intervals %%%%%%%%%%%%%%%%%%%
count1=0; count2=0;
for j = 1:N
    data=chi2rnd(lambda,n,1);
    %for Percentile interval 
    bootreps=bootstrp(n,'mean',data); 
    k=n*alpha/2; bootsort=sort(bootreps);
    Bpi=[bootsort(k) bootsort(n-k)];
    Bootwidth(j)=Bpi(2)-Bpi(1);
        if(Bpi(1)<lambda && Bpi(2)>lambda);
            count1=count1+1;
        end
    %%For BootBca interval%%%
    [bcaLow, bcaHigh, bvals]=csbootbca(data,'mean',n,alpha);
    BCAwidth(j)=bcaHigh-bcaLow;
        if(bcaLow<lambda && bcaHigh>lambda)
            count2=count2+1;
        end
end
PCImean=Bpi, BCAmean=[bcaLow bcaHigh]
PCImeanCoverage=count1/N
BCAmeanCoverage=count2/N
MeanwidthPCImean=mean(Bootwidth)
MeanwidthBCAmean=mean(BCAwidth)
SDwidthPCImean=std(Bootwidth)
SDwidthBCAmean=std(BCAwidth)


%========================================================%
%=========== Median =======================================%
%========================================================%

%%%%#1 Boot Bias and SE%%%%%%%%%%%%%%%%%%%
bootreps=bootstrp(n,'median',data);
bootbias2=mean(bootreps)-median(data)
bootse2=std(bootreps)

%%%%#2 Jack Bias and SE%%%%%%%%%%%%%%%%%%%
[b1,se1,jvals]=csjack(data,'median');
jvalinf=mean(jvals)+sqrt(n-1)*(jvals-mean(jvals));
jackbias2=(n-1)*(mean(jvals)-median(data))
jackse2=std(jvalinf,1)

subplot(323)
histogram(bootreps)
axis([3 6 0 100])
title('bootstrap:median')

subplot(324)
histogram(jvalinf)
axis([3 6 0 100])
title('inflated jackknief:median')

%%%%%%#3 Boot Intervals %%%%%%%%%%%%%%%%%%%

% estimate the true median

estmedian=median(chi2rnd(5,10000,1));

count1=0; count2=0;
for j = 1:N
    data=chi2rnd(lambda,n,1);
    %for Percentile interval 
    bootreps=bootstrp(n,'median',data); 
    k=n*alpha/2; bootsort=sort(bootreps);
    Bpi=[bootsort(k) bootsort(n-k)];
    Bootwidth(j)=Bpi(2)-Bpi(1);
        if(Bpi(1)<estmedian && Bpi(2)>estmedian);
            count1=count1+1;
        end
    %%For BootBca interval%%%
    [bcaLow, bcaHigh, bvals]=csbootbca(data,'median',n,alpha);
    BCAwidth(j)=bcaHigh-bcaLow;
        if(bcaLow<estmedian && bcaHigh>estmedian);
            count2=count2+1;
        end
end
PCImedian=Bpi, BCAmedian=[bcaLow bcaHigh]
PCImedianCoverage=count1/N
BCAmedianCoverage=count2/N
MeanwidthPCImedian=mean(Bootwidth)
MeanwidthBCAmedian=mean(BCAwidth)
SDwidthPCImedian=std(Bootwidth)
SDwidthBCAmedian=std(BCAwidth)

%===================================================%
%========= SD ======================================%
%===================================================%

%%%%#1 Boot Bias and SE%%%%%%%%%%%%%%%%%%%
bootreps=bootstrp(n,'std',data);
bootbias3=mean(bootreps)-std(data)
bootse3=std(bootreps)

%%%%#2 Jack Bias and SE%%%%%%%%%%%%%%%%%%%
[b1,se1,jvals]=csjack(data,'std');
jvalinf=mean(jvals)+sqrt(n-1)*(jvals-mean(jvals));
jackbias3=(n-1)*(mean(jvals)-std(data))
jackse3=std(jvalinf,1)

subplot(325)
histogram(bootreps)
axis([sqrt(2*lambda)-1 sqrt(2*lambda)+1 0 100])
title('bootstrap:SD')

subplot(326)
histogram(jvalinf)
axis([sqrt(2*lambda)-1 sqrt(2*lambda)+1 0 100])
title('inflated jackknief:SD')

%%%%%%#3 Boot Intervals %%%%%%%%%%%%%%%%%%%
count1=0; count2=0;
for j = 1:N
    data=chi2rnd(lambda,200,1);
    %for Percentile interval 
    bootreps=bootstrp(n,'std',data); 
    k=n*alpha/2; bootsort=sort(bootreps);
    Bpi=[bootsort(k) bootsort(n-k)];
    Bootwidth(j)=Bpi(2)-Bpi(1);
        if(Bpi(1)<sqrt(2*lambda) && Bpi(2)>sqrt(2*lambda))
            count1=count1+1;
        end
    %%For BootBca interval%%%
    [bcaLow, bcaHigh, bvals]=csbootbca(data,'std',n,alpha);
    BCAwidth(j)=bcaHigh-bcaLow;
        if(bcaLow<sqrt(2*lambda) && bcaHigh>sqrt(2*lambda));
            count2=count2+1;
        end
end
PCIsd=Bpi, BCAsd=[bcaLow bcaHigh]
PCIsdCoverage=count1/N
BCAsdCoverage=count2/N
MeanwidthPCIsd=mean(Bootwidth)
MeanwidthBCAsd=mean(BCAwidth)
SDwidthPCIsd=std(Bootwidth)
SDwidthBCAsd=std(BCAwidth)

