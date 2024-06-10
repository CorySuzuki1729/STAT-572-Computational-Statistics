%Newton-Raphson 1-D Method for MLE's
r = geornd(0.2, 100, 1);
ybar = mean(r);
p0 = 0.1;
tol = 0.00001;
loop = 0;
max_loop = 100;
Nhat = p0+(1-p0-p0*ybar)*p0;

while abs(Nhat-p0)>tol && loop < max_loop
    p0 = Nhat;
    Nhat = p0+(1-p0-p0*ybar)*p0;
    loop = loop + 1;
end
loop, Nhat