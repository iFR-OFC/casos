% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Jan Olucak <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef TestNabla < TestPolynomialOperations
% Test nabla operations.

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
        % Initialize test data for nabla operations.
        test_case.loadTestData("nabla");

        test_case.fatalAssertLength(test_case.ivar,size(test_case.references.scalar.derivative,2));
        test_case.fatalAssertLength(test_case.dim,size(test_case.references.matrix.derivative,1));
        test_case.fatalAssertLength(test_case.arg,size(test_case.references.scalar.derivative,1));
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="scalar")
    function test_derivative(test_case, ivar, arg)
        % Test nabla operation with respect to a single variable.
        val = test_case.values.scalar{1,arg};
        vars = val.indeterminates;
        if ivar > length(vars)
            % variable not in polynomial
            var = casos.Indeterminates('y');
        else
            var = vars(ivar);
        end

        actual = nabla(val,var);
        reference = test_case.references.scalar.derivative{arg,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end

    function test_gradient(test_case, ivar, arg)
        % Test nabla operation with respect to multiple variables.
        val = test_case.values.scalar{2,arg};
        vars = val.indeterminates;
        if ivar <= length(vars)
            % replace variable
            vars(ivar) = casos.Indeterminates('y');
        end

        actual = nabla(val,vars);
        reference = test_case.references.scalar.gradient{arg,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["vector" "column"])
    function test_derivative_column(test_case, ivar, dim)
        % Test nabla operation on column vector
        % with respect to a single variable.
        val = test_case.values.vector{1,dim};
        vars = val.indeterminates;
        if ivar > length(vars)
            % variable not in polynomial
            var = casos.Indeterminates('y');
        else
            var = vars(ivar);
        end

        actual = nabla(val,var);
        reference = test_case.references.column.derivative{dim,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end

    function test_gradient_column(test_case, ivar, dim)
        % Test nabla operation on column vector 
        % with respect to multiple variables.
        val = test_case.values.vector{2,dim};
        vars = val.indeterminates;
        if ivar <= length(vars)
            % replace variable
            vars(ivar) = casos.Indeterminates('y');
        end

        actual = nabla(val,vars);
        reference = test_case.references.column.gradient{dim,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["vector" "row"])
    function test_derivative_row(test_case, ivar, dim)
        % Test nabla operation on row vector
        % with respect to a single variable.
        val = test_case.values.vector{2,dim}';
        vars = val.indeterminates;
        if ivar > length(vars)
            % variable not in polynomial
            var = casos.Indeterminates('y');
        else
            var = vars(ivar);
        end

        actual = nabla(val,var);
        reference = test_case.references.row.derivative{dim,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end

    function test_gradient_row(test_case, ivar, dim)
        % Test nabla operation on row vector 
        % with respect to multiple variables.
        val = test_case.values.vector{1,dim}';
        vars = val.indeterminates;
        if ivar <= length(vars)
            % replace variable
            vars(ivar) = casos.Indeterminates('y');
        end

        actual = nabla(val,vars);
        reference = test_case.references.row.gradient{dim,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="matrix")
    function test_derivative_matrix(test_case, ivar, dim)
        % Test nabla operation on matrix with respect to a single variable.
        val = test_case.values.matrix{1,dim};
        vars = val.indeterminates;
        if ivar > length(vars)
            % variable not in polynomial
            var = casos.Indeterminates('y');
        else
            var = vars(ivar);
        end

        actual = nabla(val,var);
        reference = test_case.references.matrix.derivative{dim,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end

    function test_gradient_matrix(test_case, ivar, dim)
        % Test nabla operation on matrix with respect to multiple variables.
        val = test_case.values.matrix{2,dim};
        vars = val.indeterminates;
        if ivar <= length(vars)
            % replace variable
            vars(ivar) = casos.Indeterminates('y');
        end

        actual = nabla(val,vars);
        reference = test_case.references.matrix.gradient{dim,ivar};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end
end

end
