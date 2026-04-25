% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Jan Olucak <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef TestUnary < TestPolynomialOperations
% Test unary operations.

properties (SetAccess=protected)
    values       % test polynmials
    references   % reference solutions
end

properties (TestParameter)
    op = {"uplus" "uminus"};
    pow = num2cell(0:3);
    dim = num2cell(1:6);
    arg = num2cell(1:10);
end

methods (TestClassSetup)
    function initializeTestData(test_case)
        % Initialize test data for unary operations.
        test_case.loadTestData("unary");

        test_case.fatalAssertLength(test_case.pow,size(test_case.references.scalar.power,2));
        test_case.fatalAssertLength(test_case.dim,length(test_case.references.matrix.uplus));
        test_case.fatalAssertLength(test_case.arg,length(test_case.references.scalar.uplus));
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="scalar")
    function test_unary(test_case, op, arg)
        % Test unary operation.
        actual = feval(op,test_case.values.scalar{1,arg});
        reference = test_case.references.scalar.(op){arg};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end

    function test_power(test_case, arg, pow)
        % Test power operation (single exponent).
        actual = power(test_case.values.scalar{1,arg},pow);
        reference = test_case.references.scalar.power{arg,pow+1};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="matrix")
    function test_unary_matrix(test_case, op, dim)
        % Test unary operation on matrix values.
        actual = feval(op,test_case.values.matrix{1,dim});
        reference = test_case.references.matrix.(op){dim};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end

    function test_power_matrix(test_case, dim, pow)
        % Test power operation on matrix values (single exponent).
        actual = power(test_case.values.matrix{1,dim},pow);
        reference = test_case.references.matrix.power{dim,pow+1};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12);
    end
end

end
