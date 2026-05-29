% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function res = eval_project(arg1,arg2)
% Evaluate project on first argument with basis of second argument.

assert(isequal(size(arg1),size(arg2)), 'Size mismatch.')

if isempty(arg1)
    % handle empty polynomial
    res = polynomial(zeros(size(arg1)));
    return
end

% else
N = prod(size(arg1)); %#ok<PSIZE>

% project onto scalar basis
project = @(p,z) z'*poly2basis(p,z);

% evaluate projection element-wise
results = arrayfun(@(i) project(arg1(i),monomials(arg2(i))), 1:N, "UniformOutput",false);

% reshape to argument size
res = reshape([results{:}],size(arg1));

end
