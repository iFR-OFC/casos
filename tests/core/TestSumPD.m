% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef (TestTags="PD") TestSumPD < TestPolynomialOperations
% Test matrix sum on constant polynomials.

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
        value = test_case.values.vector{1,dim};
        
        reference = test_case.references.vector.column{dim};

        test_case.evaluate_sum(value,reference);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["vector" "row"])
    function test_sum_row(test_case, dim)
        % Test sum of row vectors.
        value = test_case.values.vector{2,dim}';

        reference = test_case.references.vector.row{dim};

        test_case.evaluate_sum(value,reference);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="matrix")
    function test_sum_matrix_dim(test_case, dim, par)
        % Test sum of matrix along dimension.
        value = test_case.values.matrix{par,dim};
        
        reference = test_case.references.matrix.dim{dim,par};

        test_case.evaluate_sum(value,reference,par);
    end

    function test_sum_matrix_all(test_case, dim)
        % Test sum of all elements in matrix.
        value = test_case.values.matrix{3,dim};
        
        reference = test_case.references.matrix.all{dim};

        test_case.evaluate_sum(value,reference,'all');
    end
end

methods
    function evaluate_sum(test_case, value, reference, varargin)
        % Evaluate sum of matrix.
        actual = sum(value,varargin{:});

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end
end

end
