% sos feasibility optimization.

% indeterminate variable
x = casos.Indeterminates('x');
% some polynomial
p = x^2+x^4;

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

S.stats.UNIFIED_RETURN_STATUS
sol.g
