% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Jan Olucak <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef TestIsLinear < TestSymbolicOperations
% Test is_linear of symbolic operations.

properties (TestParameter)
    test_values  % test polynmials

    op1 = {"uplus" "uminus"}; 
    op2 = {"plus" "minus" "times"};
    symb1 = {false true};
    symb2 = {false true};

    dim1 = {1 2 3 4 5 6};
    dim2 = {1 2 3 4 5 6};
    arg1         % index argument 1
    arg2         % index argument 2
end

methods (TestParameterDefinition, Static)
    function [test_values,arg1,arg2] = initializeTestData()
        % Initialize test values.
        [test_values] = TestIsLinear.loadTestData();

        arg1 = num2cell(1:size(test_values{:}.scalar,2));
        arg2 = num2cell(1:size(test_values{:}.scalar,2));
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="scalar")
    function test_unary(test_case, test_values, op1, symb1, arg1)
        % Test is_linear of a unary operation.
        val1 = test_values.scalar{1,arg1};
        val2 = test_values.scalar{2,arg1};
        
        test_case.evaluate_unary(op1,symb1,val1,val2);
    end

    function test_bilinear(test_case, test_values, op2, symb1, arg1)
        % Test is_linear of a bilinear operation.
        val1 = test_values.scalar{1,arg1};
        val2 = test_values.scalar{2,arg1};

        test_case.evaluate_bilinear(op2,symb1,val1,val2,false);
    end

    function test_binary(test_case, test_values, op2, symb1, symb2, arg1, arg2)
        % Test is_linear of a binary operation.
        val1 = test_values.scalar{1,arg1};
        val2 = test_values.scalar{2,arg2};
        val3 = test_values.scalar{arg1+arg2};

        test_case.evaluate_binary(op2,symb1,symb2,val1,val2,val3);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="vector")
    function test_unary_column(test_case, test_values, op1, symb1, dim1)
        % Test is_linear of a unary operation on column vectors.
        val1 = test_values.vector{1,dim1};
        val2 = test_values.vector{2,dim1};
        
        test_case.evaluate_unary(op1,symb1,val1,val2);
    end

    function test_unary_row(test_case, test_values, op1, symb1, dim1)
        % Test is_linear of a unary operation on row vectors.
        val1 = test_values.vector{1,dim1}';
        val2 = test_values.vector{2,dim1}';
        
        test_case.evaluate_unary(op1,symb1,val1,val2);
    end

    function test_bilinear_inner(test_case, test_values, op2, symb1, dim1)
        % Test is_linear of a bilinear (inner) operation on vectors.
        val1 = test_values.vector{1,dim1};
        val2 = test_values.vector{2,dim1};

        test_case.evaluate_bilinear(op2,symb1,val1,val2,true);
    end

    function test_bilinear_outer(test_case, test_values, op2, symb1, dim1)
        % Test is_linear of a bilinear (outer) operation on vectors.
        val1 = test_values.vector{1,dim1}';
        val2 = test_values.vector{2,dim1};

        test_case.evaluate_bilinear(op2,symb1,val1,val2,true);
    end

    function test_binary_inner(test_case, test_values, op2, symb1, symb2, dim1, dim2)
        % Test is_linear of a binary (inner) operation on vectors.
        val1 = test_values.vector{1,dim1}';
        val2 = test_values.vector{2,dim2};
        val3 = test_values.vector{dim1+dim2};

        test_case.evaluate_binary(op2,symb1,symb2,val1,val2,val3);
    end

    function test_binary_outer(test_case, test_values, op2, symb1, symb2, dim1, dim2)
        % Test is_linear of a binary (outer) operation on vectors.
        val1 = test_values.vector{1,dim1};
        val2 = test_values.vector{2,dim2}';
        val3 = test_values.vector{dim1+dim2};

        test_case.evaluate_binary(op2,symb1,symb2,val1,val2,val3);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="matrix")
    function test_unary_matrix(test_case, test_values, op1, symb1, dim1)
        % Test is_linear of a unary operation on matrices.
        val1 = test_values.matrix{1,dim1};
        val2 = test_values.matrix{2,dim1};
        
        test_case.evaluate_unary(op1,symb1,val1,val2);
    end

    function test_bilinear_matrix(test_case, test_values, op2, symb1, dim1)
        % Test is_linear of a bilinear operation on matrices.
        val1 = test_values.matrix{1,dim1};
        val2 = test_values.matrix{2,dim1};

        test_case.evaluate_bilinear(op2,symb1,val1,val2,false);
    end

    function test_binary_matrix(test_case, test_values, op2, symb1, symb2, dim1, dim2)
        % Test is_linear of a binary operation on matrices.
        val1 = test_values.matrix{1,dim1};
        val2 = test_values.matrix{2,dim2};
        val3 = test_values.matrix{dim1+dim2};

        test_case.evaluate_binary(op2,symb1,symb2,val1,val2,val3);
    end
