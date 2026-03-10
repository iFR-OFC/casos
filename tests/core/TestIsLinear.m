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

    arg1         % index argument 1
    arg2         % index argument 2
end

methods (TestParameterDefinition, Static)
    function [test_values,arg1,arg2] = initializeTestData()
        % Initialize test values.
        [test_values] = TestIsLinear.loadTestData();

        arg1 = num2cell(1:size(test_values{:},2));
        arg2 = num2cell(1:size(test_values{:},2));
    end
end

methods (Test, ParameterCombination="pairwise")
    function test_unary(test_case, test_values, op1, symb1, arg1)
        % Test is_linear of a unary operation.
        if (symb1)
            % symbolic operand
            p = casos.PS.sym('p',sparsity(test_values{1,arg1}));
        else
            % numeric operand
            p = test_values{1,arg1};
        end

        % symbolic polynomial
        x = casos.PS.sym('x',sparsity(test_values{2,arg1}));

        % apply operation
        q = feval(op1,p);

        actual1 = @() is_linear(q,x);
        actual2 = @() is_linear(q,p);

        % perform assertions
        test_case.verifyReturnsTrue(actual1);

        if (~symb1)
            test_case.verifyError(actual2,?MException);
        else
            test_case.verifyReturnsTrue(actual2);
        end
    end

    function test_bilinear(test_case, test_values, op2, symb1, arg1)
        % Test is_linear of a bilinear operation.
        if (symb1)
            % symbolic operand
            p = casos.PS.sym('p',sparsity(test_values{1,arg1}));
        else
            % numeric operand
            p = test_values{1,arg1};
        end

        % symbolic polynomial
        x = casos.PS.sym('x',sparsity(test_values{2,arg1}));

        % apply operation
        r = feval(op2,p,p);

        actual1 = @() is_linear(r,x);
        actual2 = @() is_linear(r,p);
        actual3 = @() ~is_linear(r,p);

        test_case.verifyReturnsTrue(actual1);

        if (~symb1)
            test_case.verifyError(actual2,?MException);
        elseif ismember(op2,["plus" "minus"])
            test_case.verifyReturnsTrue(actual2);
        else
            test_case.verifyReturnsTrue(actual3);
        end
    end

    function test_binary(test_case, test_values, op2, symb1, symb2, arg1, arg2)
        % Test is_linear of a binary operation.
        if (symb1)
            % symbolic operand
            p = casos.PS.sym('p',sparsity(test_values{1,arg1}));
        else
            % numeric operand
            p = test_values{1,arg1};
        end

        if (symb2)
            % symbolic operand
            q = casos.PS.sym('q',sparsity(test_values{2,arg2}));
        else
            % numeric operand
            q = test_values{2,arg2};
        end

        % symbolic polynomial
        x = casos.PS.sym('x',sparsity(test_values{arg1+arg2}));

        % apply operation
        r = feval(op2,p,q);

        actual1 = @() is_linear(r,x);
        actual2 = @() is_linear(r,p);
        actual3 = @() is_linear(r,q);

        % perform assertions
        test_case.verifyReturnsTrue(actual1);

        if (~symb1)
            test_case.verifyError(actual2,?MException);
        else
            test_case.verifyReturnsTrue(actual2);
        end
        if (~symb2)
            test_case.verifyError(actual3,?MException);
        else
            test_case.verifyReturnsTrue(actual3);
        end
    end
end

end
