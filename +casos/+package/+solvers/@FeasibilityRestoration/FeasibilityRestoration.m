% SPDX-FileCopyrightText: 2025 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Jan Olucak <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef FeasibilityRestoration < casos.package.solvers.SequentialCommon
    % A simple sequential sum-of-squares algorithm.

    properties (SetAccess=private)
        class_name = 'FeasibilityRestoration';
    end

    properties(Access=protected)
        filter_feas;
    end

    methods (Access=protected)
        % iteration for overloading
        varargout = do_single_iteration(varargin);

        % internal evaluation
        argout = eval_on_basis(obj,argin);
    end

    methods (Access={?casos.package.solvers.SequentialCommon})
        % evaluation called by friend class
        varargout = eval_extended(varargin);
    end
end
