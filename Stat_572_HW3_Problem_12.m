%Problem 7.12
load lawpop
n = length(lawpop);
r_corr = corr(lawpop(:,1), lawpop(:,2));
Tobs = ((r_corr)*sqrt(n-2))/sqrt(1-(r_corr)^2);
mu = [mean(gpa); mean(lsat)];
sigma = [std(gpa), 0; 0, std(lsat)];

M = 1000;
Tm = zeros(1,M);
for i = 1:M
    xs = mvnrnd(mu, sigma, n);
    xs_corr = corr(xs(:,1), xs(:,2));
    Tm(i) = ((xs_corr)*sqrt(n-2))/sqrt(1-(xs_corr)^2);
end

alpha = 0.05;
crit_val1 = csquantiles(Tm, alpha/2)
crit_val2 = csquantiles(Tm, 1-(alpha/2))
p_val = 2*length(find(Tm >= Tobs))/M

figure(1)
h = histogram(Tm,'Normalization','pdf')
f.FaceColor='w'
hold on
plot([crit_val1,crit_val1], [0,.5], '--r')
plot([crit_val2,crit_val2], [0,.5], '--r')
plot(Tobs,0,'xb', 'MarkerSize', 20)

legend('simulate test stat','critical value','Observe test stat')
annotation('textbox',[0.3 0.8 0.1 0.1],'String',"p-value is " + p_val)
hold off