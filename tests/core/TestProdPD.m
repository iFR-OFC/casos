% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef (TestTags="PD") TestProdPD < TestPolynomialOperations
% Test matrix product on constant polynomials.

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
        test_case.loadTestData("prod");

        test_case.fatalAssertLength(test_case.par,size(test_case.references.matrix.dim,2));
        test_case.fatalAssertLength(test_case.dim,length(test_case.references.matrix.all));
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["vector" "column"])
    function test_prod_column(test_case, dim)
        % Test product of column vectors.
        value = test_case.values.vector{1,dim};
        
        reference = test_case.references.vector.column{dim};

        test_case.evaluate_prod(value,reference);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["vector" "row"])
    function test_prod_row(test_case, dim)
        % Test product of row vectors.
        value = test_case.values.vector{2,dim}';
        
        reference = test_case.references.vector.row{dim};

        test_case.evaluate_prod(value,reference);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="matrix")
    function test_prod_matrix_dim(test_case, dim, par)
        % Test product of matrix along dimension.
        value = test_case.values.matrix{par,dim};
        
        reference = test_case.references.matrix.dim{dim,par};

        test_case.evaluate_prod(value,reference,par);
    end

    function test_prod_matrix_all(test_case, dim)
        % Test product of all elements in matrix.
        value = test_case.values.matrix{3,dim};

        reference = test_case.references.matrix.all{dim};

        test_case.evaluate_prod(value,reference,'all');
    end
end

methods
    function evaluate_prod(test_case, value, reference, varargin)
        % Evaluate product of matrix.
        actual = prod(value,varargin{:});

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12);
    end
end

end
