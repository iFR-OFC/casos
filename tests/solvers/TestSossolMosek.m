classdef TestSossolMosek < matlab.unittest.TestCase
% ========================================================================
%
% Test Name: test_sossol_mosek.m
%
% Test Description: 
%   > Solve simple sos program
%               
% Test Procedure: 
%
%   min       f         |   f   =          
%   s.t.    x in K_x    |   K_x = 
%          Ax in K_c    |   K_c = 
%                               
% Date: 09/06/2024 
%
% ========================================================================

properties (TestParameter)
    sdp  
    opts 
end

properties (Access=private, Constant)
    packages = {'mosek'};
    PackagesAvailable   = checkRequiredPackages(1, TestSossolMosek.packages);
    MissingPackages     = checkRequiredPackages(2, TestSossolMosek.packages);
end
    
methods (TestClassSetup)
    function setupClass(testCase)
        if ~TestSossolMosek.PackagesAvailable
            default = 'The following required packages are missing: %s.';
            message = sprintf(default, strjoin(TestSossolMosek.MissingPackages, ', '));
            testCase.assumeTrue(TestSossolMosek.PackagesAvailable, message);
        end
    end
end

methods (TestParameterDefinition, Static)
    function [sdp, opts] = initializeTestData()
        % only run initialization if all required packages are available
        if ~TestSossolMosek.PackagesAvailable
            sdp  = {[]};
            opts = {[]};
            return;
        end

        % set seed
        rng(0)
        
        % indeterminate variable
        x = casos.Indeterminates('x');

        % some polynomial
        f = x^4 + 10*x;

        % scalar decision variable
        g = casos.PS.sym('g');

        % define f,g,x
        sdp = {struct('x',g,'f',g,'g',f+g)};

        % define cones
        opts = {struct('Kc',struct('sos',1))};
    end
end

methods (Test)
    function solve_sdp(testCase,sdp,opts)
        % initialize solver
        S = casos.sossol('S','mosek',sdp,opts);
        
        % solve with equality constraints
        sol = S();

        if S.stats.UNIFIED_RETURN_STATUS ~= "SOLVER_RET_SUCCESS"
            refSolution = 1;
            actSolution = inf;
            testCase.verifyEqual(actSolution, refSolution ,"AbsTol",1e-12);
        end
           
        actSolution = 1;
        refSolution = 1;

        % Perform assertions if needed
        testCase.verifyEqual(actSolution, refSolution ,"AbsTol",1e-12);
    end
end

end