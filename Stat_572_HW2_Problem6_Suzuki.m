%Problem 6
function [] = Stat_572_HW2_Problem6_Suzuki(df_chi)
n = 1000;
x = 0:.01:25;

for i=2:length(x)
    a = x(i);
    Suzuki_chisq(i) = integral(@(a)chi2pdf(a, df_chi),0,a);
end

for i = 1:n
    u = unifrnd(0,1);
    placement = Suzuki_chisq;
    for j = 1:length(x)
        if placement(j) < u
            placement(j)=1;
        end
    end
    [c,ind] = min(placement);
    chi2rv(i) = x(ind);
end

y = chi2pdf(x,df_chi);

[f,h] = hist(chi2rv);
f = f/(h(2)-h(1))/n;
subplot(121)
bar(h,f,1,'w')
hold on
plot(x,y,'r')
hold off
title('Chi Squared rs using alt procedure')
xlim([0,25])
end