% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Jan Olucak <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef (TestTags="PD") TestUnaryPD < TestPolynomialOperations
% Test unary operations on constant polynomials.

properties (SetAccess=protected)
    values       % test polynomials
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
    function test_unary_scalar(test_case, op, arg)
        % Test unary operation on scalars.
        value = test_case.values.scalar{1,arg};

        reference = test_case.references.scalar.(op){arg};

        test_case.evaluate_unary(op,value,reference);
    end

    function test_power_scalar(test_case, arg, pow)
        % Test power operation on scalars (single exponent).
        value = test_case.values.scalar{1,arg};

        reference = test_case.references.scalar.power{arg,pow+1};

        test_case.evaluate_unary(@(p) power(p,pow),value,reference);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="matrix")
    function test_unary_matrix(test_case, op, dim)
        % Test unary operation on matrices.
        value = test_case.values.matrix{1,dim};

        reference = test_case.references.matrix.(op){dim};

        test_case.evaluate_unary(op,value,reference);
    end

    function test_power_matrix(test_case, dim, pow)
        % Test power operation on matrices (single exponent).
        value = test_case.values.matrix{1,dim};
        
        reference = test_case.references.matrix.power{dim,pow+1};

        test_case.evaluate_unary(@(p) power(p,pow),value,reference);
    end
end
   
methods
    function evaluate_unary(test_case, op, value, reference)
        % Evaluate unary operation.
        actual = feval(op,value);

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12);
    end
end

end
