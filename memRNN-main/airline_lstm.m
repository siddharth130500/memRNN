clc;
%% data
initialize;
load('airline.mat');
num_passengers = cell2mat( internationalairlinepassengers2(:, 2) );

s = scaler( [0 1] );
disp('here');
num_passengers = s.scale(num_passengers);

n_window = 1;
data = [];
for i = 1: n_window
    data = [data; num_passengers(i:end-n_window -1 + i)'];
end
    
% data = num_passengers(1:end-1)';
ys = num_passengers(n_window + 1:end)';

num_training = floor( size(data, 2) *2 /3);

xs_training = data(:, 1: num_training);
ys_training = ys(:, 1: num_training);

xs_testing = data; %( :, num_training + 1: size(data, 2) );
ys_testing = ys; %( :, num_training + 1: size(data, 2) );

%
xs_training = permute(xs_training, [1 3 2]);
ys_training = permute(ys_training, [1 3 2]);
xs_testing = permute(xs_testing, [1 3 2]);
ys_testing = permute(ys_testing, [1 3 2]);



%% Network training with framework
filename='g_total.mat';
File = matfile(filename, 'Writable', true);
SE = rand(40, 64,2) ;
File.g = SE;

base = multi_array(sim_array1({'random' [40 64] 100e-6 300e-6},100e-6, 300e-6));

m = model( xbar( base ) );

m.add( LSTM(15, 'input_dim', 1, 'bias_config', [0.2 1]) );
m.add( dense(1, 'activation', 'sigmoid', 'bias_config', [0.2 1]), 'net_corner', [1 61]);

m.compile(mean_square_loss('calc_mode', 'sum'),...
    SGD('lr', 0.01, 'momentum', 0.9) );

m.v.DRAW_PLOT = 1;
m.v.DEBUG = 0;

% for i = 1:1000
m.fit( xs_training, ys_training, 'batch_size', 1, 'epochs', 200);
y_predit = m.predict(xs_testing, 'batch_size', 1);


%% loss vs epochs
figure(2);
clf;
plot(s.recover(reshape(y_predit, 1, []) ) );
hold on;
plot(s.recover(reshape(ys_testing, 1, [])), '--');

ylabel('Number of passengers');

xticks(1:12:144);
xtickyears = cellfun(@(x) char(x), internationalairlinepassengers2(1:12:144, 1) ,'UniformOutput',false);
xtickyears = cellfun(@(x) x(3:4), xtickyears ,'UniformOutput',false);

xticklabels(xtickyears );
grid on;
pause(3)

%% conductance
num_epoch = 1;
num_cond = num_epoch*2 + 4;
hold off;
load('g_total.mat');
A = g*10^6;
Q = size(A,3);
W = A(:,:,1);
h = pcolor(W);
drawnow();
pause(0.3);
for K = 1 : Q
    W = A(:,:,K);
    set(h, 'CData', W, 'EdgeColor', 'none');
    caxis([75, 350]);
    colorbar;
    drawnow();
    %pause(0.01);
end

