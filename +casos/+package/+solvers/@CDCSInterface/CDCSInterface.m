% SPDX-FileCopyrightText: 2023 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Renato Loureiro <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef (Sealed) CDCSInterface < casos.package.solvers.ConicSolver
% Interface for conic solver CDCS.

properties (Access=protected)
    fhan;
    ghan;
    cone;

    solver_info  = struct;
    solver_stats = struct;
end

properties (Constant, Access=protected)
    cdcs_options = [casos.package.solvers.ConicSolver.conic_options
        {'cdcs', 'Options to be passed to CDCS.'}
    ];
end

methods (Static)
    function options = get_options
        % Return static options.
        options = casos.package.solvers.CDCSInterface.cdcs_options;
    end
end

methods
%     init(obj);
    argout = eval(obj,argin);

    function obj = CDCSInterface(name,conic,varargin)
            
        % Check for unsupported rotated Lorenz cones
        Kx = varargin{1}.Kx;
        Kc = varargin{1}.Kc;
        assert(~isfield(Kx, 'rot') || isempty(Kx.rot) || Kx.rot == 0, ...
            'CDCS:UnsupportedCone', 'CDCS does not support rotated Lorenz cone in primal cone');
    
        assert(~isfield(Kc, 'rot') || isempty(Kc.rot) || Kc.rot == 0, ...
            'CDCS:UnsupportedCone', 'CDCS does not support rotated Lorenz cone in dual cone');

        % Construct CDCS interface.
        obj@casos.package.solvers.ConicSolver(name,conic,varargin{:});

        % default options
        if ~isfield(obj.opts,'cdcs'), obj.opts.cdcs = []; end
    end
    
    function s = stats(obj)
        % Return stats.
        s = obj.solver_stats;
        s = addfield(obj.status,s);
    end

    function s = info(obj)
        % Overwriting ConicSolver.info
        s = info@casos.package.solvers.ConicSolver(obj);
        s.cdcs = obj.solver_info;
    end
end

methods (Access=protected)
    buildproblem(obj);
end

end
