% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef (TestTags="PS") TestTransposePS < TestSymbolicOperations
% Test transpose on symbolic polynomials.

properties (SetAccess=protected)
    values       % test polynomials
    references   % reference solutions
end

properties (TestParameter)
    dim = num2cell(1:6);
end

methods (TestClassSetup)
    function initializeTestData(test_case)
        % Initialize test data for unary operations.
        test_case.loadTestData("transpose");

        test_case.fatalAssertLength(test_case.dim,length(test_case.references.matrix));
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["vector" "column"])
    function test_transpose_column(test_case, dim)
        % Test transpose on column vectors.
        value = test_case.values.vector{1,dim};
        
        reference = test_case.references.column{dim};

        test_case.evaluate_transpose(value,reference);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["vector" "row"])
    function test_transpose_row(test_case, dim)
        % Test transpose on row vectors.
        value = test_case.values.vector{2,dim}';
        
        reference = test_case.references.row{dim};

        test_case.evaluate_transpose(value,reference);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="matrix")
    function test_transpose_matrix(test_case, dim)
        % Test transpose on matrix values.
        value = test_case.values.matrix{3,dim};

        reference = test_case.references.matrix{dim};

        test_case.evaluate_transpose(value,reference);
    end
end

methods
    function evaluate_transpose(test_case, value, reference)
        % Evaluate transpose.

        % symbolic polynomial
        [p,symbol,argument] = test_case.get_operand(true,value);

        % build symbolic function
        expression = transpose(p);
        f = casos.Function('f',symbol,{expression});

        actual = f(argument{:});

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end
end

end
