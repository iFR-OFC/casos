% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Jan Olucak <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef TestPoly2Basis < TestPolynomialOperations
% Test poly2basis operation.

properties (TestParameter)
    test_values  % test polynmials
    references   % reference solutions

    dim1 = {1 2 3 4 5 6};
    dim2 = {1 2 3 4 5 6};
    arg1         % index argument 1
    arg2         % index argument 2
end

methods (TestParameterDefinition, Static)
    function [test_values,references,arg1,arg2] = initializeTestData()
        % Initialize test data for poly2basis operation.
        [test_values,references] = TestPoly2Basis.loadTestData("poly2basis");

        arg1 = num2cell(1:size(test_values{:}.scalar,2));
        arg2 = num2cell(1:size(test_values{:}.scalar,2));
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="scalar")
    function test_poly2basis(test_case, test_values, references, arg1, arg2)
        % Test poly2basis operation.
        value = test_values.scalar{1,arg1};
        basis = sparsity(test_values.scalar{2,arg2});

        actual = poly2basis(value,basis);
        reference = references.scalar.poly2basis{arg1,arg2};

        % perform assertion
        test_case.verifyClass(actual,?casadi.DM);
        test_case.verifyEqual(full(actual),reference,"RelTol",1e-15);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["vector" "column"])
    function test_poly2basis_column(test_case, test_values, references, dim1, dim2)
        % Test poly2basis operation on column vectors.
        value = test_values.vector{1,dim1};
        basis = sparsity(test_values.vector{2,dim2});
        
        if ~isequal(size(value),size(basis))
            % size mismatch
            diagtext = sprintf('Dimension mismatch expected: %s vs. %s.',mat2str(size(val1)),mat2str(size(val2)));
            test_case.verifyError(@() poly2basis(value,basis),?MException,diagtext);
            return
        end

        % else
        actual = poly2basis(value,basis);
        reference = references.column.poly2basis{dim1,dim2};

        % perform assertion
        test_case.verifyClass(actual,?casadi.DM);
        test_case.verifyEqual(full(actual),reference,"RelTol",1e-15);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["vector" "row"])
    function test_poly2basis_row(test_case, test_values, references, dim1, dim2)
        % Test poly2basis operation on row vectors.
        value = test_values.vector{1,dim1}';
        basis = sparsity(test_values.vector{2,dim2}');
        
        if ~isequal(size(value),size(basis))
            % size mismatch
            diagtext = sprintf('Dimension mismatch expected: %s vs. %s.',mat2str(size(val1)),mat2str(size(val2)));
            test_case.verifyError(@() poly2basis(value,basis),?MException,diagtext);
            return
        end

        % else
        actual = poly2basis(value,basis);
        reference = references.row.poly2basis{dim1,dim2};

        % perform assertion
        test_case.verifyClass(actual,?casadi.DM);
        test_case.verifyEqual(full(actual),reference,"RelTol",1e-15);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="matrix")
    function test_poly2basis_matrix(test_case, test_values, references, dim1, dim2)
        % Test poly2basis operation on matrices.
        value = test_values.matrix{1,dim1};
        basis = sparsity(test_values.matrix{2,dim2});
        
        if ~isequal(size(value),size(basis))
            % size mismatch
            diagtext = sprintf('Dimension mismatch expected: %s vs. %s.',mat2str(size(val1)),mat2str(size(val2)));
            test_case.verifyError(@() poly2basis(value,basis),?MException,diagtext);
            return
        end

        % else
        actual = poly2basis(value,basis);
        reference = references.matrix.poly2basis{dim1,dim2};

        % perform assertion
        test_case.verifyClass(actual,?casadi.DM);
        test_case.verifyEqual(full(actual),reference,"RelTol",1e-15);
    end
end

end
