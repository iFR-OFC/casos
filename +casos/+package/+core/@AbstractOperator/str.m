% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function s = str(obj)
% Return string representation.

sp_in = to_char(obj.sparsity_in);
sp_out = to_char(obj.sparsity_out);

s = compose('Operator: [%s] -> [%s]',sp_in,sp_out);

end
