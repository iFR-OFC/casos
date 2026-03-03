classdef TestSdpsolMosek2 < TestSolver
% ========================================================================
%
% Test Name: test_sdpsol_mosek_2.m
%
% Test Description: 
%   > Solve simple second order cone programm with mosek
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

        % basic data
        t = (0:0.02:2*pi)';
        x = (1:6)';
        A = sin(t * x');
        y = A*x; %+randn(length(A),1);
        %A(100:210,:)=.1;
        
        x = casadi.SX.sym('x', 6, 1);
        u = casadi.SX.sym('u', 1, 1);
        v = casadi.SX.sym('v', 1, 1);
        
        % define f,g,x
        sdp = {struct('f', u+v,'g',[u; y-A*x; v; x],'x', [x; u; v])};

        % define cones
        opts = {struct('Kx',struct('lin',8),...
                       'Kc',struct('lor',[length(y)+1; length(x)+1]))};
    end
end

methods (Test)
    function solve_sdp(test_case,sdp,opts)
        % initialize solver
        S = casos.sdpsol('S','mosek',sdp,opts);
        
        % solve with equality constraints
        sol = S('lbx',-inf,'ubx',inf);

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
