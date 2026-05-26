classdef (Abstract) AbstractProblem
    % Shared base container for SOS problem definitions.
    %
    % Keep this class minimal so it can serve both nonconvex and
    % quasiconvex subclasses.

    properties
        name % char/string
        x % decision variables
        f % objective (defaults to 0)
        g % constraints (defaults to empty polynomial)
        p % optional parameters (defaults to empty polynomial)
        Kx % struct with cone dimensions for x
        Kc % struct with cone dimensions for g
    end

    methods
        function obj = AbstractProblem(name,x,opts)
            arguments
                name = ""
                x = casos.PS
                opts.f = casos.PS(0)
                opts.g = casos.PS
                opts.p = casos.PS
                opts.Kx struct = struct()
                opts.Kc struct = struct()
            end

            obj.name = name;
            obj.x = casos.PS(x);
            obj.f = casos.PS(opts.f);
            obj.g = casos.PS(opts.g);
            obj.p = casos.PS(opts.p);

            if isempty(fieldnames(opts.Kx))
                obj.Kx = struct('lin',length(obj.x));
            else
                obj.Kx = opts.Kx;
            end

            if isempty(fieldnames(opts.Kc))
                obj.Kc = struct('lin',length(obj.g));
            else
                obj.Kc = opts.Kc;
            end
        end
    end
end