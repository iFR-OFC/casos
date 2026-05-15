% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function res = eval_int(mode,arg,ivar)
% Evaluate int operation.

vars = arg.varname;

switch (mode)
    case "single"
        % integrate with respect to single variable
        if ivar > length(vars)
            % variable not in polynomial
            var = {'y'};
        else
            var = vars(ivar);
        end

        res = int(arg,var{:});

    case "multiple"
        % integrate with respect to multiple variables
        if ivar <= length(vars)
            % replace variable
            vars(ivar) = {'y'};
        end

        res = int2(arg,vars);
end

end

function p = int2(arg,vars)
% Integrate in multiple variables.

if isempty(vars)
    % nothing to do
    p = arg;
    return
end

% else
p = int2(int(arg,vars{1}),vars(2:end));

end
