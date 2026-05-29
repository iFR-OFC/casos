% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef TestTranspose < TestPolynomialOperations
% Test transpose.

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
        actual = transpose(test_case.values.vector{1,dim});
        reference = test_case.references.column{dim};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["vector" "row"])
    function test_transpose_row(test_case, dim)
        % Test transpose on row vectors.
        actual = transpose(test_case.values.vector{2,dim}');
        reference = test_case.references.row{dim};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="matrix")
    function test_transpose_matrix(test_case, dim)
        % Test transpose on matrix values.
        actual = transpose(test_case.values.matrix{3,dim});
        reference = test_case.references.matrix{dim};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end
end

end
