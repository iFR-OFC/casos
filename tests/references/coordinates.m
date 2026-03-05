% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function val = coordinates(p,varargin)
% Emulate behaviour of CaΣoS poly2basis method.

vals = arrayfun(@(i) poly2basis(p(i),varargin{:}), 1:prod(size(p)), "UniformOutput", false); %#ok<PSIZE> not implemented by multipoly

val = vertcat(vals{:});

end
