% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function [out,ia,ic] = sort(obj)
% Sort indeterminate variables alphabetically.

[vars,ia,ic] = unique(obj.variables);   % variables are already unique

% return
out = casos.Indeterminates;
out.variables = vars;
out.transp = obj.transp;

end
