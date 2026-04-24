% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Jan Olucak <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef TestUnary < TestPolynomialOperations
% Test unary operations.

properties (TestParameter)
    test_values  % test polynmials
    references   % reference solutions

    op = {"uplus" "uminus"};
    pow = {0 1 2 3};
    dim = {1 2 3 4 5 6};
    arg          % index argument
end

methods (TestParameterDefinition, Static)
    function [test_values,references,arg] = initializeTestData()
        % Initialize test data for unary operations.
        [test_values,references] = TestUnary.loadTestData("unary");

        arg = num2cell(1:size(test_values{:}.scalar,2));
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="scalar")
    function test_unary(test_case, test_values, references, op, arg)
        % Test unary operation.
        actual = feval(op,test_values.scalar{1,arg});
        reference = references.scalar.(op){arg};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end

    function test_power(test_case, test_values, references, arg, pow)
        % Test power operation (single exponent).
        actual = power(test_values.scalar{1,arg},pow);
        reference = references.scalar.power{arg,pow+1};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="matrix")
    function test_unary_matrix(test_case, test_values, references, op, dim)
        % Test unary operation on matrix values.
        actual = feval(op,test_values.matrix{1,dim});
        reference = references.matrix.(op){dim};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end

    function test_power_matrix(test_case, test_values, references, dim, pow)
        % Test power operation on matrix values (single exponent).
        actual = power(test_values.matrix{1,dim},pow);
        reference = references.matrix.power{dim,pow+1};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12);
    end
end

end
