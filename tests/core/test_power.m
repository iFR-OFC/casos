classdef test_power < matlab.unittest.TestCase

    properties (TestParameter)
        testValue  % test polynmials
        refValue   % reference values
    end
    

    methods (TestParameterDefinition,Static)

        function [testValue,refValue] = initializeTestData()

            load("generateRefValues/refSolutions/refSolution_multipoly_power.mat")
            testValue = [];
            for k = 1:length(testValue_str)
                x_cas        = casos.PS('x',testValue_str(k).nIndet,1);

                x_monom1_cas = monomials(x_cas,testValue_str(k).deg);
                x_monom2_cas = monomials(x_cas,testValue_str(k).deg2);

                poly1_cas = casos.PD(x_monom1_cas,testValue_str(k).coeffs1);
                poly2_cas = casos.PD(x_monom2_cas,testValue_str(k).coeffs2);

                testValue = [testValue;[poly1_cas;poly2_cas]];
            end

            testValue = {testValue};
            refValue  = {refSolution};

        end

    end

    methods (Test)

        function test_power_single(testCase,testValue,refValue)

            actSolution = full(casadi.DM(poly2basis(power(testValue(1), 3))));
            refSolution = refValue.single{1};

            % Perform assertions if needed
            testCase.verifyEqual(actSolution, refSolution ,"AbsTol",1e-12);

        end

        % function test_power_multiple(testCase,testValue,refValue)
        % 
        %     actSolution = power(testValue(1:2),5);
        % 
        %     refSolution = power(refValue(1:2), 5);
        % 
        %     c_sopt =  [];
        %     c_cas  =  [];
        %     for k = 1:length(refSolution)
        %             c_sopt = [c_sopt;full(poly2basis(refSolution(k)))];
        %             c_cas  = [c_cas ;full(casadi.DM(poly2basis(actSolution(k))))];
        %     end
        % 
        % 
        %     % Perform assertions if needed
        %     testCase.verifyEqual(c_cas, c_sopt ,"AbsTol",1e-12);
        % end

    end
   
end
