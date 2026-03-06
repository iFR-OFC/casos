% SPDX-FileCopyrightText: 2025 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Jan Olucak <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef FilterLinesearch < casos.package.solvers.SequentialCommon
    % A simple sequential sum-of-squares algorithm.

    properties (SetAccess=private)
        class_name = 'FilterLinesearch';
    end

    properties(Access=protected)
        feas_res_solver;
    end

    methods (Access=protected)
        % prepare problem structures
        buildproblem(obj,nlsos);

        % iteration for overloading
        varargout = do_single_iteration(varargin);

        % internal evaluation
        argout = eval_on_basis(obj,argin);
    end

    methods
        function s = get_info(obj)
            % Return info.
            s = get_info@casos.package.solvers.SequentialCommon(obj);
            s.nlsossol_feasibility = obj.feas_res_solver.get_info;
        end
    end
end
