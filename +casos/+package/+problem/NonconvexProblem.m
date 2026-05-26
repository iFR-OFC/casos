classdef NonconvexProblem < casos.package.problem.AbstractProblem
    properties
        Df % Jacobian of objective wrt x
        Dg % Jacobian of constraints wrt x
        L % symbolic Lagrangian
        dLdx % symbolic Lagrangian gradient wrt x
    end

    methods
        function obj = NonconvexProblem(name,x,opts)
            arguments
                name = ""
                x = casos.PS
                opts.f = casos.PS(0)
                opts.g = casos.PS
                opts.p = casos.PS
                opts.Kx struct = struct()
                opts.Kc struct = struct()
                opts.Df = []
                opts.Dg = []
                opts.L = []
                opts.dLdx = []
            end

            obj@casos.package.problem.AbstractProblem(name,x, ...
                f=opts.f, ...
                g=opts.g, ...
                p=opts.p, ...
                Kx=opts.Kx, ...
                Kc=opts.Kc);

            obj.Df = opts.Df;
            obj.Dg = opts.Dg;
            obj.L = opts.L;
            obj.dLdx = opts.dLdx;
        end
    end
end