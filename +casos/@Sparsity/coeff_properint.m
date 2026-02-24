% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function r = coeff_properint(S,coeffs)
% Compute integral over [0 1] as double.

% integral of monomials
mprod = 1./prod(S.degmat+1,2);

% multiply with coefficients + reshape
r = full(reshape(mprod'*coeffs, size(S)));

end
