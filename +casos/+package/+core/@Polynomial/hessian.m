% SPDX-FileCopyrightText: 2025 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function D = hessian(f,x)
% Compute symbolic Hessian matrix of vector polynomial expression.


if is_indet(x)
    % not allowed: compute polynomial Hessian matrix.
    error('Use NABLA for the polynomial Jacobian.')
end

assert(is_symbolic(x),'Second argument must be symbolic polynomial.')
assert(isscalar(f) && is_zerodegree(f),'Objective must be scalar variable.')

% project x to basis
[X,zi] = poly2basis(x);

% project f to basis
F = poly2basis(f);

% G is jacobian of coefficients
H = hessian(F,X);

% return operator
D = casos.package.operator(H,zi,zi);

end
