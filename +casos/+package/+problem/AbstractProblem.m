classdef (Abstract) AbstractProblem < handle
    properties (SetAccess = protected)
        % Core symbolic objects
        x       % primal decision variables
        f       % objective
        g       % constraints
        p       % parameters

        % Derivative operators (gradients and jacobians)
        Df      % jacobian of cost function
        Dg      % jacobian of constraints

        % Cones
        Kx      % decision variable cone
        Kc      % constraint cone

        % Evaluation objects (casos.function handles)
        ffun
        gfun
        Dffun
        Dgfun
    end

    methods (Access = public)
        function obj = AbstractProblem(nlsos, opts)
            arguments
                nlsos struct = struct()
                opts struct = struct()
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

            if isfield(opts, 'Kx')
                obj.Kx = opts.Kx;
            else
                obj.Kx = struct('lin', obj.numel_x);
            end

            if isfield(opts, 'Kc')
                obj.Kc = opts.Kc;
            else
                obj.Kc = struct('sos', obj.numel_g);
            end
        end
        
        %% Dependent properties
        function n = numel_x(obj)
            n = length(obj.x);
        end

        function m = numel_g(obj)
            m = length(obj.g);
        end

        %% Evaluators
        function val = eval_f(obj, x, p)
            if isempty(obj.ffun) % lazy caching
                obj.ffun = casos.Function('ffun', ...
                    {poly2basis(obj.x), poly2basis(obj.p)}, ...
                    {obj.f}, {'x', 'p'}, {'f_val'});
            end
            % Return evaluated value for f (numerical)
            val = full(obj.ffun(poly2basis(x), poly2basis(p)));
        end

        function val = eval_g(obj, x, p)
            if isempty(obj.gfun) % lazy caching
                obj.gfun = casos.Function('gfun', ...
                    {poly2basis(obj.x), poly2basis(obj.p)}, ...
                    {obj.g}, {'x', 'p'}, {'g_val'});
            end
            % Return casos.PD polynomial for g
            val = casos.PD(obj.gfun(poly2basis(x), poly2basis(p)));
        end

        
    end
    methods (Access=protected)
        %% Getters for lazy caching
        function Df = get_Df(obj)
            % get gradient of f as an operator
            if isempty(obj.Df)
                obj.Df = jacobian(obj.f, obj.x);
            end
            Df = obj.Df;
        end

        function Dg = get_Dg(obj)
            % get jacobian of g as operator
            if isempty(obj.Dg)
                obj.Dg = jacobian(obj.g, obj.x);
            end
            Dg = obj.Dg;
        end

        function val = eval_Df(obj, x, p)
            if isempty(obj.Dffun)
                obj.Dffun = casos.Function('Dffun', ...
                    {sparsity(obj.x), sparsity(obj.p)}, ...
                    {obj.get_Df}, {'x', 'p'}, {'Df_val'});
            end
            val = obj.Dffun(x, p);
        end

        function val = eval_Dg(obj, x, p)
            if isempty(obj.Dgfun)
                obj.Dgfun = casos.Function('Dgfun', ...
                    {sparsity(obj.x), sparsity(obj.p)}, ...
                    {obj.get_Dg}, {'x', 'p'}, {'Dg_val'});
            end
            val = obj.Dgfun(x, p);
        end
    end
end