classdef (Abstract) AbstractProblem < handle
    properties (SetAccess = protected)
        % Core symbolic objects
        x       % primal decision variables
        f       % objective
        g       % constraints
        p       % parameters

        % Dimensions and count
        n_x     % number of decision variables
        n_g     % number of constraints
        n_p     % number of parameters

        % Derivative operators (gradients and jacobians)
        Df      % jacobian of cost function
        Dg      % jacobian of constraints

        % Evaluation objects (casos.function handles)
        ffun
        gfun
        Dffun
        Dgfun
    end

    methods (Access = public)
        function obj = AbstractProblem(nlsos)
            arguments
                nlsos struct = struct()
            end

            % problem size
            if isfield(nlsos,'x')
                obj.n_x = length(nlsos.x);
            else
                obj.n_x = 0;
            end
            
            if isfield(nlsos,'g')
                obj.n_g = length(nlsos.g);
            else
                obj.n_g = 0;
            end

            % Valid decision variable
            % TODO
            if isfield(nlsos,'x')
                obj.x = casos.PS(nlsos.x);
            end

            % valid constraints
            % TODO
            if isfield(nlsos,'g')
                obj.g = casos.PS(nlsos.g);
            else
                obj.g = casos.PS(0);
            end

            % valid cost function
            % TODO
            if isfield(nlsos,'f')
                obj.f = casos.PS(nlsos.f);
            else
                obj.f = casos.PS(0);
            end

            if isfield(nlsos,'p')
                obj.p = casos.PS(nlsos.p);
            else
                obj.p = casos.PS(0);
            end
        end
        
        %% Getters (returns symbolic values)
        % function Df = get_Df(obj)
        %     if isempty(obj.Df)
        %         obj.Df = jacobian(obj.f, obj.x);
        %     end
        %     Df = obj.Df;
        % end
        % 
        % function Dg = get_Dg(obj)
        %     % get gradient of g as operator
        %     if isempty(obj.Dg)
        %         obj.Dg = jacobian(obj.g, obj.x);
        %     end
        %     Dg = obj.Dg;
        % end

        function n = numel_x(obj)
            n = obj.n_x;
        end

        function m = numel_g(obj)
            m = obj.n_g;
        end

        %% Evaluators (input x, p -> f, g, ...)
        function val = eval_f(obj, x, p)
            % Question: move to constructor?
            if isempty(obj.ffun)
                obj.ffun = casos.Function('ffun', ...
                    {sparsity(obj.x), sparsity(obj.p)}, ...
                    {obj.f}, {'x', 'p'}, {'f_val'});
            end
            % Return evaluated value for f
            val = full(obj.ffun(x, p));
        end

        % function val = eval_Df(obj, x, p)
        %     if isempty(obj.Dffun)
        %         obj.Dffun = casos.Function('Dffun', ...
        %             {sparsity(obj.x), sparsity(obj.p)}, ...
        %             {obj.get_Df}, {'x', 'p'}, {'Df_val'});
        %     end
        %     val = obj.Dffun(x, p);
        % end
        % 
        % function val = eval_Dg(obj, x, p)
        %     if isempty(obj.Dgfun)
        %         obj.Dgfun = casos.Function('Dgfun', ...
        %             {sparsity(obj.x), sparsity(obj.p)}, ...
        %             {obj.get_Dg}, {'x', 'p'}, {'Dg_val'});
        %     end
        %     val = obj.Dgfun(x, p);
        % end
    end
end