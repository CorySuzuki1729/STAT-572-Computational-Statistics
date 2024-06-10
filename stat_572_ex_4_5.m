% function [samples] = stat_572_ex_4_5(p,n)
% n_disc = length(p);
% q = 1/n_disc;
% c = max(p)/q;
% samples = zeros(1,n);
% index = 1;
% while index <= 1
%     unif_rand = ceil(n_disc*rand);
%     frac = p(unif_rand)/(c*q);
%     if rand <= frac
%         samples(index) = unif_rand;
%         index = index + 1;
%     end
% end
% end

% n = 5;
% y = unidrnd(n, 500);
% u = rand(n,1);
% c = 0;
% p_vec = 0;
% q_vec = [0.15, 0.22, 0.33, 0.10, 0.20];
% for i=1:n
%     if (p_vec/q_vec) <= c
%         c = max(p_vec/q_vec);
%     end
% end
% for i=1:n
%     if u <= (p_vec/(c*q_vec))
%         x = y;
%     else
% 
% end

p_vec = [0.15, 0.22, 0.33, 0.10, 0.20];
q_vec = [0.2, 0.2, 0.2, 0.2, 0.2];
n = 1000;
index = 1;
x = zeros(1,1);
c = max((p_vec/q_vec));
Naccept = 0;
Nreject = 0;
while length(x) < n
    y(index) = unidrnd(5);
    u = rand;
    if u <= (p_vec(y(index))/(c*q_vec(y(index))))
        x(index) = y(index);
        index = index + 1;
        Naccept = Naccept + 1;
    else
        Nreject = Nreject + 1;
    end
end

Edges = [.5, 1.5, 2.5, 3.5, 4.5, 5.5]
h = histogram(x,5,'BinEdges', Edges, 'Normalization', 'pdf')
h.FaceColor = 'w';
phat = h.Values
accept_rate = Naccept / (Naccept + Nreject)
