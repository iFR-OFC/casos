% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function b = sparsify(a)
% Sparsify polynomial expressions.

b = a.new_poly;

% sparsify coefficients
coeffs = simplify(a.coeffs);

% remove zero terms
[S,b.coeffs] = coeff_update(a.get_sparsity,coeffs);

% set sparsity
b = set_sparsity(b,S);

end
