classdef TestRemoveCoeffs < TestPolynomialOperations
% Test remove_coeffs operation.

properties (TestParameter)
    test_values  % test polynmials
    references   % reference solutions

    decade = {1 2 3};
    arg          % index argument
end

methods (TestParameterDefinition, Static)
    function [test_values,references,arg] = initializeTestData()
        % Initialize test data for remove_coeff operation.
        [test_values,references] = TestUnary.loadTestData("remove_coeffs");

        arg = num2cell(1:size(test_values{:},2));
    end
end

methods (Test, ParameterCombination="pairwise")
    function test_remove_coeffs(test_case, test_values, references, decade, arg)
        % Test remove_coeff operation.
        tol = prctile(full(poly2basis(test_values{arg})),10*decade);
        actual = full(poly2basis(remove_coeffs(test_values{arg},tol)));
        reference = references.remove_coeffs{arg,decade};

        % perform assertion
        test_case.verifyEqual(actual,reference,"RelTol",1e-12);
    end
end

end
