% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Jan Olucak <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef TestNabla < TestPolynomialOperations
% Test nabla operations.

properties (TestParameter)
    test_values  % test polynmials
    references   % reference solutions

    ivar = {1 2 3 4};
    dim = {1 2 3 4 5 6};
    arg          % index argument
end

methods (TestParameterDefinition, Static)
    function [test_values,references,arg] = initializeTestData()
        % Initialize test data for nabla operations.
        [test_values,references] = TestNabla.loadTestData("nabla");

        arg = num2cell(1:size(test_values{:}.scalar,2));
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="scalar")
    function test_derivative(test_case, test_values, references, ivar, arg)
        % Test nabla operation with respect to a single variable.
        val = test_values.scalar{1,arg};
        vars = val.indeterminates;
        if ivar > length(vars)
            % variable not in polynomial
            var = casos.Indeterminates('y');
        else
            var = vars(ivar);
        end

        actual = nabla(val,var);
        reference = references.scalar.derivative{arg,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end

    function test_gradient(test_case, test_values, references, ivar, arg)
        % Test nabla operation with respect to multiple variables.
        val = test_values.scalar{2,arg};
        vars = val.indeterminates;
        if ivar <= length(vars)
            % replace variable
            vars(ivar) = casos.Indeterminates('y');
        end

        actual = nabla(val,vars);
        reference = references.scalar.gradient{arg,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["vector" "column"])
    function test_derivative_column(test_case, test_values, references, ivar, dim)
        % Test nabla operation on column vector
        % with respect to a single variable.
        val = test_values.vector{1,dim};
        vars = val.indeterminates;
        if ivar > length(vars)
            % variable not in polynomial
            var = casos.Indeterminates('y');
        else
            var = vars(ivar);
        end

        actual = nabla(val,var);
        reference = references.column.derivative{dim,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end

    function test_gradient_column(test_case, test_values, references, ivar, dim)
        % Test nabla operation on column vector 
        % with respect to multiple variables.
        val = test_values.vector{2,dim};
        vars = val.indeterminates;
        if ivar <= length(vars)
            % replace variable
            vars(ivar) = casos.Indeterminates('y');
        end

        actual = nabla(val,vars);
        reference = references.column.gradient{dim,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["vector" "row"])
    function test_derivative_row(test_case, test_values, references, ivar, dim)
        % Test nabla operation on row vector
        % with respect to a single variable.
        val = test_values.vector{2,dim}';
        vars = val.indeterminates;
        if ivar > length(vars)
            % variable not in polynomial
            var = casos.Indeterminates('y');
        else
            var = vars(ivar);
        end

        actual = nabla(val,var);
        reference = references.row.derivative{dim,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end

    function test_gradient_row(test_case, test_values, references, ivar, dim)
        % Test nabla operation on row vector 
        % with respect to multiple variables.
        val = test_values.vector{1,dim}';
        vars = val.indeterminates;
        if ivar <= length(vars)
            % replace variable
            vars(ivar) = casos.Indeterminates('y');
        end

        actual = nabla(val,vars);
        reference = references.row.gradient{dim,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="matrix")
    function test_derivative_matrix(test_case, test_values, references, ivar, dim)
        % Test nabla operation on matrix with respect to a single variable.
        val = test_values.matrix{1,dim};
        vars = val.indeterminates;
        if ivar > length(vars)
            % variable not in polynomial
            var = casos.Indeterminates('y');
        else
            var = vars(ivar);
        end

        actual = nabla(val,var);
        reference = references.matrix.derivative{dim,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end

    function test_gradient_matrix(test_case, test_values, references, ivar, dim)
        % Test nabla operation on matrix with respect to multiple variables.
        val = test_values.matrix{2,dim};
        vars = val.indeterminates;
        if ivar <= length(vars)
            % replace variable
            vars(ivar) = casos.Indeterminates('y');
        end

        actual = nabla(val,vars);
        reference = references.matrix.gradient{dim,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end
end

end
