% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Jan Olucak <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef (Abstract) TestPolynomialOperations < matlab.unittest.TestCase
% Base class for tests of polynomial operations.

properties (Abstract, SetAccess=protected)
    values       % test polynomials
    references   % reference solutions
end

methods (Access=protected)
    function loadTestData(test_case,op)
        % Load test data for given polynomial operations.
        if (nargin > 1)
            % load references for operation
            refs = compose("reference_%s",op);
        else
            % no references
            refs = {};
        end

        try
            % load test values and (optional) references
            S = load("../references/reference_values.mat","test_values_struct",refs{:});

        catch e
            test_case.fatalAssertFail("Error loading reference values: " + e.message);
        end

        % store test values as polynomials
        test_case.values = struct;
        
        for type = ["scalar" "vector" "matrix"]
            test_case.values.(type) = cell(size(S.test_values_struct.(type{:})));

            for k = 1:numel(S.test_values_struct.(type))
                arg = S.test_values_struct.(type){k};
    
                x = casos.Indeterminates(arg.indets{:});
                sp = casos.Sparsity.tuplet(arg.sz(1),arg.sz(2),arg.i,arg.j,x,arg.degrees);
    
                test_case.values.(type){k} = casos.PD(sp,arg.coeffs);
            end
        end

        % store references
        if ~isempty(refs)
            test_case.references  = S.(refs(1));
        end
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
