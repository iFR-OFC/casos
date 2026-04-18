% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef TestConcat < TestPolynomialOperations
% Test concatenation operations.

properties (TestParameter)
    test_values  % test polynmials
    references   % reference solutions

    nrow = {1 2 3 4 5};   % numbers of rows to concat
    dim1 = {1 2 3 4 5 6};
    dim2 = {1 2 3 4 5 6};
    arg = {1 2};   % index argument
end

methods (TestParameterDefinition, Static)
    function [test_values,references] = initializeTestData()
        % Initialize test data for unary operations.
        [test_values,references] = TestConcat.loadTestData("concat");
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="scalar")
    function test_concat(test_case, test_values, references, nrow, arg)
        % Test concatenation to m-by-n matrix.
        ncol = 6-nrow;

        args_to_vertcat = mat2cell(test_values.scalar(arg,1:(nrow*ncol)), 1, repmat(nrow,1,ncol));
        args_to_horzcat = cellfun(@(c) vertcat(c{:}), args_to_vertcat, 'UniformOutput', false);

        actual = horzcat(args_to_horzcat{:});
        reference = references.scalar.concat{arg,nrow};

        test_case.verifyEqualPolynomial(actual, reference);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["vector" "column"])
    % function test_diagcat_column(test_case, test_values, references, dim1, dim2)
    %     % Test diagonal concatenation of column vectors.
    %     val1 = test_values.vector{1,dim1};
    %     val2 = test_values.vector{2,dim2};
    % 
    %     actual1 = diagcat(val1,val2);
    %     actual2 = cat(0,val1,val2);
    %     reference = references.column.diagcat{dim1,dim2};
    % 
    %     test_case.verifyEqualPolynomial(actual1, reference);
    %     test_case.verifyEqualPolynomial(actual2, reference);
    % end

    function test_horzcat_column(test_case, test_values, references, dim1, dim2)
        % Test horizontal concatenation of column vectors.
        val1 = test_values.vector{1,dim1};
        val2 = test_values.vector{2,dim2};

        if ~isempty(val1) && ~isempty(val2) && size(val1,1) ~= size(val2,1)
            % first dimension mismatch
            test_case.verifyError(@() horzcat(val1,val2),?MException);
            test_case.verifyError(@() cat(2,val1,val2),?MException);
            return
        end

        % else
        actual1 = horzcat(val1,val2);
        actual2 = cat(2,val1,val2);
        reference = references.column.horzcat{dim1,dim2};

        test_case.verifyEqualPolynomial(actual1, reference);
        test_case.verifyEqualPolynomial(actual2, reference);
    end

    function test_vertcat_column(test_case, test_values, references, dim1, dim2)
        % Test vertical concatenation of column vectors.
        val1 = test_values.vector{1,dim1};
        val2 = test_values.vector{2,dim2};

        if ~isempty(val1) && ~isempty(val2) && size(val1,2) ~= size(val2,2)
            % second dimension mismatch
            test_case.verifyError(@() vertcat(val1,val2),?MException);
            test_case.verifyError(@() cat(1,val1,val2),?MException);
            return
        end

        % else
        actual1 = vertcat(val1,val2);
        actual2 = cat(1,val1,val2);
        reference = references.column.vertcat{dim1,dim2};

        test_case.verifyEqualPolynomial(actual1, reference);
        test_case.verifyEqualPolynomial(actual2, reference);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags=["vector" "row"])
    % function test_diagcat_row(test_case, test_values, references, dim1, dim2)
    %     % Test diagonal concatenation of row vectors.
    %     val1 = test_values.vector{1,dim1}';
    %     val2 = test_values.vector{2,dim2}';
    % 
    %     actual1 = diagcat(val1,val2);
    %     actual2 = cat(0,val1,val2);
    %     reference = references.row.diagcat{dim1,dim2};
    % 
    %     test_case.verifyEqualPolynomial(actual1, reference);
    %     test_case.verifyEqualPolynomial(actual2, reference);
    % end

    function test_horzcat_row(test_case, test_values, references, dim1, dim2)
        % Test horizontal concatenation of row vectors.
        val1 = test_values.vector{1,dim1}';
        val2 = test_values.vector{2,dim2}';

        if ~isempty(val1) && ~isempty(val2) && size(val1,1) ~= size(val2,1)
            % first dimension mismatch
            test_case.verifyError(@() horzcat(val1,val2),?MException);
            test_case.verifyError(@() cat(2,val1,val2),?MException);
            return
        end

        % else
        actual1 = horzcat(val1,val2);
        actual2 = cat(2,val1,val2);
        reference = references.row.horzcat{dim1,dim2};

        test_case.verifyEqualPolynomial(actual1, reference);
        test_case.verifyEqualPolynomial(actual2, reference);
    end

    function test_vertcat_row(test_case, test_values, references, dim1, dim2)
        % Test vertical concatenation of row vectors.
        val1 = test_values.vector{1,dim1}';
        val2 = test_values.vector{2,dim2}';

        if ~isempty(val1) && ~isempty(val2) && size(val1,2) ~= size(val2,2)
            % second dimension mismatch
            test_case.verifyError(@() vertcat(val1,val2),?MException);
            test_case.verifyError(@() cat(1,val1,val2),?MException);
            return
        end

        % else
        actual1 = vertcat(val1,val2);
        actual2 = cat(1,val1,val2);
        reference = references.row.vertcat{dim1,dim2};

        test_case.verifyEqualPolynomial(actual1, reference);
        test_case.verifyEqualPolynomial(actual2, reference);
    end
