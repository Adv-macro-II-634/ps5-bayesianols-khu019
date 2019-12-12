clear;
clc;
% part (a)
raw =readtable('card.csv');
card = table2array(raw);
wage = card(:,26);
log_wage = log(wage);
edu = card(:,4);
exp = card(:,32);
smsa = card(:,23);
race = card(:,22); % 1 means black
region = card(:,24); % 1 means south
x = [ones(length(edu),1) edu exp smsa race region];
y = log_wage;
[b,bint,r,rint,stats] = regress(y,x,0.1);
% std of error
std_err = sqrt(stats(4));
% std of Beta
err = log_wage-x*b;
var_beta = err'*err/((length(edu)-6))*(x'*x);
std_b0 = sqrt(var_beta(1,1));
% use internal [.035 .085] so std = (0.085-0.035?/3.92=.0128
std_b1 = .0128*2;
std_b2 = sqrt(var_beta(3,3));
std_b3 = sqrt(var_beta(4,4));
std_b4 = sqrt(var_beta(5,5));
std_b5 = sqrt(var_beta(6,6));
std_all =[std_b0 std_b1 std_b2 std_b3 std_b4 std_b5 std_err];


%%%%%
dataset = [edu exp smsa race region];

% now initialize starting point
para_init = [5,.04,.1,-.1,-.1,.1,.5]
test = [];
para_dist = [];
%%%
for i = 1 : length(log_wage)
% likelihood of L(para_init)
lh_old=lh(log_wage(i),dataset(i,:),para_init);

% set V_n, V_n is 1 by 7 vector.
v_n_std = .1*[std_all(1),20*std_all(2),std_all(3),std_all(4),...
    std_all(5),std_all(6),std_all(7)];
% need to deal with std

v_n0 = randn(1,1)*v_n_std(1);
v_n1 = randn(1,1)*v_n_std(2);
v_n2 = randn(1,1)*v_n_std(3);
v_n3 = randn(1,1)*v_n_std(4);
v_n4 = randn(1,1)*v_n_std(5);
v_n5 = randn(1,1)*v_n_std(6);
v_ne = randn(1,1)*v_n_std(7);
v_n = [v_n0 v_n1 v_n2 v_n3 v_n4 v_n5 v_ne];
% propose one new para
para_new = para_init + v_n
% likelihood of new para
lh_new=lh(y(i),dataset(i,:),para_new);
ratio = lh_new/lh_old;

if ratio>.2
    para_init = para_new;
end
para_dist = [para_dist;para_init];
test = [test ratio];

end

acc_num = sum(test>.2)

% results:
figure(1)
histfit(para_dist(:,1),50)
title('distn of beta0')
figure(2)
histfit(para_dist(:,2),50)
title('distn of beta1')
figure(3)
histfit(para_dist(:,3),50)
title('distn of beta2')
figure(4)
histfit(para_dist(:,4),50)
title('distn of beta3')
figure(5)
histfit(para_dist(:,5),50)
title('distn of beta4')
figure(6)
histfit(para_dist(:,6),50)
title('distn of beta5')
figure(7)
histfit(para_dist(:,7),50)
title('distn of var err')


