% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function res = eval_repmat(arg,m,n)
% Evaluate repmat operation.

if (m == 0 || n == 0)
    % return empty polynomial
    res = polynomial(zeros(size(arg).*[m n]));

else
    % invoke multipoly repmat
    res = repmat(arg,m,n);
end

end
