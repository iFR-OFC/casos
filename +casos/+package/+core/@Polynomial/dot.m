% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function r = dot(p,q)
% Scalar dot product of two polynomials.

assert(numel(p) == numel(q),'Inputs must be of compatible size.')

% expand coefficient matrices to match
[cf1,cf2] = coeff_expand(p.get_sparsity,q.get_sparsity,p.coeffs,q.coeffs);

% return dot product of coefficients
r = dot(cf1,cf2);

end
