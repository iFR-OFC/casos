classdef TestSubs < TestPolynomialOperations
% Test substitution.

properties (TestParameter)
    test_values  % test polynmials
    references   % reference solutions

    ivar = {1 2 3 4};
    arg          % index argument
end

methods (TestParameterDefinition, Static)
    function [test_values,references,arg] = initializeTestData()
        [test_values,references] = TestSubs.loadTestData("subs");

        arg = num2cell(1:size(test_values{:},2));
    end
end

methods (Test, ParameterCombination="pairwise")
    function test_subs_single(test_case, test_values, references, ivar, arg)
        vars = test_values{1,arg}.indeterminates;
        if ivar > length(vars)
            % variable not in polynomial
            var = casos.Indeterminates('y');
        else
            var = vars(ivar);
        end

        actual = full(poly2basis(subs(test_values{1,arg},var,test_values{2,arg})));
        reference = references.single{arg,ivar};

        % perform assertion
        test_case.verifyEqual(actual,reference,"RelTol",1e-12);
    end

    function test_subs_multiple(test_case, test_values, references, ivar, arg)
        vars = test_values{1,arg}.indeterminates;
        if ivar <= length(vars)
            % replace variable
            vars(ivar) = casos.Indeterminates('y');
        end
        if arg < size(test_values,2)/2
            new = vertcat(test_values{2,arg+(1:length(vars))});
        else
            new = vertcat(test_values{2,(end-arg)+(1:length(vars))});
        end

        actual = full(poly2basis(subs(test_values{1,arg},vars,new)));
        reference = references.multiple{arg,ivar};

        % perform assertion
        test_case.verifyEqual(actual,reference,"RelTol",1e-12);
    end
end

end
