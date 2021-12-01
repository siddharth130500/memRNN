clc;
load('g_total.mat');
E = zeros(size(g));
V_set = 0.8; % Fixed SET voltage
V_reset = 0.8; % Fixed RESET voltage
tp = 100*10^-3;
E_epoch = zeros([200,1]); x=zeros([200,1]);
g = g(:,:,3:end);
for k = 2:size(g,3)
    E(:,:,k) = (V_set^2*(g(:,:,k) > g(:,:,k-1))+V_reset^2*(g(:,:,k) < g(:,:,k-1))).*(g(:,:,k-1))*tp;
    E1 = E(:,:,k);
    E_epoch(k) = sum(E1,'all') + E_epoch(k-1);
    x(k)= floor((k-3)/2) + 1;
end

total_E = sum(E, 'all');

plot(x,E_epoch);