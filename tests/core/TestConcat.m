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

    dim = {1 2 3 4 5};   % dimension
    dim1 = {1 2 3 4};    % first dimension
    dim3 = {1 2 3 4};    % tertiary dimension
    arg = {1 2};   % index argument
end

methods (TestParameterDefinition, Static)
    function [test_values,references] = initializeTestData()
        % Initialize test data for unary operations.
        [test_values,references] = TestUnary.loadTestData("concat");
    end
end

methods (Test, ParameterCombination="pairwise")
    function test_concat(test_case, test_values, references, dim, arg)
        % Test concatenation to m-by-n matrix.
        dim2 = 6-dim;

        args_to_vertcat = mat2cell(test_values(arg,1:(dim*dim2)), 1, repmat(dim,1,dim2));
        args_to_horzcat = cellfun(@(c) vertcat(c{:}), args_to_vertcat, 'UniformOutput', false);

        actual = full(poly2basis(horzcat(args_to_horzcat{:})));
        reference = references.concat{arg,dim};

        test_case.verifyEqual(actual, reference);
    end

    function test_horzcat(test_case, test_values, references, dim1)
        % Test horizontal concatenation.
        dim2 = 5-dim1;
        dim3 = 6-dim1; %#ok<PROPLC>

        p1 = reshape([test_values{1,1:(dim1*dim2)}],dim1,dim2);
        p2 = reshape([test_values{2,1:(dim1*dim3)}],dim1,dim3); %#ok<PROPLC>

        actual = full(poly2basis(horzcat(p1,p2)));
        reference = references.horzcat{dim1};

        test_case.verifyEqual(actual, reference);
    end

    function test_vertcat(test_case, test_values, references, dim3)
        % Test vertical concatenation.
        dim1 = 5-dim3; %#ok<PROPLC>
        dim2 = 6-dim3;

        p1 = reshape([test_values{1,1:(dim1*dim3)}],dim1,dim3); %#ok<PROPLC>
        p2 = reshape([test_values{2,1:(dim2*dim3)}],dim2,dim3);

        actual = full(poly2basis(vertcat(p1,p2)));
        reference = references.vertcat{dim3};

        test_case.verifyEqual(actual, reference);
    end

    % function test_diagcat(test_case, test_values, references, dim1, dim3)
    %     % Test diagonal concatenation.
    %     dim2 = 5-dim1;
    %     dim4 = 6-dim3;
    % 
    %     p1 = reshape([test_values{1,1:(dim1*dim2)}],dim1,dim2);
    %     p2 = reshape([test_values{2,1:(dim3*dim4)}],dim3,dim4);
    % 
    %     actual = full(poly2basis(diagcat(p1,p2)));
    %     reference = references.diagcat{dim1,dim3};
    % 
    %     test_case.verifyEqual(actual, reference);
    % end
end

end
