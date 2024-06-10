%Stat 572 HW2 Part A

%Writing the accept/reject algorithm.

n = 1000;
c = 1/3;
funy1 = @(y) (y-1)./12;
funy2 = @(y) (y-7)./(-6);
x = zeros(1,n);
xy = zeros(1,n);
rej = zeros(1,n);
rejy = zeros(1,n);
index_rv = 1;
irej = 1;
%if-else chain controls which pdf
%to compare to.
while index_rv <= n
    y = unifrnd(1,7);
    u = unifrnd(0,1);
    if y <= 5 && u <= (((y-1)./12)/c)
        x(index_rv) = y;
        xy(index_rv) = u*c;
        index_rv = index_rv + 1;
    elseif y > 5 && u <= (((y-7)./(-6))/c)
        x(index_rv) = y;
        xy(index_rv) = u*c;
        index_rv = index_rv + 1;
    else
        rej(irej) = y;
        rejy(irej) = u*c;
        irej = irej + 1;
    end
end

%Calculate the acceptance rate.
acceptance_rate = index_rv/(irej+index_rv);
acceptance_rate

%Superimpose true density and
%graph results from algorithm.
figure(1)
plot(x, xy, "o", rej, rejy, "*")
hold on
xx1 = 1:0.01:5;
xx2 = 5:0.01:7;
plot(xx1,funy1(xx1), 'k', xx2,funy2(xx2), 'k')
axis([1 7 0 c])
hold off

figure(2)
histogram(x, 20, "normalization", "pdf")
axis square
hold on
xx1 = 1:0.01:5;
xx2 = 5:0.01:7;
plot(xx1,funy1(xx1), 'k', xx2,funy2(xx2), 'k')
axis square
hold off