end

methods 
    function evaluate_unary(test_case, op1, symb1, val1, val2)
        % Evaluate unary operation.
        if (symb1)
            % symbolic operand
            p = casos.PS.sym('p',sparsity(val1));
        else
            % numeric operand
            p = val1;
        end

        % symbolic polynomial
        x = casos.PS.sym('x',sparsity(val2));

        % apply operation
        q = casos.PS(feval(op1,p));

        actual1 = @() is_linear(q,x);
        actual2 = @() is_linear(q,p);

        % perform assertions
        test_case.verifyReturnsTrue(actual1);

        if (~symb1) && ~isempty(q)
            diagtext = "Expected exception for nonsymbolic variable.";
            test_case.verifyError(actual2,?MException,diagtext);
        else
            test_case.verifyReturnsTrue(actual2);
        end
    end

    function evaluate_bilinear(test_case, op2, symb1, val1, val2, trans)
        % Evaluate bilinear operation.
        if (symb1)
            % symbolic operand
            p = casos.PS.sym('p',sparsity(val1));
        else
            % numeric operand
            p = val1;
        end
        if (trans)
            % transpose first argument
            p1 = p';
        else
            p1 = p;
        end

        % symbolic polynomial
        x = casos.PS.sym('x',sparsity(val2));

        % apply operation
        r = casos.PS(feval(op2,p1,p));

        actual1 = @() is_linear(r,x);
        actual2 = @() is_linear(r,p);
        actual3 = @() ~is_linear(r,p);

        test_case.verifyReturnsTrue(actual1);

        if (~symb1) && ~isempty(p)
            diagtext = "Expected exception for nonsymbolic variable.";
            test_case.verifyError(actual2,?MException,diagtext);
        elseif isempty(p) || ismember(op2,["plus" "minus"])
            test_case.verifyReturnsTrue(actual2);
        else
            test_case.verifyReturnsTrue(actual3);
        end
    end

    function evaluate_binary(test_case, op2, symb1, symb2, val1, val2, val3)
        % Evaluate binary operation.
        if (symb1)
            % symbolic operand
            p = casos.PS.sym('p',sparsity(val1));
        else
            % numeric operand
            p = val1;
        end

        if (symb2)
            % symbolic operand
            q = casos.PS.sym('q',sparsity(val2));
        else
            % numeric operand
            q = val2;
        end

        % symbolic polynomial
        x = casos.PS.sym('x',sparsity(val3));

        try
            % apply operation
            r = casos.PS(feval(op2,p,q));

        catch e
            test_case.assumeFail(e.message);
        end

        actual1 = @() is_linear(r,x);
        actual2 = @() is_linear(r,p);
        actual3 = @() is_linear(r,q);

        % perform assertions
        test_case.verifyReturnsTrue(actual1);

        if (~symb1) && ~isempty(p)
            diagtext = "Expected exception for nonsymbolic variable.";
            test_case.verifyError(actual2,?MException,diagtext);
        else
            test_case.verifyReturnsTrue(actual2);
        end
        if (~symb2) && ~isempty(q)
            diagtext = "Expected exception for nonsymbolic variable.";
            test_case.verifyError(actual3,?MException,diagtext);
        else
            test_case.verifyReturnsTrue(actual3);
        end
    end
end

end
