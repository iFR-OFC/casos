% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function z = build_monomials(degmat,indets)
% Build a monomial sparsity pattern.

z = casos.Sparsity;

% number of monomials
nt = size(degmat,1);

% set output
z.coeffs = casadi.Sparsity.dense(nt,1);
z.degmat = sparse(degmat);
z.indets = indets;
z.matdim = [1 1];

end
