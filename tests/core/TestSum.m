% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef TestSum < TestPolynomialOperations
% Test matrix sum.

properties (SetAccess=protected)
    values       % test polynomials
    references   % reference solutions
end

properties (TestParameter)
    par = {1 2};
    dim = num2cell(1:6);
end

methods (TestClassSetup)
    function initializeTestData(test_case)
        % Initialize test data for unary operations.
        test_case.loadTestData("sum");

        test_case.fatalAssertLength(test_case.par,size(test_case.references.matrix.dim,2));
        test_case.fatalAssertLength(test_case.dim,length(test_case.references.matrix.all));
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["vector" "column"])
    function test_sum_column(test_case, dim)
        % Test sum of column vectors.
        actual = sum(test_case.values.vector{1,dim});
        reference = test_case.references.vector.column{dim};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["vector" "row"])
    function test_sum_row(test_case, dim)
        % Test sum of row vectors.
        actual = sum(test_case.values.vector{2,dim}'); %#ok<UDIM>
        reference = test_case.references.vector.row{dim};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="matrix")
    function test_sum_matrix_dim(test_case, dim, par)
        % Test sum of matrix along dimension.
        actual = sum(test_case.values.matrix{par,dim},par);
        reference = test_case.references.matrix.dim{dim,par};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end

    function test_sum_matrix_all(test_case, dim)
        % Test sum of all elements in matrix.
        actual = sum(test_case.values.matrix{3,dim},'all');
        reference = test_case.references.matrix.all{dim};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end
end

end
