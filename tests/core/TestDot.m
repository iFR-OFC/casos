classdef TestDot < TestPolynomialOperations
% Test dot operation.

properties (TestParameter)
    test_values  % test polynmials
    references   % reference solutions

    arg1         % index argument 1
    arg2         % index argument 2
end

methods (TestParameterDefinition, Static)
    function [test_values,references,arg1,arg2] = initializeTestData()
        % Initialize test data for dot operations.
        [test_values,references] = TestDot.loadTestData("dot");

        arg1 = num2cell(1:size(test_values{:},2));
        arg2 = num2cell(1:size(test_values{:},2));
    end
end

methods (Test, ParameterCombination="pairwise")
    function test_dot(test_case, test_values, references, arg1, arg2)
        % Test dot operation.
        actual = full(dot(test_values{1,arg1},test_values{2,arg2}));
        reference = references.dot{arg1,arg2};

        % Perform assertions if needed
        test_case.verifyEqual(actual,reference,"RelTol",1e-15);
    end
end

end
