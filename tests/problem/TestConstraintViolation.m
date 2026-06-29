% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Fabian Geyer <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef TestConstraintViolation < matlab.unittest.TestCase
% All tests require mosek because get_constr_violation hardcodes it.

methods (TestMethodSetup)
    function require_mosek(tc)
        tc.assumeTrue(exist('mosekopt','file') >= 2, ...
            'Required package is missing: mosek.');
    end
end

methods (Test)

    function quadratic_parametric_univar_feasible(tc)
        % Indeterminates
        x = casos.Indeterminates('x');
        
        % Polynomial
        a = casos.PS.sym('a', monomials(x, 2));

        % parameter
        p = casos.PS.sym('p');

        % problem
        nlsos = struct('x', a, 'g', a+p, 'p', p);
        prob = casos.package.problem.NonconvexProblem(nlsos);

        % get constraint violation value
        theta = prob.get_constr_violation(2*x^2, 2);

        % Value should be fully zero
        tc.verifyEqual(theta, 0, 'AbsTol', 1e-4)
    end

    function quadratic_parametric_univar_infeasible(tc)
        % Indeterminates
        x = casos.Indeterminates('x');
        
        % Polynomial
        a = casos.PS.sym('a', monomials(x, 2));

        % parameter
        p = casos.PS.sym('p');

        % problem
        nlsos = struct('x', a, 'g', a+p, 'p', p);
        prob = casos.package.problem.NonconvexProblem(nlsos);

        % get constraint violation value
        theta = prob.get_constr_violation(-2*x^2, -2);

        % Value should be fully positive
        tc.verifyGreaterThan(theta, 0)
    end

    function multi_constraint_all_feasible(tc)
        % c1=1, c2=2  →  both SOS, theta=0
        x = casos.Indeterminates('x', 2);
        
        % Quadratic polynomial of degree 2
        c = casos.PS.sym('c', monomials(x, 2), [2,1]);
        
        % Leaving out paramter functionality here
        nlsos = struct('x', c, 'f', 0, 'g', c);
        prob  = casos.package.problem.NonconvexProblem()

        x_val = [1;2] .* casos.PD(nlsos.x.basis);
        theta = prob.get_constr_violation(x_val, casos.PD(0));
        tc.verifyEqual(theta, 0, 'AbsTol', 1e-6);
    end
end
end
