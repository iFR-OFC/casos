% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function S = diag(n,k,varargin)
% Create diagonal sparsity pattern.

if nargin < 2
    % diag(n)
    S = casos.Sparsity(casadi.Sparsity.diag(n));
elseif isnumeric(k)
    % diag(n,k,...)
    S = casos.Sparsity(casadi.Sparsity.diag(n,k),varargin{:});
else
    % diag(n,...)
    S = casos.Sparsity(casadi.Sparsity.diag(n),k,varargin{:});
end

end
