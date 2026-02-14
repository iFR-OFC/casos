function node = create_nlsossol(name,solver,varargin)
% Create noncovex sum-of-squares solver.

switch (solver)
    case 'sequential'
        node = casos.package.solvers.FilterLinesearch(name,varargin{:});
    otherwise
        error('No such nonlinear solver "%s".',solver)
end

end
