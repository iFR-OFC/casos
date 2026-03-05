classdef TestBinary < TestPolynomialOperations
% Test binary (element-wise) operations.

properties (TestParameter)
    test_values  % test polynmials
    references   % reference solutions

    op = {"plus" "minus" "times"};
    arg1         % index argument 1
    arg2         % index argument 2
end

methods (TestParameterDefinition, Static)
    function [test_values,references,arg1,arg2] = initializeTestData()
        [test_values,references] = TestBinary.loadTestData("binary");

        arg1 = num2cell(1:size(test_values{:},2));
        arg2 = num2cell(1:size(test_values{:},2));
    end
end

methods (Test, ParameterCombination="pairwise")
    function test_binary(test_case, test_values, references, op, arg1, arg2)
        actual = full(poly2basis(feval(op,test_values{1,arg1},test_values{2,arg2})));
        reference = references.(op){arg1,arg2};

        % perform assertion
        test_case.verifyEqual(actual,reference,"RelTol",1e-15)
    end

    function test_ldivide(test_case, test_values, references, arg1, arg2)
        vars = test_values{1,arg1}.indeterminates;
        test_value_deg0 = subs(test_values{1,arg1},vars,ones(length(vars),1));
        actual = full(poly2basis(ldivide(test_value_deg0,test_values{2,arg2})));
        reference = references.ldivide{arg1,arg2};

        % perform assertion
        test_case.verifyEqual(actual,reference,"RelTol",1e-15)
    end

    function test_rdivide(test_case, test_values, references, arg1, arg2)
        vars = test_values{2,arg2}.indeterminates;
        test_value_deg0 = subs(test_values{2,arg2},vars,ones(length(vars),1));
        actual = full(poly2basis(rdivide(test_values{1,arg1},test_value_deg0)));
        reference = references.rdivide{arg1,arg2};

        % perform assertion
        test_case.verifyEqual(actual,reference,"RelTol",1e-15)
    end
end

end
