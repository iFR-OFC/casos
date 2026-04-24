% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Jan Olucak <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef (Abstract) TestSymbolicOperations < matlab.unittest.TestCase
% Base class for tests of symbolic (polynomial) operations.

methods (Static)
    function [test_values] = loadTestData()
        % Load test data for symbolic operations.
        S = load("../references/reference_values.mat","test_values_struct");

        test_values_struct = S.test_values_struct;
        test_value = struct;
        
        for type = ["scalar" "vector" "matrix"]
            test_value.(type) = cell(size(test_values_struct.(type{:})));

            for k = 1:numel(test_values_struct.(type))
                arg = test_values_struct.(type){k};
    
                x = casos.Indeterminates(arg.indets{:});
                sp = casos.Sparsity.tuplet(arg.sz(1),arg.sz(2),arg.i,arg.j,x,arg.degrees);
    
                test_value.(type){k} = casos.PD(sp,arg.coeffs);
            end
        end

        test_values = {test_value};
    end
end

end
