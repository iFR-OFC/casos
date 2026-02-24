% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function c = intersect(a,b)
% Intersect two polynomial sparsity patterns.

a = casos.Sparsity(a);
b = casos.Sparsity(b);

% sparsity patterns must be of same size
if ~check_sz_equal(a,b)
    throw(casos.package.core.IncompatibleSizesError.other(a,b));
end

% intersect coefficient matrices
c = op_intersect(a,b);

end
