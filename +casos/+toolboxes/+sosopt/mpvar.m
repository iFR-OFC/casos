% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function p = mpvar(str,varargin)
% Create a vector or matrix of indeterminate variables.

if nargin > 1 && ischar(varargin{end})
    warning('Options are not supported.')
    varargin(end) = [];
end

% new polynomial
p = casos.PS(str,varargin{:});

end
