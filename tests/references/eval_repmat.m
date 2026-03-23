function res = eval_repmat(arg,m,n)
% Evaluate repmat operation.

if (m == 0 || n == 0)
    % return empty polynomial
    res = polynomial(zeros(size(arg).*[m n]));

else
    % invoke multipoly repmat
    res = repmat(arg,m,n);
end

end
