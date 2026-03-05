classdef TestMtimes < TestPolynomialOperations
% Test matrix multiplication operations.

properties (TestParameter)
    test_values  % test polynmials
    references   % reference solutions

    pow = {2 3 4};
    arg1         % index argument 1
    arg2         % index argument 2
end

methods (TestParameterDefinition, Static)
    function [test_values,references,arg1,arg2] = initializeTestData()
        % Initialize test data for matrix multiplication operations.
        [test_values,references] = TestBinary.loadTestData("mtimes");

        arg1 = num2cell(1:size(test_values{:},2));
        arg2 = num2cell(1:size(test_values{:},2));
    end
end

methods (Test, ParameterCombination="pairwise")
    function test_mtimes(test_case, test_values, references, arg1, arg2)
        % Test matrix multiplication.
        actual = full(poly2basis(mtimes(test_values{1,arg1},test_values{2,arg2})));
        reference = references.mtimes{arg1,arg2};

        % perform assertion
        test_case.verifyEqual(actual,reference,"RelTol",1e-15)
    end

    function test_kron(test_case, test_values, references, arg1, arg2)
        % Test Kronecker product.
        actual = full(poly2basis(kron(test_values{1,arg1},test_values{2,arg2})));
        reference = references.kron{arg1,arg2};

        % perform assertion
        test_case.verifyEqual(actual,reference,"RelTol",1e-15)
    end

    function test_mldivide(test_case, test_values, references, arg1, arg2)
        % Test left-side matrix division.
        vars = test_values{1,arg1}.indeterminates;
        test_value_deg0 = subs(test_values{1,arg1},vars,ones(length(vars),1));
        actual = full(poly2basis(mldivide(test_value_deg0,test_values{2,arg2})));
        reference = references.mldivide{arg1,arg2};

        % perform assertion
        test_case.verifyEqual(actual,reference,"RelTol",1e-15)
    end

    function test_mrdivide(test_case, test_values, references, arg1, arg2)
        % Test right-side matrix division.
        vars = test_values{2,arg2}.indeterminates;
        test_value_deg0 = subs(test_values{2,arg2},vars,ones(length(vars),1));
        actual = full(poly2basis(mrdivide(test_values{1,arg1},test_value_deg0)));
        reference = references.mrdivide{arg1,arg2};

        % perform assertion
        test_case.verifyEqual(actual,reference,"RelTol",1e-15)
    end

    function test_mpower(test_case, test_values, references, pow, arg1)
        % Test matrix power operation (scalar exponent).
        actual = full(poly2basis(mpower(test_values{arg1},pow)));
        reference = references.mpower{arg1,pow-1};

        % perform assertion
        test_case.verifyEqual(actual,reference,"RelTol",1e-12)
    end
end

end
