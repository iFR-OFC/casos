classdef test_sum < matlab.unittest.TestCase

    properties (TestParameter)
        testValue  % test polynmials
        refValue   % reference values
    end
    

    methods (TestParameterDefinition,Static)

        function [testValue,refValue] = initializeTestData()

            load("generateRefValues/refSolutions/refSolution_multipoly_sum.mat")
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

        function test_sum_single(testCase,testValue,refValue)

            actSolution = full(casadi.DM(poly2basis(sum(testValue(1), 2))));
            refSolution = refValue.single{1};

            % Perform assertions if needed
            testCase.verifyEqual(actSolution, refSolution ,"AbsTol",1e-12);

        end

        function test_sum_multiple(testCase,testValue,refValue)

            actSolution = [];
            refSolution = [];
            for k = 1:10
                actSolution = [actSolution; full(casadi.DM(poly2basis(sum(testValue(k), 1))))];
                refSolution = [refSolution; refValue.multiple{k}];
            end

            % Perform assertions if needed
            testCase.verifyEqual(actSolution, refSolution ,"AbsTol",1e-12);

        end

    end
   
end
