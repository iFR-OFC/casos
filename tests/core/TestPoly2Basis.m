classdef TestPoly2Basis < TestPolynomialOperations
% Test poly2basis operation.

properties (TestParameter)
    test_values  % test polynmials
    references   % reference solutions

    arg1         % index argument 1
    arg2         % index argument 2
end

methods (TestParameterDefinition, Static)
    function [test_values,references,arg1,arg2] = initializeTestData()
        [test_values,references] = TestPoly2Basis.loadTestData("poly2basis");

        arg1 = num2cell(1:size(test_values{:},2));
        arg2 = num2cell(1:size(test_values{:},2));
    end
end

methods (Test, ParameterCombination="pairwise")
    function test_poly2basis(test_case, test_values, references, arg1, arg2)
        basis = sparsity(test_values{1,arg1});
        actual = full(poly2basis(test_values{2,arg2},basis));
        reference = references.poly2basis{arg1,arg2};

        % perform assertion
        test_case.verifyEqual(actual,reference,"RelTol",1e-15);
    end
end

end
