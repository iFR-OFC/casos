% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Jan Olucak <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef TestBinary < TestPolynomialOperations
% Test binary (element-wise) operations.

properties (SetAccess=protected)
    values       % test polynmials
    references   % reference solutions
end

properties (TestParameter)
    op = {"plus" "minus" "times"};
    dim1 = num2cell(1:6);
    dim2 = num2cell(1:6);
    arg1 = num2cell(1:10);
    arg2 = num2cell(1:10);
end

methods (TestClassSetup)
    function initializeTestData(test_case)
        % Initialize test data for binary operations.
        test_case.loadTestData("binary");

        test_case.fatalAssertLength(test_case.dim1,size(test_case.references.matrix.plus,1));
        test_case.fatalAssertLength(test_case.dim2,size(test_case.references.matrix.plus,2));
        test_case.fatalAssertLength(test_case.arg1,size(test_case.references.scalar.plus,1));
        test_case.fatalAssertLength(test_case.arg2,size(test_case.references.scalar.plus,2));
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="scalar")
    function test_binary(test_case, op, arg1, arg2)
        % Test binary operation.
        actual = feval(op,test_case.values.scalar{1,arg1},test_case.values.scalar{2,arg2});
        reference = test_case.references.scalar.(op){arg1,arg2};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end

    function test_ldivide(test_case, arg1, arg2)
        % Test left-side division.
        val1 = test_case.values.scalar{1,arg1};
        vars = val1.indeterminates;
        test_value_deg0 = subs(val1,vars,ones(length(vars),1));
        actual = ldivide(test_value_deg0,test_case.values.scalar{2,arg2});
        reference = test_case.references.scalar.ldivide{arg1,arg2};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end

    function test_rdivide(test_case, arg1, arg2)
        % Test right-side division.
        val2 = test_case.values.scalar{2,arg2};
        vars = val2.indeterminates;
        test_value_deg0 = subs(val2,vars,ones(length(vars),1));
        actual = rdivide(test_case.values.scalar{1,arg1},test_value_deg0);
        reference = test_case.references.scalar.rdivide{arg1,arg2};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["vector" "inner"])
    function test_binary_inner(test_case, op, dim1, dim2)
        % Test binary operation on row-by-column vectors.
        actual = feval(op,test_case.values.vector{1,dim1}',test_case.values.vector{2,dim2});
        reference = test_case.references.inner.(op){dim1,dim2};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end

    function test_ldivide_inner(test_case, dim1, dim2)
        % Test left-side division on row-by-column vectors.
        val1 = test_case.values.vector{1,dim1}';
        vars = val1.indeterminates;
        test_value_deg0 = 1+subs(val1,vars,ones(length(vars),1));
        actual = ldivide(test_value_deg0,test_case.values.vector{2,dim2});
        reference = test_case.references.inner.ldivide{dim1,dim2};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end

    function test_rdivide_inner(test_case, dim1, dim2)
        % Test right-side division on row-by-column vectors.
        val2 = test_case.values.vector{2,dim2};
        vars = val2.indeterminates;
        test_value_deg0 = 1+subs(val2,vars,ones(length(vars),1));
        actual = rdivide(test_case.values.vector{1,dim1}',test_value_deg0);
        reference = test_case.references.inner.rdivide{dim1,dim2};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["vector" "outer"])
    function test_binary_outer(test_case, op, dim1, dim2)
        % Test binary operation on column-by-row vectors.
        actual = feval(op,test_case.values.vector{1,dim1},test_case.values.vector{2,dim2}');
        reference = test_case.references.outer.(op){dim1,dim2};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end

    function test_ldivide_outer(test_case, dim1, dim2)
        % Test left-side division on column-by-row vectors.
        val1 = test_case.values.vector{1,dim1};
        vars = val1.indeterminates;
        test_value_deg0 = 1+subs(val1,vars,ones(length(vars),1));
        actual = ldivide(test_value_deg0,test_case.values.vector{2,dim2}');
        reference = test_case.references.outer.ldivide{dim1,dim2};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end

    function test_rdivide_outer(test_case, dim1, dim2)
        % Test right-side division on column-by-row vectors.
        val2 = test_case.values.vector{2,dim2}';
        vars = val2.indeterminates;
        test_value_deg0 = 1+subs(val2,vars,ones(length(vars),1));
        actual = rdivide(test_case.values.vector{1,dim1},test_value_deg0);
        reference = test_case.references.outer.rdivide{dim1,dim2};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["matrix"])
    function test_binary_matrix(test_case, op, dim1, dim2)
        % Test binary operation on matrices.
        val1 = test_case.values.matrix{1,dim1};
        val2 = test_case.values.matrix{2,dim2};

        if (~isrow(val1) && ~isrow(val2) && size(val1,1) ~= size(val2,1)) ...
                    || (~iscolumn(val1) && ~iscolumn(val2) && size(val1,2) ~= size(val2,2))
            % dimension mismatch
            diagtext = sprintf('Dimension mismatch expected: %s vs. %s.',mat2str(size(val1)),mat2str(size(val2)));
            test_case.verifyError(@() feval(op,val1,val2),?MException,diagtext);
            return
        end

        % else
        actual = feval(op,val1,val2);
        reference = test_case.references.matrix.(op){dim1,dim2};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end

    function test_ldivide_matrix(test_case, dim1, dim2)
        % Test left-side division on matrices.
        val1 = test_case.values.matrix{1,dim1};
        vars = val1.indeterminates;
        test_value_deg0 = 1+subs(val1,vars,ones(length(vars),1));
        val2 = test_case.values.matrix{2,dim2};
        
        if (~isrow(val1) && ~isrow(val2) && size(val1,1) ~= size(val2,1)) ...
                    || (~iscolumn(val1) && ~iscolumn(val2) && size(val1,2) ~= size(val2,2))
            % dimension mismatch
            diagtext = sprintf('Dimension mismatch expected: %s vs. %s.',mat2str(size(val1)),mat2str(size(val2)));
            test_case.verifyError(@() ldivide(val1,val2),?MException,diagtext);
            return
        end

        % else
        actual = ldivide(test_value_deg0,val2);
        reference = test_case.references.matrix.ldivide{dim1,dim2};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end

    function test_rdivide_matrix(test_case, dim1, dim2)
        % Test right-side division on matrices.
        val1 = test_case.values.matrix{1,dim1};
        val2 = test_case.values.matrix{2,dim2};
        vars = val2.indeterminates;
        test_value_deg0 = 1+subs(val2,vars,ones(length(vars),1));
        
        if (~isrow(val1) && ~isrow(val2) && size(val1,1) ~= size(val2,1)) ...
                || (~iscolumn(val1) && ~iscolumn(val2) && size(val1,2) ~= size(val2,2))
            % dimension mismatch
            diagtext = sprintf('Dimension mismatch expected: %s vs. %s.',mat2str(size(val1)),mat2str(size(val2)));
            test_case.verifyError(@() rdivide(val1,val2),?MException,diagtext);
            return
        end

        % else
        actual = rdivide(val1,test_value_deg0);
        reference = test_case.references.matrix.rdivide{dim1,dim2};

        % perform assertion
        test_case.verifyEqualPolynomial(actual,reference,"RelTol",1e-15);
    end
end

end
