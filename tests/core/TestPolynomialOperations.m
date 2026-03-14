% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Jan Olucak <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef (Abstract) TestPolynomialOperations < matlab.unittest.TestCase
% Base class for tests of polynomial operations.

methods (Static)
    function [test_values,references] = loadTestData(op)
        % Load test data for given polynomial operations.
        load(compose("../references/reference_%s.mat", op),"test_values_struct","reference_solutions")

        test_value = struct;
        
        for type = ["scalar" "vector" "matrix"]
            test_value.(type) = cell(size(test_values_struct.(type{:})));

            for k = 1:numel(test_values_struct.(type))
                arg = test_values_struct.(type){k};
    
                x = casos.Indeterminates(arg.indets{:});
                sp = casos.Sparsity.tuplet(arg.sz(1),arg.sz(2),arg.i,arg.j,x,arg.degrees);
    
                test_value.(type){k} = casos.PD(sp,arg.coeffs);
            end
        end

        test_values = {test_value};
        references  = {reference_solutions};
    end
end

methods
    function verifyEqualPolynomial(test_case,actual,reference,varargin)
        % Verify that actual polynomial is equal to reference structure.
        test_case.assertClass(reference,?struct,'Reference must be a structure.')

        test_case.verifySize(actual,reference.sz,'Size does not match.');

        % verify indeterminates
        reference_indets = casos.Indeterminates(reference.indets{:});
        test_case.verifyEqual(actual.indeterminates,reference_indets,'Indeterminate variables do not match.');

        % only compare nonzero terms
        actual_sparse = sparsify(actual);

        % verify nonzero coefficients
        test_case.verifyEqual(full(poly2basis(actual_sparse)),reference.coeffs,'Nonzero coefficients do not match.',varargin{:});

        % verify tuplet
        [i,j,degrees] = get_tuplet(sparsity(actual_sparse));

        test_case.verifyEqual(i,reference.i,'Rows do not match.');
        test_case.verifyEqual(j,reference.j,'Columns do not match.');
        test_case.verifyEqual(degrees,reference.degrees,'Degrees do not match.');
    end
end

end
