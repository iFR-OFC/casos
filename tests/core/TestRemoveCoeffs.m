% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Jan Olucak <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

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
        actual = remove_coeffs(test_values{arg},tol);
        reference = references.remove_coeffs{arg,decade};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12);
    end
end

end
