% x=-3:.1:3;
% pdf=normpdf(x,0,1);
% cdf=normcdf(x,0,1);
% 
% subplot(121),plot(x,pdf,'-')
% title('pdf N(0,1)')
% xlabel('X'),ylabel('f(x)')
% axis([-3.5 3.5 0 0.5])
% 
% subplot(122),plot(x,cdf,'-')
% title('cdf N(0,1)')
% xlabel('X'),ylabel('F(x)')
% axis([-3.5 3.5 0 1])

x = binopdf(3,25,.2)
for i:3 
    sum = 0;
    y = binopdf(1,25,.2);
    sum = sum + y;
    i = i + 1;
end
