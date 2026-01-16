% sos feasibility optimization.

% indeterminate variable
x = casos.Indeterminates('x',2);
% polynomial
p = x(1)^4 + 3*x(2)^4 - 2*x(1)^3*x(2) + 3*x(1)^2*x(2)^2;

% check if p is SOS
sos = struct('g',p);
% constraint is scalar SOS cone
opts = struct('Kc',struct('sos',1));
opts.newton_solver =[];
opts.error_on_fail = 0;
% solve by relaxation to SDP
S = casos.sossol('S','mosek',sos,opts);
% evaluate
sol = S();

if strcmp(S.stats.UNIFIED_RETURN_STATUS,'SOLVER_RET_SUCCESS')
     disp('Given polynomial is SOS!')
else
    disp('No decomposition found!')
end