% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function tf = is_homogeneous(obj,deg)
% Check if polynomial sparsity pattern is homogeneous (of given degree).

degsum = obj.degsum;

if nargin < 2
    % check for homogeneity of any degree
    deg = degsum(1);
end

% a polynomial is homogeneous if all terms are of equal degree
tf = all(degsum == deg);

end
