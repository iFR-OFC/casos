classdef test_mpower < matlab.unittest.TestCase

    properties (TestParameter)
        testValue  % test polynmials
        refValue   % reference values
    end
    

    methods (TestParameterDefinition,Static)

        function [testValue,refValue] = initializeTestData()

            load("generateRefValues/refSolutions/refSolution_multipoly_mpower.mat")
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
        %% ------------------------------------------------------------
        %
        %  Test cases for different powers
        %  case_A: power = 2
        %  case_B: power = 3
        %  case_C: power = 4
        %
        % -------------------------------------------------------------

        %% case A: power = 2
        function test_mpower_case_A(testCase,testValue,refValue)

            actSolution = [];
            refSolution = [];
            noPoly = length(testValue)/2;
            for k = 1:noPoly
                actSolution = [actSolution; full(poly2basis(mpower(testValue(k),2)))];
                refSolution = [refSolution; refValue.case_A{k}];
            end

            % Perform assertions if needed
            testCase.verifyEqual(actSolution, refSolution ,"AbsTol",1e-12);

        end

        %% case B: power = 3
        % function test_mpower_case_B(testCase,testValue,refValue)
        % 
        %     actSolution = [];
        %     refSolution = [];
        %     noPoly = length(testValue)/2;
        %     for k = 1:noPoly
        %         actSolution = [actSolution; full(poly2basis(mpower(testValue(k),3)))];
        %         refSolution = [refSolution; refValue.case_B{k}];
        %     end
        % 
        %     % Perform assertions if needed
        %     testCase.verifyEqual(actSolution, refSolution ,"AbsTol",1e-12);
        % 
        % end

        %% case C: power = 4
        % function test_mpower_case_C(testCase,testValue,refValue)
        % 
        %     actSolution = [];
        %     refSolution = [];
        %     noPoly = length(testValue)/2;
        %     for k = 1:noPoly
        %         actSolution = [actSolution; full(poly2basis(mpower(testValue(k),4)))];
        %         refSolution = [refSolution; refValue.case_C{k}];
        %     end
        % 
        %     % Perform assertions if needed
        %     testCase.verifyEqual(actSolution, refSolution ,"AbsTol",1e-12);
        % 
        % end

    end
   
end
