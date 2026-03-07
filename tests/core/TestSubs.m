% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Jan Olucak <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

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
        % Initialize test data for substitution operation.
        [test_values,references] = TestSubs.loadTestData("subs");

        arg = num2cell(1:size(test_values{:},2));
    end
end

methods (Test, ParameterCombination="pairwise")
    function test_subs_single(test_case, test_values, references, ivar, arg)
        % Test substitution of a single variable.
        vars = test_values{1,arg}.indeterminates;
        if ivar > length(vars)
            % variable not in polynomial
            var = casos.Indeterminates('y');
        else
            var = vars(ivar);
        end

        actual = subs(test_values{1,arg},var,test_values{2,arg});
        reference = references.single{arg,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12);
    end

    function test_subs_multiple(test_case, test_values, references, ivar, arg)
        % Test substitution of multiple variables.
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

        actual = subs(test_values{1,arg},vars,new);
        reference = references.multiple{arg,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12);
    end
end

end
