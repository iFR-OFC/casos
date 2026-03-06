% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function S = dense(n,k,varargin)
% Create dense sparsity pattern.

if nargin < 2
    % dense(n)
    S = casos.Sparsity(casadi.Sparsity.dense(n));
elseif isnumeric(k)
    % dense(n,k,...)
    S = casos.Sparsity(casadi.Sparsity.dense(n,k),varargin{:});
else
    % dense(n,...)
    S = casos.Sparsity(casadi.Sparsity.dense(n),k,varargin{:});
end

end
