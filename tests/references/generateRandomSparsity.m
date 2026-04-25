% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function sp = generateRandomSparsity(sz,variables,degmax)
% Generate a random sparsity pattern.

select_variables = (randn(length(variables),1) > 0);

% select random variables
x = variables(select_variables);

% number of variables
n = length(x);

% create indices (0-index)
I = 0:sz(1)-1;
J = 0:sz(2)-1;

% create degree vector
D = cell(1,n);
D(:) = {0:degmax};

% permute indices and degrees
[I,J,D{:}] = ndgrid(I,J,D{:});

% select random indices and degrees
select_entries = (randn(numel(I),1) > 0);

i = squeeze(I(select_entries));
j = squeeze(J(select_entries));
degree_vectors = cellfun(@(d) squeeze(d(select_entries)), D, 'UniformOutput', false);

if isempty(degree_vectors)
    % empty degrees
    degrees = zeros(length(i),0);
else
    % concatenate
    degrees = [degree_vectors{:}];
end

% create sparsity pattern
sp = casos.Sparsity.tuplet(sz(1),sz(2),i,j,x,degrees);

end
