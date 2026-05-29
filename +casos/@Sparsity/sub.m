% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function S = sub(obj,ii,S0)
% Subreference polynomial sparsity pattern.

if ~isa(S0,'casos.Sparsity') && ~isa(S0,'casadi.Sparsity')
    % subindices given
    [R,C] = ndgrid(ii,S0);
    ii = sub2ind(size(obj),R(:),C(:));
    sz = size(R);

else
    assert(length(ii) == numel(S0), 'Not supported.')
    sz = size(S0);
end

% subreference coefficient pattern
S = coeff_subsref(obj,obj.coeffs,ii,sz);

end
