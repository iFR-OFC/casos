% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Jan Olucak <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef TestMtimes < TestPolynomialOperations
% Test matrix multiplication operations.

properties (TestParameter)
    test_values  % test polynmials
    references   % reference solutions

    pow = {0 1 2 3};
    dim1 = {1 2 3 4 5 6};
    dim2 = {1 2 3 4 5 6};
    arg1         % index argument 1
    arg2         % index argument 2
end

methods (TestParameterDefinition, Static)
    function [test_values,references,arg1,arg2] = initializeTestData()
        % Initialize test data for matrix multiplication operations.
        [test_values,references] = TestMtimes.loadTestData("mtimes");

        arg1 = num2cell(1:size(test_values{:}.scalar,2));
        arg2 = num2cell(1:size(test_values{:}.scalar,2));
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="scalar")
    function test_mtimes(test_case, test_values, references, arg1, arg2)
        % Test matrix multiplication.
        actual = mtimes(test_values.scalar{1,arg1},test_values.scalar{2,arg2});
        reference = references.scalar.mtimes{arg1,arg2};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15)
    end

    function test_kron(test_case, test_values, references, arg1, arg2)
        % Test Kronecker product.
        actual = kron(test_values.scalar{1,arg1},test_values.scalar{2,arg2});
        reference = references.scalar.kron{arg1,arg2};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15)
    end

    function test_mldivide(test_case, test_values, references, arg1, arg2)
        % Test left-side matrix division.
        val1 = test_values.scalar{1,arg1};
        vars = val1.indeterminates;
        test_value_deg0 = subs(val1,vars,ones(length(vars),1));
        actual = mldivide(test_value_deg0,test_values.scalar{2,arg2});
        reference = references.scalar.mldivide{arg1,arg2};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15)
    end

    function test_mrdivide(test_case, test_values, references, arg1, arg2)
        % Test right-side matrix division.
        val2 = test_values.scalar{2,arg2};
        vars = val2.indeterminates;
        test_value_deg0 = subs(val2,vars,ones(length(vars),1));
        actual = mrdivide(test_values.scalar{1,arg1},test_value_deg0);
        reference = references.scalar.mrdivide{arg1,arg2};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15)
    end

    function test_mpower(test_case, test_values, references, pow, arg1)
        % Test matrix power operation (scalar exponent).
        actual = mpower(test_values.scalar{1,arg1},pow);
        reference = references.scalar.mpower{arg1,pow+1};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12)
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["vector" "inner"])
    function test_mtimes_inner(test_case, test_values, references, dim1, dim2)
        % Test matrix multiplication on row-by-column vectors.
        val1 = test_values.vector{1,dim1}';
        val2 = test_values.vector{2,dim2};

        if (size(val1,2) ~= size(val2,1))
            % inner dimension mismatch
            diagtext = sprintf('Inner dimension mismatch expected: %d vs. %d.',size(val1,2),size(val2,1));
            test_case.verifyError(@() mtimes(val1,val2),?MException,diagtext);
            return
        end

        % else
        actual = mtimes(val1,val2);
        reference = references.inner.mtimes{dim1,dim2};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end

    function test_kron_inner(test_case, test_values, references, dim1, dim2)
        % Test Kronecker product on row-by-column vectors.
        val1 = test_values.vector{1,dim1}';
        val2 = test_values.vector{2,dim2};

        actual = kron(val1,val2);
        reference = references.inner.kron{dim1,dim2};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["vector" "outer"])
    function test_mtimes_outer(test_case, test_values, references, dim1, dim2)
        % Test matrix multiplication on column-by-row vectors.
        val1 = test_values.vector{1,dim1};
        val2 = test_values.vector{2,dim2}';

        actual = mtimes(val1,val2);
        reference = references.outer.mtimes{dim1,dim2};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end

    function test_kron_outer(test_case, test_values, references, dim1, dim2)
        % Test Kronecker product on column-by-row vectors.
        val1 = test_values.vector{1,dim1};
        val2 = test_values.vector{2,dim2}';

        actual = kron(val1,val2);
        reference = references.outer.kron{dim1,dim2};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="matrix")
    function test_mtimes_matrix(test_case, test_values, references, dim1, dim2)
        % Test matrix multiplication on matrices.
        val1 = test_values.matrix{1,dim1};
        val2 = test_values.matrix{3,dim2};

        if (size(val1,2) ~= size(val2,1))
            % inner dimension mismatch
            diagtext = sprintf('Inner dimension mismatch expected: %d vs. %d.',size(val1,2),size(val2,1));
            test_case.verifyError(@() mtimes(val1,val2),?MException,diagtext);
            return
        end

        % else
        actual = mtimes(val1,val2);
        reference = references.matrix.mtimes{dim1,dim2};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end

    function test_kron_matrix(test_case, test_values, references, dim1, dim2)
        % Test Kronecker product on matrices.
        val1 = test_values.matrix{1,dim1};
        val2 = test_values.matrix{3,dim2};

        actual = kron(val1,val2);
        reference = references.matrix.kron{dim1,dim2};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end
end

end
