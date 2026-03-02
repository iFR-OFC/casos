% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function p = polydecvar(dstr,w,varargin)
% Create a polynomial decision variable.

if nargin > 2
    warning('Type argument is not supported.')
end

% new symbolic polynomial
p = casos.PS.sym(dstr,w);

end
