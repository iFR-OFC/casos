function node = create_sossol(name,solver,sos,varargin)
% Create sum-of-squares solver.

node = casos.package.solvers.SossdpRelaxation(name,solver,sos,varargin{:});

end
