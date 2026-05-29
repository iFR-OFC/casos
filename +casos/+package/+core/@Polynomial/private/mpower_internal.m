% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function [Sb,cfb] = mpower_internal(Sa,cfa,n)
% Compute coefficient matrix for matrix power.

    if n == 1
        % terminate recursion
        Sb = Sa;
        cfb = cfa;
        return
    end

    nhalf = floor(n/2);

    % compute B = A^k*A^k
    [Sb,cfb] = mpower_internal(Sa,cfa,nhalf);
    [Sb,cfb] = mtimes_internal(Sb,Sb,cfb,cfb);

    if nhalf < ceil(n/2)
        % exponent is odd
        % compute B*A
        [Sb,cfb] = mtimes_internal(Sb,Sa,cfb,cfa);
    end
    % TODO: don't remove zero coefficients and/or degrees within recursion?
end
