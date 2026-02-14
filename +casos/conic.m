function f = conic(varargin)
% Low-level interface for conic (SDP) solvers.

try
    sol = casos.package.solvers.create_conic(varargin{:});
    
    f = casos.Function.create(sol);

catch e
    throwAsCaller(e)
end

end
