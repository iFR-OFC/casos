classdef TestSdpsolMosek < matlab.unittest.TestCase
% ========================================================================
%
% Test Name: test_sdpsol_mosek.m
%
% Test Description: 
%   > Solve simple SDP with only linear and psd cones with mosek
%               
% Test Procedure: 
%
%   min       f         |   f   = x(1)           
%   s.t.    x in K_x    |   K_x = single psd cone
%          Ax in K_c    |   K_c = single psd cone 
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
    PackagesAvailable   = checkRequiredPackages(1, TestSdpsolMosek.packages);
    MissingPackages     = checkRequiredPackages(2, TestSdpsolMosek.packages);
end
    
methods (TestClassSetup)
    function setupClass(test_case)
        if ~test_case.PackagesAvailable
            default = 'The following required packages are missing: %s.';
            message = sprintf(default, strjoin(test_case.MissingPackages, ', '));
            test_case.assumeTrue(test_case.PackagesAvailable, message);
        end
    end
end

methods (TestParameterDefinition, Static)
    function [sdp, opts] = initializeTestData()

        % only run initialization if all required packages are available
        if ~test_sdpsol_mosek.PackagesAvailable
            sdp  = {[]};
            opts = {[]};
            return;
        end

        % set seed
        rng(0)
        
        % basic data
        A = [-1 2 0;-3 -4 1;0 0 -2];
        x = casadi.SX.sym('x', 3, 3);
        
        % define f,g,x
        sdp = {struct('f',x(1,1),'g',[trace(x); vec(-A'*x-x*A)],'x',x(:))};

        % define cones
        opts = {struct('Kx',struct('psd',3),'Kc',struct('lin',1,'psd',3))};
    end
end

methods (Test)
    function solve_sdp(test_case,sdp,opts)
        % initialize solver
        S = casos.sdpsol('S','mosek',sdp,opts);
        
        % solve with equality constraints
        sol = S('lbg', 1, 'ubg',1);

        if S.stats.UNIFIED_RETURN_STATUS ~= "SOLVER_RET_SUCCESS"
            refSolution = 1;
            actSolution = inf;
            test_case.verifyEqual(actSolution, refSolution ,"AbsTol",1e-12);
        end
           
        actSolution = 1;
        refSolution = 1;

        % Perform assertions if needed
        test_case.verifyEqual(actSolution, refSolution ,"AbsTol",1e-12);
    end
end

end