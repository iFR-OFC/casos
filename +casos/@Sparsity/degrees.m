% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function varargout = degrees(obj,varargin)
% Return degrees of sparsity pattern.
%
% Possible syntax:
%
%   deg = degrees(p)
%
% Returns a vector of degrees.
%
%   [mn,mx] = degrees(p)
%
% Returns the minimum and maximum degrees.

dg = get_degree(obj,varargin{:});

if nargout < 2
    varargout = {dg};

else
    varargout = {min(dg) max(dg)};

end

end
