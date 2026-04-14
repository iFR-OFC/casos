% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function v = cat(dim,varargin)
% Concatenate indeterminate variables.
%
% Note: Indeterminate variables are always concatenated horizontally.

% parse input arguments
[tf,vars] = cellfun(@parse, varargin, 'UniformOutput',false);

if ~all([tf{:}])
    % concatenate algebraic objects
    v = cat@casos.package.core.AlgebraicObject(dim,varargin{:});
    return
end

% else:
vars = horzcat(vars{:});    % ensure row vector

% concatenate variables
v = casos.Indeterminates(vars{:});

end

function [tf,vars] = parse(arg)
% Parse input arguments.

% check for indeterminate variables
tf = (isa(arg,'casos.package.core.AlgebraicObject') && is_indet(arg));

if ~tf
    % nothing to do
    vars = {};
else
    % get variables
    arg = casos.Indeterminates(arg);

    vars = arg.variables;
end

end
