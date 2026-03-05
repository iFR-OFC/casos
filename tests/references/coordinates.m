function val = coordinates(p,varargin)
% Emulate behaviour of CaΣoS poly2basis method.

vals = arrayfun(@(i) poly2basis(p(i),varargin{:}), 1:prod(size(p)), "UniformOutput", false); %#ok<PSIZE> not implemented by multipoly

val = vertcat(vals{:});

end
