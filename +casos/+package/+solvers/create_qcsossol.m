function node = create_qcsossol(name,solver,varargin)
% Create quasiconvex sum-of-squares solver.

switch (solver)
    case 'bisection'
        node = casos.package.solvers.QuasiconvBisection(name,varargin{:});

    otherwise
        error('No such quasiconvex solver "%s".',solver)
end

end
