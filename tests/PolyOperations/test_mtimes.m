classdef test_mtimes < matlab.unittest.TestCase

    properties (TestParameter)
        testValue  % test polynmials
        refValue   % reference values
    end
    

    methods (TestParameterDefinition,Static)

        function [testValue,refValue] = initializeTestData()

            load("generateRefValues/refSolutions/refSolution_multipoly_mtimes.mat")
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

        function test_mtimes_single(testCase,testValue,refValue)

            actSolution = full(poly2basis(mtimes(testValue(1), testValue(2))));
            refSolution = refValue.single{1};

            % Perform assertions if needed
            testCase.verifyEqual(actSolution, refSolution ,"AbsTol",1e-12);

        end

        function test_mtimes_multiple(testCase,testValue,refValue)

            actSolution = [];
            refSolution = [];
            noPoly = length(testValue)/2;
            testValue = reshape(testValue,2,noPoly);
            for k = 1:noPoly
                actSolution = [actSolution; full(poly2basis(mtimes(testValue(1,k), testValue(2,k))))];
                refSolution = [refSolution; refValue.multiple{k}];
            end

            % Perform assertions if needed
            testCase.verifyEqual(actSolution, refSolution ,"AbsTol",1e-12);
        end

    end
   
end
