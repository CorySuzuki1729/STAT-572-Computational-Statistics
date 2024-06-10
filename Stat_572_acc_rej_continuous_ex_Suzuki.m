%In-class example
%fun = 20*y*(1-y)^3;
c = 2.1;   % constant 
n=10000;  % generate 1000 rv's
% set up the arrays to store variates
x = zeros(1,n);  						% random variates
xy = zeros(1,n);						% corresponding y values
rej = zeros(1,n);						% rejected variates
rejy = zeros(1,n); % corresponding y values
irv=1;			
irej=1;
while irv <= n
   y = rand(1);  % random number from g(y)
   u = rand(1);  % random number for comparison
   if u <= (20*y*(1-y)^3)/c;
      x(irv)=y;
      xy(irv) = u*c;
      irv=irv+1
   else
             rej(irej)= y;
      rejy(irej) = u*c; % really comparing u*c<=2*y
      irej = irej + 1
   end
end

acceptance = irv/(irv+irej);
acceptance

figure(1)
plot(x, xy, "o", rej, rejy, "*")
hold on
xx = 0:0.01:1;
yy = 20.*xx.*(1-xx).^3;
plot(xx,yy, "k")
axis([0 1 0 c])
axis square
hold off

figure(2)
histogram(x, 20, "normalization", "pdf")
axis square
hold on
xx = 0:0.01:1;
yy = 20.*xx.*(1-xx).^3;
plot(xx,yy, "k")
hold off