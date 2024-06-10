%In class example
mu0 = 5;
sig2 = 0.25;
phi = [0.4 0.9 1 1.1];
n = 500;
chain1 = mu0; chain2 = mu0;
chain3 = mu0; chain4 = mu0;

for i = 1:(n-1)
    chain1(i+1) = phi(1)*chain1(i)+sqrt(sig2)*randn;
    chain2(i+1) = phi(2)*chain2(i)+sqrt(sig2)*randn;
    chain3(i+1) = phi(3)*chain3(i)+sqrt(sig2)*randn;
    chain4(i+1) = phi(4)*chain4(i)+sqrt(sig2)*randn;
end

figure(1); clf;
subplot(411); plot(chain1); legend('\phi = 0.4'); legend('boxoff');
subplot(412); plot(chain2); legend('\phi = 0.9'); legend('boxoff');
subplot(413); plot(chain3); legend('\phi = 1.0'); legend('boxoff');
subplot(414); plot(chain4); legend('\phi = 1.1'); legend('boxoff');