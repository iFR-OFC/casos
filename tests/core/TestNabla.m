classdef TestNabla < TestPolynomialOperations
% Test nabla operations.

properties (TestParameter)
    test_values  % test polynmials
    references   % reference solutions

    ivar = {1 2 3 4};
    arg          % index argument
end

methods (TestParameterDefinition, Static)
    function [test_values,references,arg] = initializeTestData()
        % Initialize test data for nabla operations.
        [test_values,references] = TestNabla.loadTestData("nabla");

        arg = num2cell(1:size(test_values{:},2));
    end
end

methods (Test, ParameterCombination="pairwise")
    function test_derivative(test_case, test_values, references, ivar, arg)
        % Test nabla operation with respect to a single variable.
        vars = test_values{arg}.indeterminates;
        if ivar > length(vars)
            % variable not in polynomial
            var = casos.Indeterminates('y');
        else
            var = vars(ivar);
        end

        actual = full(poly2basis(nabla(test_values{arg},var)));
        reference = references.derivative{arg,ivar};

        % perform assertion
        test_case.verifyEqual(actual,reference,"RelTol",1e-15);
    end

    function test_gradient(test_case, test_values, references, ivar, arg)
        % Test nabla operation with respect to multiple variables.
        vars = test_values{arg}.indeterminates;
        if ivar <= length(vars)
            % replace variable
            vars(ivar) = casos.Indeterminates('y');
        end

        actual = full(poly2basis(nabla(test_values{arg},vars)));
        reference = references.gradient{arg,ivar};

        % perform assertion
        test_case.verifyEqual(actual,reference,"RelTol",1e-15);
    end
end

end
