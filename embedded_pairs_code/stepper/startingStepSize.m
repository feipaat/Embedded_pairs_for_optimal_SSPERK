function [dt, nfcn] = startingStepSize(Q, k, maxvel, fluxFnc, relTol, absTol, rkOrder)
% function [dt, nfcn] = startingStepSize(Q, fluxFnc, relTol, absTol, rkOrder)
% File: startingStepSize.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: 
% Purpose: Return the optimal starting step-size for PDE
% Solving Ordinary Differential Equation I - nonstiff
% Hairer. pg. 169. Starting Step Size Algorithm


% Solving Ordinary Differential Equation I - nonstiff
% Hairer. pg. 169. Starting Step Size Algorithm

sysSize = size(Q,2);
u0 = Q(:);
n = length(u0);

err_fun = @(x, sc_i) sqrt(  sum(((x./sc_i).^2))/length(x)  );

% a.)
rhs = fluxFnc(Q, k, maxvel);
k1  = rhs(:);

sci = absTol + abs(u0)*relTol;
d0  = err_fun(u0, sci);
d1  = err_fun(k1, sci);

% b.) first guess for the step size
if (d0 < 1e-6 || d1 < 1e-6)
    h0 = 1e-6;
else
    h0 = 0.01*(d0/d1);
end

% c.)
rhs = fluxFnc(Q, k, maxvel);
rhs = rhs(:);
y1  = u0 + h0*rhs;
Q1  = reshape(y1,[],sysSize);

k1 = fluxFnc(Q, k, maxvel);
k2 = fluxFnc(Q1, k, maxvel);

% d.) an estimate of the second derivative
d2 = (k2(:) - k1(:));
d2 = err_fun(d2, sci)/h0;

% e. )
max_d1_d2 = max(d1, d2);
if max_d1_d2 <= 1e-5
    h1 = max(1e-6, 1e-3*h0);
else
    h1 = (0.01/max_d1_d2)^(1/(rkOrder+1));
end

dt = min(100*h0, h1);
nfcn = 2;
end
