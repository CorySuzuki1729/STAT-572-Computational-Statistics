%Problem 7.5
load mcdata
n = length(mcdata);
sigma = 7.8;
alpha = 0.05;
sigma_bar = sigma/sqrt(n);
Tobs = (mean(mcdata)-454)/sigma_bar;
normplot(mcdata)

M = 1000;
Tm = zeros(1,M);
for i = 1:M
    xs = sigma*randn(1,n) + 454;
    Tm(i) = (mean(xs)-454)/sigma_bar;
end

crit_val1 = csquantiles(Tm, alpha/2)
crit_val2 = csquantiles(Tm, 1-alpha/2)
p_val = 2*length(find(Tobs >= Tm))/M

figure(1)
h=histogram(Tm,'Normalization','pdf')
h.FaceColor='w'

hold on
plot([crit_val1,crit_val1], [0, .1],'--r')
plot([crit_val2,crit_val2], [0, .1], '--r')
plot(Tobs,0,'xb','MarkerSize',20)

legend('simulate test stat','critical value','Observe test stat')
annotation('textbox',[0.3 0.8 0.1 0.1],'String',"p-value is " + p_val)
hold off