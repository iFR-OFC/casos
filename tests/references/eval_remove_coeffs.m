% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function res = eval_remove_coeffs(arg1,arg2,p)
% Evaluate remove_coeffs on first argument.
% Tolerance is based on percentile of coefficients of second argument.

tol = prctile([0; coordinates(arg2)],p);
    
res = cleanpoly(arg1, tol);

end
