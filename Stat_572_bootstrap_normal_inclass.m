% Bootstrap In-class

n = 20;
alpha = 0.05;
B = 400; C=25; N=100;
count1=0; count2=0; count3=0; 
size1=zeros(N,1);size2=zeros(N,1);size3=zeros(N,1);
CI1=zeros(N,2);CI2=zeros(N,2);CI3=zeros(N,2);
true=2;
%true=1.387;

for j = 1:N
  mydata=normrnd(2,1,n,1);
  %mydata=chi2rnd(2,n,1);
  thetahat = median(mydata);

% ===Standard Method====================================
  [bootreps, bootsam] = bootstrp(B,'median',mydata);
  SE = std(bootreps);
  CI1(j,:) =[thetahat-1.96*SE thetahat+1.96*SE]; 
  size1(j)=CI1(j,2)-CI1(j,1);
    if (CI1(j,1)<=true && CI1(j,2)>=true)
      count1=count1+1;
    end

% ===Bootsrap Percentile================================
  k = B*alpha/2;
  bval = sort(bootreps);
  CI3(j,:) = [bval(k) bval(B-k)]; 
  size3(j)=CI3(j,2)-CI3(j,1);
    if (CI3(j,1)<=true && CI3(j,2)>=true)
      count3=count3+1;
    end

% ===Bootstrap-t Method====================================

% Get the bootstrap replicates and samples.
% Set up some storage space for the SE’s.
sehats = zeros(size(bootreps));
% Each column of bootsam contains indices 
% to a bootstrap sample.
   for i = 1:B
    		% extract the sample from the data 
				xstar = mydata(bootsam(:,i));
      bvals(i) = median(xstar);
   % Do bootstrap using that sample to estimate SE.
      sehats(i) = std(bootstrp(C,'median',xstar));
  end
  zvals = (bootreps - thetahat)./sehats;
% Get the quantiles.
  k = B*alpha/2;
  szval = sort(zvals);
  tlo = szval(k);
  thi = szval(B-k);
% Get the endpoints of the interval.
  CI2(j,:) = [thetahat-thi*SE thetahat-tlo*SE]; 
  size2(j)=CI2(j,2)-CI2(j,1);
    if (CI2(j,1)<=true && CI2(j,2)>=true)
      count2=count2+1;
    end
end

% Histogram of the last Bootstrap replications
histogram(bootreps,20,"Normalization","pdf")

%===Calculate mean and standard deviaion of length of CI=== 
CI1=mean(CI1), CI2=mean(CI2), CI3=mean(CI3)
MeanWidth1=mean(size1); MeanWidth2=mean(size2);MeanWidth3=mean(size3);
sdWidth1=std(size1);sdWidth2=std(size2);sdWidth3=std(size3);
Mean_Width=[MeanWidth1,MeanWidth2,MeanWidth3]
SD_Width=[sdWidth1,sdWidth2,sdWidth3]

%===Calculate the coverage
Coverage1=count1/N; Coverage2=count2/N; Coverage3=count3/N;
Coverage=[Coverage1,Coverage2,Coverage3]