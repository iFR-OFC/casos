classdef TestSossolMosek < TestSolver
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

properties (Access=protected, Constant)
    packages = {'mosekopt'};
end

methods (TestParameterDefinition, Static)
    function [sdp, opts] = initializeTestData()
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
    function solve_sdp(test_case,sdp,opts)
        % initialize solver
        S = casos.sossol('S','mosek',sdp,opts);
        
        % solve with equality constraints
        sol = S();

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
