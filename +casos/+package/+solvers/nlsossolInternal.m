% SPDX-FileCopyrightText: 2025 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Jan Olucak <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function node = nlsossolInternal(name,solver,varargin)
% Internal interface for noncovex sum-of-squares problems.

switch (solver)
    case 'sequential'
        node = casos.package.solvers.FilterLinesearch(name,varargin{:});
    otherwise
        error('No such nonlinear solver "%s".',solver)
end

end
