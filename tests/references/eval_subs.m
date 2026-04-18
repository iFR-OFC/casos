function res = eval_subs(mode,arg,ivar,new)
% Evaluate substitution operation.

vars = arg.varname;

switch (mode)
    case "single"
        % substitute single variable
        if ivar > length(vars)
            % variable not in polynomial
            var = {'y'};
        else
            var = vars(ivar);
        end

        res = subs(arg,var,new);

    case "multiple"
        % substitute multiple variables
        if ivar <= length(vars)
            % replace variable
            vars(ivar) = {'y'};
        end

        res = subs(arg,vars,new);
end

end
