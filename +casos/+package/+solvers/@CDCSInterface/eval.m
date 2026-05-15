% SPDX-FileCopyrightText: 2023 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Renato Loureiro <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function argout = eval(obj,argin)
% Call CDCS interface.

% pre-process bounds
lba = sparse(argin{4});
uba = sparse(argin{5});
cba = sparse(argin{6});
lbx = sparse(argin{7});
ubx = sparse(argin{8});
cbx = sparse(argin{9});

% dimensions of original problem
nl = length(lbx);
nc = length(cbx);
ml = length(lba);
mc = length(cba);

% detect infinite lower variable bounds
If = find(isinf(lbx));
% prepare for infinite lower variable bounds
argin{7}(If) = 0;

% evaluate problem structure
prob = call(obj.fhan,argin);

% to double
A = sparse(prob{1});
b = sparse(prob{2});
c = sparse(prob{3});
% cone
K = obj.cone;

% options to CDCS
opts = obj.opts.cdcs;
% disable output by default
if ~isfield(opts,'verbose'), opts.verbose = 0; end

% reorder decision variables
idx = [If' setdiff(1:length(c),If)];

% remove trivial constraints
I = false(size(b));
J = false(size(c));

% detect equality constraints
Ila = find(lba == uba);
% remove lower bound constraints
I(Ila) = true;
% remove slack variables (sua,sla)
J(nl+[Ila; ml+Ila]) = true;

% detect constant variables
Ilx = find(lbx == ubx);
% remove slack variable sux
% (this leaves zl(i) = 0)
J(nl+2*ml+Ilx) = true;

% detect infinite bounds
Iba = find(isinf([uba;lba]));
Ibx = find(isinf(ubx));
% remove infinite bound constraints
I(Iba) = true;
I(2*ml+mc+Ibx) = true;
% remove slack variables (sua,sla,sux)
J(nl+[Iba; 2*ml+Ibx]) = true;

% purge constraints
A(I,:) = [];
b(I)   = [];

% purge variables
idx(J) = [];

A = A(:,idx);
c = c(idx);

% modify cone
K.f = length(If);
K.l = K.l - nnz(J) - length(If);

% remove empty fields
emptyFields = structfun(@isempty, K);
fieldsToRemove = fieldnames(K);
fieldsToRemove = fieldsToRemove(emptyFields);
K = rmfield(K, fieldsToRemove);

% call CDCS
[x_,y_,~,obj.solver_stats] = cdcs(A',b,full(c),K,opts);

% assign full solution
x = sparse(idx,1,x_,length(J),1);
y = sparse(find(~I),1,y_,length(I),1);

switch obj.solver_stats.problem
    % success
    case 0       
        obj.status = casos.package.UnifiedReturnStatus.SOLVER_RET_SUCCESS;  
    % primal or dual infeasible
    case {1, 2}  
        obj.status = casos.package.UnifiedReturnStatus.SOLVER_RET_INFEASIBLE;
        if obj.opts.error_on_fail
            if obj.solver_stats.problem == 1
                error('Conic problem is primal infeasible.');
            else
                error('Conic problem is dual infeasible.');
            end
        end
    % iteration limit reached    
    case 3       
        obj.status = casos.package.UnifiedReturnStatus.SOLVER_RET_NAN;
        if obj.opts.error_on_fail
            warning('Maximum iterations reached.');
        end
    % numerical errors    
    case 4  
        obj.status = casos.package.UnifiedReturnStatus.SOLVER_RET_NAN;
        if obj.opts.error_on_fail
            error('Numerical error (pres=%d, dres=%g)', ...
                obj.solver_stats.pres, obj.solver_stats.dres);
        end
    % unknown status    
    otherwise  
        obj.status = casos.package.UnifiedReturnStatus.SOLVER_RET_NAN;
        error('Unrecognized solver problem code.');  
end

% parse solution
argout = call(obj.ghan,[argin {x y}]);

end