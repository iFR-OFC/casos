% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Jan Olucak <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef (Abstract) TestSymbolicOperations < TestPolynomialOperations
% Base class for tests of symbolic (polynomial) operations.

methods (Static, Access=protected)
    function [p,symbol,argument] = get_operand(is_symbolic,value)
        % Return symbolic or numeric operand.
        if (is_symbolic)
            % symbolic operand
            p = casos.PS.sym('p',sparsity(value));

            % return symbol and argument
            symbol = {p};
            argument = {value};

        else
            % numeric operand
            p = value;

            % empty symbol and argument
            symbol = {};
            argument = {};
        end
    end
end

end
