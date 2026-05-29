% SPDX-FileCopyrightText: 2023 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function f = conic(varargin)
% Low-level interface for conic (SDP) solvers.

try
    sol = casos.package.solvers.conicInternal(varargin{:});
    
    f = casos.Function(sol);

catch e
    throwAsCaller(e)
end

end
