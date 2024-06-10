% clear;
% n = 5000;
% alphas = [3, 0.5];
% betas = [3, 0.5];
% nacc = 0;
% nrej = 0;
% 
% for i = 1:2
%     a = alphas(i);
%     b = betas(i);
%     X_mh = zeros(1,n);
%     X_mh(1) = rand;
%     for j = 1:(n-1)
%         y = unifrnd(X_mh(j)-0.5, X_mh(j)+0.5);
%         u = rand(1);
%         num = betapdf(y,a,b);
%         den = betapdf(X_mh(j),a,b);
%         acc = min(1, (num/den));
%         if (u <= acc) && (y > 0)
%             X_mh(j+1) = y;
%             nacc = nacc + 1;
%         else
%             X_mh(j+1) = X_mh(j);
%             nrej = nrej + 1;
%         end
%     end
%      
%     %burn in 5%
%     ind = floor(.05*numel(X_mh))+1;
%     X_mh = X_mh(ind:end);
% 
%     %Kernel density estimate
%     xs = [0.01:.01:0.99]; %axis of test values
%     ns = length(xs);
%     sig_squig = min(std(X_mh),iqr(X_mh)/1.348);
%     hN = 1.06*sig_squig*n^(-1/5);
%     fhatN=zeros(size(xs));
%     for i = 1:length(X_mh)
%         f=exp(-(1/(2*hN^2))*(xs-X_mh(i)).^2)/sqrt(2*pi)/hN;
%         fhatN = fhatN+f/(n);
%     end
%     
%     %Plotting
%     figure(1); subplot(1,2,i);
%     [N,h] = hist(X_mh,12); %histogram parameters
%     N = N/(h(2)-h(1))/length(X_mh); %resize histogram
%     bar(h,N,1); hold on; %plot density histogram
%     plot(xs,fhatN); %plot normal KDE
%     plot(xs,betapdf(xs,a,b)); %plot true density
%     betatext = sprintf('Beta(%1.1f,%1.1f)', a,b);
%     legend('M-H generated data' ,'Normal KDE', betatext);
% 
%     %ISE
%     ISE(i) = sum((fhatN - betapdf(xs,a,b)).^2);
% 
% end
% 
% mix_rate = nacc/n;
% mix_rate

clear all; close all;
figure(1);clf; %initialize figure
n = 300; %sample size
as = [3 0.5]; %values for alpha
bs = [3 0.5]; %values for beta


% Step 2 - Generate r.s. using M-H
for k = 1:2
    a = as(k); %retrieve value for alpha
    b = bs(k); %retrieve value for beta
    X_mh = zeros(1,n); %pre-allocate space
    X_mh(1) = rand; %generate initial value
    for i = 1:(n-1)
        % Generate candidate from proposoal distribution
        y = unifrnd(X_mh(i)-.5,X_mh(i)+.5);
        % Generate a uniform for comparison
        u = rand(1);
        num = betapdf(y,a,b);
        den = betapdf(X_mh(i),a,b);
        alpha = min(1,num/den); %prob of acceptance
        if u <= alpha && y > 0 %accept
            X_mh(i+1) = y; 
        else %reject
            X_mh(i+1) = X_mh(i); 
        end
    end
    
    % Burn in 5%
    ind = floor(.05*numel(X_mh))+1; %index starting after 5%
    X_mh = X_mh(ind:end); %remove first 5%
    
    % Step 3 - Kernel density estimate
    xs = [0.01:.01:0.99]; %axis of test values
    ns = length(xs);
    sig_squig = min(std(X_mh),iqr(X_mh)/1.348);
    hN = 1.06*sig_squig*n^(-1/5);
    fhatN=zeros(size(xs));
    for i = 1:length(X_mh)
        f=exp(-(1/(2*hN^2))*(xs-X_mh(i)).^2)/sqrt(2*pi)/hN;
        fhatN = fhatN+f/(n);
    end
    
    % Step 4 - Plotting
    figure(1); subplot(1,2,k);
    [N,h] = hist(X_mh,12); %histogram parameters
    N = N/(h(2)-h(1))/length(X_mh); %resize histogram
    bar(h,N,1); hold on; %plot density histogram
    plot(xs,fhatN); %plot normal KDE
    plot(xs,betapdf(xs,a,b)); %plot true density
    betatext = sprintf('Beta(%1.1f,%1.1f)', a,b);
    legend('M-H generated data' ,'Normal KDE', betatext);
    
    % Step 5 - ISE of estimate in KDE
    ISE(k) = sum((fhatN - betapdf(xs,a,b)).^2);

    mc_n = 300;
    for i = 1:mc_n
        X_mc = zeros(1,n);
        X_mc(1) = rand;
        for j = 1:(n-1)
            y = unifrnd(X_mc(j)-0.5,X_mc(j)+0.5);
            u = rand(1);
            num = betapdf(y,a,b);
            den = betapdf(X_mc(j),a,b);
            alpha = min(1, (num/den));
            if u <= alpha && y > 0
                X_mc(j+1) = y;
            else
                X_mc(j+1) = X_mc(j);
            end
        end

        index_burn = floor(.05*numel(X_mc)) + 1;
        X_mc = X_mc(index_burn:end);

        fhatN_mc{i} = zeros(size(xs));

        for m = 1:length(X_mc)
            f=exp(-(1/(2*hN^2))*(xs-X_mh(m)).^2)/sqrt(2*pi)/hN;
            fhatN_mc{i} = fhatN_mc{i} + f/(n);
        end
    end

    ind2 = find(xs == 0.02);
    ind5 = find(xs == 0.5);
    ind8 = find(xs == 0.08);

    true_2 = betapdf(0.02, 3, 2);
    true_5 = betapdf(0.5, 3, 2);
    true_8 = betapdf(0.08, 3, 2);

    SE2 = zeros(1, mc_n);
    SE5 = zeros(1, mc_n);
    SE8 = zeros(1, mc_n);

    for i = 1:mc_n 
        SE2(i) = (fhatN_mc{i}(ind2) - betapdf(0.2, a,b)).^2;
        SE5(i) = (fhatN_mc{i}(ind5) - betapdf(0.5, a,b)).^2;
        SE8(i) = (fhatN_mc{i}(ind8) - betapdf(0.8,a,b)).^2;
    end

    MSE2(k) = mean(SE2);
    MSE5(k) = mean(SE5);
    MSE8(k) = mean(SE8);
end

MSE2
MSE5
MSE8
