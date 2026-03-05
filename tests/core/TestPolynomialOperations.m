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

        test_value = cell(2,length(test_values_struct));

        for k = 1:length(test_values_struct)
            x_cas        = casos.PS('x',test_values_struct{k}.nIndet,1);

            x_monom1_cas = monomials(x_cas,test_values_struct{k}.deg);
            x_monom2_cas = monomials(x_cas,test_values_struct{k}.deg2);

            poly1_cas = casos.PD(x_monom1_cas,test_values_struct{k}.coeffs1);
            poly2_cas = casos.PD(x_monom2_cas,test_values_struct{k}.coeffs2);

            test_value(:,k) = {poly1_cas poly2_cas};
        end

        test_values = {test_value};
        references  = {reference_solutions};
    end
end

end
