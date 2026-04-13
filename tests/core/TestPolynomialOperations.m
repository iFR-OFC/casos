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
    function verifyEqualPolynomial(test_case,actual,reference,Name,Value)
        % Verify that actual polynomial is equal to reference structure.
        test_case.assertClass(reference,?struct,'Reference must be a structure.')

        if nargin < 4
            options = {};
        elseif strcmp(Name,"RelTol")
            tolerance = matlab.unittest.constraints.RelativeTolerance(Value);
            options = {"Within" tolerance};
        elseif strcmp(Name,"AbsTol")
            tolerance = matlab.unittest.constraints.AbsoluteTolerance(Value);
            options = {"Within" tolerance};
        else
            error('Unknown option "%s".', Name)
        end

        test_case.verifyThat(actual,IsEqualPolynomialTo(reference,options{:}));
    end
end

end
