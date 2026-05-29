% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function g = nabla(f,x)
% Evaluate polynomial nabla operator (Jacobian matrix).

assert(is_indet(x), 'Second argument must be vector of indeterminates.')

g = f.new_poly;

% compute coefficient matrix of Jacobian
[S,g.coeffs] = coeff_nabla(f.get_sparsity,f.coeffs,x);

% set sparsity
g = set_sparsity(g,S);

end
