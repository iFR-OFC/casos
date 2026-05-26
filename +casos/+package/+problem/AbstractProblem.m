classdef (Abstract) AbstractProblem < handle
    % Shared base container for SOS problem definitions.
    %
    % Keep this class minimal so it can serve both nonconvex and
    % quasiconvex subclasses.

    properties (SetAccess = protected)
        name % char/string
        n    % number of decision variables
        m    % number of constraints
        x % decision variables
        f % objective (defaults to 0)
        g % constraints (defaults to empty polynomial)
        p % optional parameters (defaults to empty polynomial)
        Df % jacobian of cost function
        Dg % jacobian of constraints
    end

    methods (Access = public)
        function obj = AbstractProblem(nlsos)
            arguments
                nlsos struct = struct()
            end

            % problem size
            if isfield(nlsos,'x')
                obj.n = length(nlsos.x);
            else
                obj.n = 0;
            end
            
            if isfield(nlsos,'g')
                obj.m = length(nlsos.g);
            else
                obj.m = 0;
            end

            % Valid decision variable
            % TODO
            if isfield(nlsos,'x')
                obj.x = nlsos.x;
            end

            % valid constraints
            % TODO
            if isfield(nlsos,'g')
                obj.g = nlsos.g;
            end

            % valid cost function
            % TODO
            if isfield(nlsos,'f')
                obj.f = nlsos.f;
            end

            if isfield(nlsos,'p')
                obj.p = nlsos.p;
            end

        end
        
        %% Getters
        function Df = jacobian_f(obj)
            if isempty(obj.Df)
                obj.Df = jacobian(obj.f, obj.x);
            end
            Df = obj.Df;
        end

        function Dg = jacobian_g(obj)
            if isempty(obj.Dg)
                obj.Dg = jacobian(obj.g, obj.x);
            end
            Dg = obj.Dg;
        end

        function n = numel_x(obj)
            n = obj.n;
        end

        function m = numel_g(obj)
            m = obj.m;
        end
    end
end