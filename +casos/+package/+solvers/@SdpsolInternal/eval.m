% SPDX-FileCopyrightText: 2023 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function argout = eval(obj,argin)
% Call SDP interface.

data = call(obj.fhan,argin);

% to double
% data = cellfun(@sparse, data, 'UniformOutput',false);

% call conic solver
sol = call(obj.solver,data);

% parse solution
argout = call(obj.ghan,[argin(2) sol]);

end
