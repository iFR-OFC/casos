classdef (Abstract) TestSymbolicOperations < matlab.unittest.TestCase
% Base class for tests of symbolic (polynomial) operations.

methods (Static)
    function [test_values] = loadTestData()
        load("../references/test_values.mat","test_values_struct")

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
    end
end

end
