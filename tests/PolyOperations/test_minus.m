classdef test_minus < matlab.unittest.TestCase

    properties (TestParameter)
        testValue  % test polynmials
        refValue   % reference values
    end
    

    methods (TestParameterDefinition,Static)

        function [testValue, refValue] = initializeTestData()

            load("generateRefValues/refSolutions/refSolution_multipoly_minus.mat")
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
            refValue = {refSolution};

        end

    end

    methods (Test)
        %% ------------------------------------------------------------
        %
        %  Input permutation of nominal tests
        %  0 : constant
        %  1 : single polynomial
        %  n : n polynomials
        %
        %         A     B     C     D     E     F     G     H   I
        %
        %   a:    0     1     n     0     1     n     0     1   n
        %   b:    0     0     0     1     1     1     n     n   n
        %
        % -------------------------------------------------------------
        %% case A
        function testMinus_case_A(testCase,testValue,refValue)

            actSolution = full(casadi.DM(poly2basis(minus(casos.PS(5), casos.PS(5)))));
            refSolution = refValue.case_A{1};

            % Perform assertions if needed
            testCase.verifyEqual(actSolution, refSolution ,"AbsTol",1e-12);

        end

        %% case B
        function testMinus_case_B(testCase,testValue,refValue)

            actSolution = full(casadi.DM(poly2basis(minus(testValue(1), casos.PS(3)))));
            refSolution = refValue.case_B{1};

            % Perform assertions if needed
            testCase.verifyEqual(actSolution, refSolution ,"AbsTol",1e-12);

        end

        %% case C
        function testMinus_case_C(testCase,testValue,refValue)

            actSolution = [];
            refSolution = [];
            for k = 1:10
                actSolution = [actSolution; full(casadi.DM(poly2basis(minus(testValue(k), 4))))];
                refSolution = [refSolution; refValue.case_C{k}];
            end

            % Perform assertions if needed
            testCase.verifyEqual(actSolution, refSolution ,"AbsTol",1e-12);

        end

        %% case D
        function testMinus_case_D(testCase,testValue,refValue)

            actSolution = full(casadi.DM(poly2basis(minus(4, testValue(1)))));
            refSolution = refValue.case_D{1};

            % Perform assertions if needed
            testCase.verifyEqual(actSolution, refSolution ,"AbsTol",1e-12);

        end

        %% case E
        function testMinus_case_E(testCase,testValue,refValue)

            actSolution = full(casadi.DM(poly2basis(minus(testValue(1), testValue(2)))));
            refSolution = refValue.case_E{1};

            % Perform assertions if needed
            testCase.verifyEqual(actSolution, refSolution ,"AbsTol",1e-12);

        end

        %% case F
        function testMinus_case_F(testCase,testValue,refValue)

            actSolution = [];
            refSolution = [];
            for k = 1:10
                actSolution = [actSolution; full(casadi.DM(poly2basis(minus(testValue(k), testValue(1)))))];
                refSolution = [refSolution; refValue.case_F{k}];
            end

            % Perform assertions if needed
            testCase.verifyEqual(actSolution, refSolution ,"AbsTol",1e-12);

        end

        %% case G
        function testMinus_case_G(testCase,testValue,refValue)

            actSolution = [];
            refSolution = [];
            for k = 1:10
                actSolution = [actSolution; full(casadi.DM(poly2basis(minus(5, testValue(k)))))];
                refSolution = [refSolution; refValue.case_G{k}];
            end

            % Perform assertions if needed
            testCase.verifyEqual(actSolution, refSolution ,"AbsTol",1e-12);

        end

        %% case H
        function testMinus_case_H(testCase,testValue,refValue)

            actSolution = [];
            refSolution = [];
            for k = 1:10
                actSolution = [actSolution; full(casadi.DM(poly2basis(minus(testValue(1), testValue(k)))))];
                refSolution = [refSolution; refValue.case_H{k}];
            end

            % Perform assertions if needed
            testCase.verifyEqual(actSolution, refSolution ,"AbsTol",1e-12);

        end

        %% case I
        function testMinus_case_I(testCase,testValue,refValue)

            actSolution = [];
            refSolution = [];
            for k = 1:10
                actSolution = [actSolution; full(casadi.DM(poly2basis(minus(testValue(k), testValue(k+10)))))];
                refSolution = [refSolution; refValue.case_I{k}];
            end

            % Perform assertions if needed
            testCase.verifyEqual(actSolution, refSolution ,"AbsTol",1e-12);

        end

    end  
end
