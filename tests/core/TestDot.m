classdef TestDot < matlab.unittest.TestCase

properties (TestParameter)
    test_values  % test polynmials
    references   % reference values
end

methods (TestParameterDefinition,Static)
    function [test_values,references] = initializeTestData()
        load("../references/reference_dot.mat","test_values_struct","reference_solutions")

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

methods (Test)
    function test_dot_single(test_case,test_values,references)
        actSolution  = full(dot(test_values{1},test_values{1}));
        refSolution = references.single{1};

        % Perform assertions if needed
        test_case.verifyEqual(actSolution, refSolution ,"AbsTol",1e-12);
    end

    function test_dot_multiple(test_case,test_values,references)
        for k = 1:length(test_values)/2
            actSolution = full(dot(test_values{1,1},test_values{1,k}));
            refSolution = references.multiple{k};
            % Perform assertions if needed
            test_case.verifyEqual(actSolution, refSolution  ,"AbsTol",1e-12);
        end
    end
end

end
