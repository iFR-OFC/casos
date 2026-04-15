function res = eval_poly2basis(arg1,arg2)
% Evaluate poly2basis on first argument with basis of second argument.

assert(isequal(size(arg1),size(arg2)), 'Size mismatch.')

if isempty(arg1)
    % handle empty polynomial
    res = zeros(0,1);
    return
end

% else
N = prod(size(arg1)); %#ok<PSIZE>

% evaluate poly2basis element-wise
results = arrayfun(@(i) full(poly2basis(arg1(i),monomials(arg2(i)))), 1:N, "UniformOutput",false);

% concatenate results to column vector
res = vertcat(results{:});

end
