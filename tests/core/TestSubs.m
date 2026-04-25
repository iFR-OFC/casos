% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Jan Olucak <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef TestSubs < TestPolynomialOperations
% Test substitution.

properties (SetAccess=protected)
    values       % test polynmials
    references   % reference solutions
end

properties (TestParameter)
    ivar = num2cell(1:4);
    dim =  num2cell(1:6);
    arg = num2cell(1:10);
end

methods (TestClassSetup)
    function initializeTestData(test_case)
        % Initialize test data for substitution operation.
        test_case.loadTestData("subs");

        test_case.fatalAssertLength(test_case.ivar,size(test_case.references.scalar.single,2));
        test_case.fatalAssertLength(test_case.dim,size(test_case.references.matrix.single,1));
        test_case.fatalAssertLength(test_case.arg,size(test_case.references.scalar.single,1));
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="scalar")
    function test_subs_single(test_case, ivar, arg)
        % Test substitution of a single variable.
        val = test_case.values.scalar{1,arg};
        new = test_case.values.scalar{2,arg};

        vars = val.indeterminates;
        if ivar > length(vars)
            % variable not in polynomial
            var = casos.Indeterminates('y');
        else
            var = vars(ivar);
        end

        actual = subs(val,var,new);
        reference = test_case.references.scalar.single{arg,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12);
    end

    function test_subs_multiple(test_case, ivar, arg)
        % Test substitution of multiple variables.
        val = test_case.values.scalar{2,arg};
        new = test_case.values.vector{2,val.nvars+1};

        vars = val.indeterminates;
        if ivar <= length(vars)
            % replace variable
            vars(ivar) = casos.Indeterminates('y');
        end
        
        actual = subs(val,vars,new);
        reference = test_case.references.scalar.multiple{arg,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["vector" "column"])
    function test_subs_single_column(test_case, ivar, dim)
        % Test substitution of a single variable in a column vector.
        val = test_case.values.vector{1,dim};
        new = test_case.values.scalar{1,dim};

        vars = val.indeterminates;
        if ivar > length(vars)
            % variable not in polynomial
            var = casos.Indeterminates('y');
        else
            var = vars(ivar);
        end

        actual = subs(val,var,new);
        reference = test_case.references.column.single{dim,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12);
    end

    function test_subs_multiple_column(test_case, ivar, dim)
        % Test substitution of multiple variables in a column vector.
        val = test_case.values.vector{2,dim};
        new = test_case.values.vector{1,val.nvars+1};

        vars = val.indeterminates;
        if ivar <= length(vars)
            % replace variable
            vars(ivar) = casos.Indeterminates('y');
        end
        
        actual = subs(val,vars,new);
        reference = test_case.references.column.multiple{dim,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["vector" "row"])
    function test_subs_single_row(test_case, ivar, dim)
        % Test substitution of a single variable in a row vector.
        val = test_case.values.vector{2,dim}';
        new = test_case.values.scalar{2,dim};

        vars = val.indeterminates;
        if ivar > length(vars)
            % variable not in polynomial
            var = casos.Indeterminates('y');
        else
            var = vars(ivar);
        end

        actual = subs(val,var,new);
        reference = test_case.references.row.single{dim,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12);
    end

    function test_subs_multiple_row(test_case, ivar, dim)
        % Test substitution of multiple variables in a row vector.
        val = test_case.values.vector{1,dim}';
        new = test_case.values.vector{2,val.nvars+1};

        vars = val.indeterminates;
        if ivar <= length(vars)
            % replace variable
            vars(ivar) = casos.Indeterminates('y');
        end
        
        actual = subs(val,vars,new);
        reference = test_case.references.row.multiple{dim,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="matrix")
    function test_subs_single_matrix(test_case, ivar, dim)
        % Test substitution of a single variable in a matrix.
        val = test_case.values.matrix{2,dim};
        new = test_case.values.scalar{1,dim};

        vars = val.indeterminates;
        if ivar > length(vars)
            % variable not in polynomial
            var = casos.Indeterminates('y');
        else
            var = vars(ivar);
        end

        actual = subs(val,var,new);
        reference = test_case.references.matrix.single{dim,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12);
    end

    function test_subs_multiple_matrix(test_case, ivar, dim)
        % Test substitution of multiple variables in a column vector.
        val = test_case.values.matrix{1,dim};
        new = test_case.values.vector{1,val.nvars+1};

        vars = val.indeterminates;
        if ivar <= length(vars)
            % replace variable
            vars(ivar) = casos.Indeterminates('y');
        end
        
        actual = subs(val,vars,new);
        reference = test_case.references.matrix.multiple{dim,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-12);
    end
end

end
