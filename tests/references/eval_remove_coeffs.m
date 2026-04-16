function res = eval_remove_coeffs(arg1,arg2,p)
% Evaluate remove_coeffs on first argument.
% Tolerance is based on percentile of coefficients of second argument.

tol = prctile([0; coordinates(arg2)],p);
    
res = cleanpoly(arg1, tol);

end
