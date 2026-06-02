classdef NonconvexProblem < casos.package.problem.AbstractProblem
    properties (SetAccess = protected) % TODO change to Access later
        % Core symbolic objects (in addition to AbstractProblem properties)
        lambda_g    % multipliers for g

        % Lagrangian
        L           % symbolic Lagrangian (SX)

        % Derivatives
        DL          % symbolic Lagrangian gradient wrt x (SX)
        DDL         % symbolic Lagrangian hessian wrt x (SX)
        
        % Evaluation objects (casos.function handles)
        Lfun
        DLfun
        DDLfun

        % solvers
        g_violation_solver
    end

    methods
        function obj = NonconvexProblem(nlsos, opts)
            arguments
                nlsos struct = struct()
                opts struct = struct()
            end

            % Call constructor of AbstractProblem
            obj = obj@casos.package.problem.AbstractProblem(nlsos, opts);

            % Check if problem is defined with correct dimensions etc. 
            %TODO

            % Define lagrangian multipliers
            obj.lambda_g = casos.PS.sym('lam_g', sparsity(obj.g));
        end

        function [theta] = get_constr_violation(obj, x, p)
            % returns constraint violation value for a provided polynomial
            % p
            
            % lazy initialization of violation solver
            if isempty(obj.g_violation_solver)
                % For now: only signed distance
                % build unit polynomials
                [~,~,z] = grambasis(obj.g); % gram half basis
                s0 = casos.PD(gramunit(z)); % unit SOS polynomial
    
                % signed distance vector
                r = casos.PS.sym('r', obj.numel_g);
                        
                % Define sos problem
                sos_g_vio = struct( ...
                    'x', r, ...
                    'f', sum(r), ...
                    'g', obj.g+r.*s0, ...
                    'p', [obj.p; obj.x]);
    
                % options struct
                opts_g_vio = struct();
                opts_g_vio.Kx = struct('lin',length(r));
                opts_g_vio.Kc = obj.Kc;
                % obj.g_violation_solver = casos.package.solvers.sossolInternal( ...
                %     'g_vio_signed', 'mosek', sos_g_vio, opts_g_vio);
                obj.g_violation_solver = casos.sossol('sdsol', 'mosek', ... 
                    sos_g_vio, opts_g_vio)
            end

            % Evaluate constraint violation
            % ...
        end
    end

    methods (Access=protected)
        %% Getters for lazy caching
        function L = get_L(obj)
            if isempty(obj.L)
                obj.L = obj.f + dot(obj.lambda_g, obj.g);
            end
            L = obj.L;
        end

        function DL = get_DL(obj)
            % returns symbolic gradient of Lagrangian w.r.t. x
            if isempty(obj.DL)
                obj.DL = op2basis(jacobian(obj.get_L, obj.x));
            end
            DL = obj.DL;
        end

        function DDL = get_DDL(obj)
            % returns symbolic hessian of Lagrangian w.r.t. x
            if isempty(obj.DDL)
                obj.DDL = op2basis(hessian(obj.get_L, obj.x));
            end
            DDL = obj.DDL;
        end
        
        %% Evaluation methods
        function val = eval_DL(obj, x, p, lam)
            if isempty(obj.DLfun)
                obj.DLfun = casos.Function('DLfun', ...
                    {poly2basis(obj.x), poly2basis(obj.p), poly2basis(obj.lambda_g)}, ...
                    {obj.get_DL}, {'x', 'p', 'lam'}, {'DL_val'});
            end
            val = obj.DLfun(x, p, lam);
        end
    end
end