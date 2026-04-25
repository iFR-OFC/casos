% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Jan Olucak <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef (Abstract) TestSymbolicOperations < matlab.unittest.TestCase
% Base class for tests of symbolic (polynomial) operations.

properties (Abstract, SetAccess=protected)
    values;
end

methods (Access=protected)
    function loadTestData(test_case)
        % Load test data for symbolic operations.
        try
            S = load("../references/reference_values.mat","test_values_struct");

        catch e
            test_case.fatalAssertFail("Error loading reference values: " + e.message);
        end

        test_case.values = struct;

        for type = ["scalar" "vector" "matrix"]
            test_case.values.(type) = cell(size(S.test_values_struct.(type{:})));

            for k = 1:numel(S.test_values_struct.(type))
                arg = S.test_values_struct.(type){k};
    
                x = casos.Indeterminates(arg.indets{:});
                sp = casos.Sparsity.tuplet(arg.sz(1),arg.sz(2),arg.i,arg.j,x,arg.degrees);
    
                test_case.values.(type){k} = casos.PD(sp,arg.coeffs);
            end
        end
    end
end

end
