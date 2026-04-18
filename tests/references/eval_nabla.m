function res = eval_nabla(mode,arg,ivar)
% Evaluate Nabla operation.

vars = arg.varname;

switch (mode)
    case "single"
        % nabla with respect to single variable (derivative)
        if ivar > length(vars)
            % variable not in polynomial
            var = {'y'};
        else
            var = vars(ivar);
        end

        res = jacobian(arg,var);

    case "multiple"
        % nabla with respect to multiple variables (gradient / jacobian)
        if ivar <= length(vars)
            % replace variable
            vars(ivar) = {'y'};
        end

        res = jacobian(arg,vars);
end

end
