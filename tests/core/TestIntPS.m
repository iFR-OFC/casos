% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Jan Olucak <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef (TestTags="PS") TestIntPS < TestSymbolicOperations
% Test integral operations on symbolic polynomials.

properties (SetAccess=protected)
    values       % test polynomials
    references   % reference solutions
end

properties (TestParameter)
    ivar = num2cell(1:4);

    dim =  num2cell(1:6);
    arg = num2cell(1:10);
end

methods (TestClassSetup)
    function initializeTestData(test_case)
        % Initialize test data for integral operations.
        test_case.loadTestData("int");

        test_case.fatalAssertLength(test_case.ivar,size(test_case.references.scalar.int1,2));
        test_case.fatalAssertLength(test_case.dim,size(test_case.references.matrix.int1,1));
        test_case.fatalAssertLength(test_case.arg,size(test_case.references.scalar.int1,1));
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="scalar")
    function test_int1_scalar(test_case, ivar, arg)
        % Test integral operation with respect to a single variable.
        value = test_case.values.scalar{1,arg};

        reference = test_case.references.scalar.int1{arg,ivar};
        
        test_case.evaluate_int1(ivar,value,reference);
    end

    function test_intN_scalar(test_case, ivar, arg)
        % Test integral operation with respect to multiple variables.
        value = test_case.values.scalar{2,arg};

        reference = test_case.references.scalar.intN{arg,ivar};
        
        test_case.evaluate_intN(ivar,value,reference);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["vector" "column"])
    function test_int1_column(test_case, ivar, dim)
        % Test integral operation on column vector
        % with respect to a single variable.
        value = test_case.values.vector{1,dim};

        reference = test_case.references.column.int1{dim,ivar};
        
        test_case.evaluate_int1(ivar,value,reference);
    end

    function test_intN_column(test_case, ivar, dim)
        % Test integral operation on column vector 
        % with respect to multiple variables.
        value = test_case.values.vector{2,dim};

        reference = test_case.references.column.intN{dim,ivar};

        test_case.evaluate_intN(ivar,value,reference);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["vector" "row"])
    function test_int1_row(test_case, ivar, dim)
        % Test integral operation on row vector
        % with respect to a single variable.
        value = test_case.values.vector{2,dim}';

        reference = test_case.references.row.int1{dim,ivar};
        
        test_case.evaluate_int1(ivar,value,reference);
    end

    function test_intN_row(test_case, ivar, dim)
        % Test integral operation on row vector 
        % with respect to multiple variables.
        value = test_case.values.vector{1,dim}';

        reference = test_case.references.row.intN{dim,ivar};

        test_case.evaluate_intN(ivar,value,reference);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="matrix")
    function test_int1_matrix(test_case, ivar, dim)
        % Test integral operation on matrix 
        % with respect to a single variable.
        value = test_case.values.matrix{1,dim};

        reference = test_case.references.matrix.int1{dim,ivar};

        test_case.evaluate_int1(ivar,value,reference);
    end

    function test_intN_matrix(test_case, ivar, dim)
        % Test integral operation on matrix 
        % with respect to multiple variables.
        value = test_case.values.matrix{2,dim};

        reference = test_case.references.matrix.intN{dim,ivar};

        test_case.evaluate_intN(ivar,value,reference);
    end
end

methods
    function evaluate_int1(test_case, ivar, value, reference)
        % Evaluate integral in single variable.
        vars = value.indeterminates;

        if ivar > length(vars)
            % variable not in polynomial
            var = casos.Indeterminates('y');
        else
            var = vars(ivar);
        end

        % symbolic polynomial
        [p,symbol,argument] = test_case.get_operand(true,value);

        % build symbolic function
        expression = int(p,var);
        f = casos.Function('f',symbol,{expression});

        actual = f(argument{:});

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end

    function evaluate_intN(test_case, ivar, value, reference)
        % Evaluate integral in multiple variables.
        vars = value.indeterminates;

        if ivar <= length(vars)
            % replace variable
            vars(ivar) = casos.Indeterminates('y');
        end

        % symbolic polynomial
        [p,symbol,argument] = test_case.get_operand(true,value);

        % build symbolic function
        expression = int(p,vars);
        f = casos.Function('f',symbol,{expression});

        actual = f(argument{:});

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end
end

end
