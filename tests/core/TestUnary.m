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
    pow = {2 3 4};
    dim1 = {1 2 3 4 5};
    arg          % index argument
end

methods (TestParameterDefinition, Static)
    function [test_values,references,arg] = initializeTestData()
        % Initialize test data for unary operations.
        [test_values,references] = TestUnary.loadTestData("unary");

        arg = num2cell(1:size(test_values{:},2));
    end
end

methods (Test, ParameterCombination="pairwise")
    function test_unary(test_case, test_values, references, op, arg)
        % Test unary operation.
        actual = feval(op,test_values{arg});
        reference = references.(op){arg};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end

    function test_power(test_case, test_values, references, arg, pow)
        % Test power operation (single exponent).
        actual = power(test_values{arg},pow);
        reference = references.power{arg,pow-1};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12);
    end

    function test_unary_vector(test_case, test_values, references, op, dim1)
        % Test unary operation on vector.
        dim2 = 6-dim1;
        value = reshape([test_values{1:(dim1*dim2)}],dim1,dim2);
        actual = feval(op,value);
        reference = references.vector.(op){dim1};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end
end

end
