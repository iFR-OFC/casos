% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function [indets,I] = combine(varargin)
% Combine indeterminate variables.

indets = casos.Indeterminates;

switch (nargin)
    case 0
        % nothing to do
        I = [];
        return

    case 1
        indets.variables = varargin{1}.variables;
        I = 1:length(indets);
        return

    case 2
        allvars = [varargin{1}.variables varargin{2}.variables];

    otherwise
        allvars = cellfun(@(a) a.variables, varargin, 'UniformOutput', false);
        allvars = [allvars{:}];
end

% remove duplicates and sort
[vars,~,I] = unique(allvars);

% return
indets.variables = vars;

end