end

methods (Test, ParameterCombination="pairwise", TestTags="matrix")
    % function test_diagcat_matrix(test_case, test_values, references, dim1, dim2)
    %     % Test diagonal concatenation of matrices.
    %     val1 = test_values.matrix{1,dim1};
    %     val2 = test_values.matrix{2,dim2};
    % 
    %     actual1 = diagcat(val1,val2);
    %     actual2 = cat(0,val1,val2);
    %     reference = references.matrix.diagcat{dim1,dim2};
    % 
    %     test_case.verifyEqualPolynomial(actual1, reference);
    %     test_case.verifyEqualPolynomial(actual2, reference);
    % end

    function test_horzcat_matrix(test_case, test_values, references, dim1, dim2)
        % Test horizontal concatenation of matrices.
        val1 = test_values.matrix{1,dim1};
        val2 = test_values.matrix{2,dim2};

        if ~isempty(val1) && ~isempty(val2) && size(val1,1) ~= size(val2,1)
            % first dimension mismatch
            test_case.verifyError(@() horzcat(val1,val2),?MException);
            test_case.verifyError(@() cat(2,val1,val2),?MException);
            return
        end

        % else
        actual1 = horzcat(val1,val2);
        actual2 = cat(2,val1,val2);
        reference = references.matrix.horzcat{dim1,dim2};

        test_case.verifyEqualPolynomial(actual1, reference);
        test_case.verifyEqualPolynomial(actual2, reference);
    end

    function test_vertcat_matrix(test_case, test_values, references, dim1, dim2)
        % Test vertical concatenation of matrices.
        val1 = test_values.matrix{1,dim1};
        val2 = test_values.matrix{2,dim2};

        if ~isempty(val1) && ~isempty(val2) && size(val1,2) ~= size(val2,2)
            % second dimension mismatch
            test_case.verifyError(@() vertcat(val1,val2),?MException);
            test_case.verifyError(@() cat(1,val1,val2),?MException);
            return
        end

        % else
        actual1 = vertcat(val1,val2);
        actual2 = cat(1,val1,val2);
        reference = references.matrix.vertcat{dim1,dim2};

        test_case.verifyEqualPolynomial(actual1, reference);
        test_case.verifyEqualPolynomial(actual2, reference);
    end
end

end
