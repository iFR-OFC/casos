classdef (Abstract) AbstractProblem
    % Shared base container for SOS problem definitions.
    %
    % Keep this class minimal so it can serve both nonconvex and
    % quasiconvex subclasses.

    properties
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

    methods
        function obj = AbstractProblem(nlsos)
            arguments
                nlsos struct = struct()
            end

            % problem size
            if isfield(sos,'x')
                obj.numel_x = length(sos.x);
            else
                obj.numel_x = 0;
            end
            
            if isfield(sos,'g')
                obj.numel_g = length(sos.g);
            else
                obj.numel_g = 0;
            end

            % Valid decision variable
            % TODO
            obj.x = nlsos.x;

            % valid constraints
            % TODO
            obj.g = nlsos.g;

            % valid cost function
            % TODO
            obj.f = nlsos.f;

        end
        
        %% Getters
        function Df = jacobian_f(obj)
            Df = jacobian(obj.f, obj.x)
        end

        function Dg = jacobian_g(obj)
            Dg = jacobian(obj.f, obj.x)
        end
    end
end