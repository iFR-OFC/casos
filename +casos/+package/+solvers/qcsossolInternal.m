% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function node = qcsossolInternal(name,solver,varargin)
% Internal interface for quasiconvex sum-of-squares problems.

switch (solver)
    case 'bisection'
        node = casos.package.solvers.QuasiconvBisection(name,varargin{:});

    otherwise
        error('No such quasiconvex solver "%s".',solver)
end

end
