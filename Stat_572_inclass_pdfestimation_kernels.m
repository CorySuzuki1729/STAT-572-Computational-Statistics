%In Class Exercise
load geyser
data=geyser;

n = length(data);

h = 2.15*sqrt(var(data))*n^(-1/5);


t0 = min(data)-1;
tm = max(data)+1;
bins = t0:h:tm;
vk = histc(data,bins);
vk(end) = [];
fhat = vk/(n*h);

% For freq polygon, get the bin centers, with empty
% bin center on each end.
bc2=(t0-h/2):h:(tm+h/2);
binh = [0 fhat 0];
% Use linear interpolation between bin centers
% get the interpolated values at x.
xinterp = linspace(min(bc2),max(bc2));
fp = interp1(bc2, binh, xinterp);
% to plot this, use bar with the bin centers
tm = max(bins);
bc = (t0+h/2):h:(tm-h/2);
bar(bc,fhat,1,'w')
hold on

axis([40 110 0 0.04])
area = trapz(xinterp,fp);


x = linspace(t0,tm,1000); len=length(x);
fhatN = zeros(size(x));
sigdelta=min(std(data),iqr(data)/1.348);
hN = 1.06*n^(-1/5)*sigdelta;

for i=1:n
   % normal kernel
  f = normpdf(x,data(i),hN);
   fhatN = fhatN+f/(n);
end

fhatE = zeros(size(x));
hE=hN *(30*sqrt(pi))^0.2;
for i=1:n
   % Epanechnikov kernel
   dom=(x-data(i))/hE;
   for j=1:len
       if abs(dom(j))<=1
        f(j)=(3/4)*(1-((x(j)-data(i))/hE).^2)/hE;
       else
       f(j)=0;
       end
   end
   fhatE = fhatE+f/(n);
end

plot(x,fhatN,'b',x,fhatE,'r');
legend('Histogram','Normal Kernel','Epanechnikov kernel')
hold off