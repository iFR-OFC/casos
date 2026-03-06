% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function c = kron(a,b)
% Compute Kronecker product of two polynomial sparsity patterns.

a = casos.Sparsity(a);
b = casos.Sparsity(b);

% handle simple case(s) for speed up
if isempty(a) || isempty(b)
    % product with empty polynomial is empty

    c = casos.Sparsity(size(a).*size(b));
    return
end

% else
% Kronecker product of coefficients
c = coeff_kron(a,b,a.coeffs,b.coeffs);

end
