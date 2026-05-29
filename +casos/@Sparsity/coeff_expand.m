% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function [cf1,cf2] = coeff_expand(S1,S2,cfa,cfb)
% Expand polynomial coefficient matrices to degrees.

% expand coefficients
[cf1,cf2] = expand_internal(S1,S2,cfa,cfb,(nargout < 2));

end
