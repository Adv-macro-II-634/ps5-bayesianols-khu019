function lh = lh(y,ind_var,para)
%{
 this function only works for this problem set,
there are three inputs 
y is log_wage, which is one by one scalar
ind_var means x_level data, stands for edu, exp,smsa,race, region by order.
para means parameters needed to be estimated, total number is 7.
%}

assert(length(ind_var)==5,'second input must be 1 by 5 vector')

assert(length(para)==7,'third input must be 1 by 7 vector')

beta = para(1:6); % 6 beta totally

ols_x = [1 ind_var]; % add intercept 
   
lh = 1/(sqrt(2*pi*para(7)))*exp(-((y-beta*ols_x').^2/(2*para(7)^2)));


end