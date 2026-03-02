% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function [obj,coeffs] = coeff_repmat(obj,coeffs,varargin)
% Repeat copies of polynomial.
assert(nargin > 2, 'Not enough input arguments.')

% repition scheme
rep = horzcat(varargin{:});

assert(isrow(rep) && length(rep) == 2, 'Replication factors must be a pair (row) of integers or two integer scalars.')

% new dimensions
new_sz = rep.*obj.matdim;

% repeat coefficients
coeffs = reshape(repmat(coeffs,rep),obj.nterm,prod(new_sz));

% new sparsity pattern
obj.matdim = new_sz;

% store coefficients
obj = set_coefficients(obj,coeffs);

end
