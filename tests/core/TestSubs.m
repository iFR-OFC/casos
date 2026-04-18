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
    dim = {1 2 3 4 5 6};
    arg          % index argument
end

methods (TestParameterDefinition, Static)
    function [test_values,references,arg] = initializeTestData()
        % Initialize test data for substitution operation.
        [test_values,references] = TestSubs.loadTestData("subs");

        arg = num2cell(1:size(test_values{:}.scalar,2));
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="scalar")
    function test_subs_single(test_case, test_values, references, ivar, arg)
        % Test substitution of a single variable.
        val = test_values.scalar{1,arg};
        new = test_values.scalar{2,arg};

        vars = val.indeterminates;
        if ivar > length(vars)
            % variable not in polynomial
            var = casos.Indeterminates('y');
        else
            var = vars(ivar);
        end

        actual = subs(val,var,new);
        reference = references.scalar.single{arg,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12);
    end

    function test_subs_multiple(test_case, test_values, references, ivar, arg)
        % Test substitution of multiple variables.
        val = test_values.scalar{2,arg};
        new = test_values.vector{2,val.nvars+1};

        vars = val.indeterminates;
        if ivar <= length(vars)
            % replace variable
            vars(ivar) = casos.Indeterminates('y');
        end
        
        actual = subs(val,vars,new);
        reference = references.scalar.multiple{arg,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["vector" "column"])
    function test_subs_single_column(test_case, test_values, references, ivar, dim)
        % Test substitution of a single variable in a column vector.
        val = test_values.vector{1,dim};
        new = test_values.scalar{1,dim};

        vars = val.indeterminates;
        if ivar > length(vars)
            % variable not in polynomial
            var = casos.Indeterminates('y');
        else
            var = vars(ivar);
        end

        actual = subs(val,var,new);
        reference = references.column.single{dim,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12);
    end

    function test_subs_multiple_column(test_case, test_values, references, ivar, dim)
        % Test substitution of multiple variables in a column vector.
        val = test_values.vector{2,dim};
        new = test_values.vector{1,val.nvars+1};

        vars = val.indeterminates;
        if ivar <= length(vars)
            % replace variable
            vars(ivar) = casos.Indeterminates('y');
        end
        
        actual = subs(val,vars,new);
        reference = references.column.multiple{dim,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["vector" "row"])
    function test_subs_single_row(test_case, test_values, references, ivar, dim)
        % Test substitution of a single variable in a row vector.
        val = test_values.vector{2,dim}';
        new = test_values.scalar{2,dim};

        vars = val.indeterminates;
        if ivar > length(vars)
            % variable not in polynomial
            var = casos.Indeterminates('y');
        else
            var = vars(ivar);
        end

        actual = subs(val,var,new);
        reference = references.row.single{dim,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12);
    end

    function test_subs_multiple_row(test_case, test_values, references, ivar, dim)
        % Test substitution of multiple variables in a row vector.
        val = test_values.vector{1,dim}';
        new = test_values.vector{2,val.nvars+1};

        vars = val.indeterminates;
        if ivar <= length(vars)
            % replace variable
            vars(ivar) = casos.Indeterminates('y');
        end
        
        actual = subs(val,vars,new);
        reference = references.row.multiple{dim,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="matrix")
    function test_subs_single_matrix(test_case, test_values, references, ivar, dim)
        % Test substitution of a single variable in a matrix.
        val = test_values.matrix{2,dim};
        new = test_values.scalar{1,dim};

        vars = val.indeterminates;
        if ivar > length(vars)
            % variable not in polynomial
            var = casos.Indeterminates('y');
        else
            var = vars(ivar);
        end

        actual = subs(val,var,new);
        reference = references.matrix.single{dim,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12);
    end

    function test_subs_multiple_matrix(test_case, test_values, references, ivar, dim)
        % Test substitution of multiple variables in a column vector.
        val = test_values.matrix{1,dim};
        new = test_values.vector{1,val.nvars+1};

        vars = val.indeterminates;
        if ivar <= length(vars)
            % replace variable
            vars(ivar) = casos.Indeterminates('y');
        end
        
        actual = subs(val,vars,new);
        reference = references.matrix.multiple{dim,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12);
    end
end

end
