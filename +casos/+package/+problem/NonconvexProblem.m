classdef NonconvexProblem < casos.package.problem.AbstractProblem
    properties (SetAccess = immutable)
        % Core symbolic objects (in addition to AbstractProblem properties)
        lambda_g    % multipliers for g
    end
    properties (SetAccess = protected)
        % Lagrangian
        L           % symbolic Lagrangian (SX)
        
        % Derivatives
        DL          % symbolic Lagrangian gradient wrt x (SX)
        DDL         % symbolic Lagrangian hessian wrt x (SX)

        % Evaluation objects (casos.function handles)
        Lhan
        DLhan
    end

    methods
        function obj = NonconvexProblem(nlsos)
            arguments
                nlsos struct = struct()
            end

            % Call constructor of AbstractProblem
            obj = obj@casos.package.problem.AbstractProblem(nlsos);

            % Check if problem is defined with correct dimensions etc. 
            %TODO

            % Define lagrangian multipliers
            obj.lambda_g = casos.PS.sym('lam_g', sparsity(obj.g));
        end

        %% Getters
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
    end
end