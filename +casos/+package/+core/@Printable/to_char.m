% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function c = to_char(obj)
% Return string representation as character vector.

s = str(obj);

if isscalar(s)
    % return single string representation
    c = s{1};

else
    % no single string representation
    c = sprintf('%dx%d %s',size(s,1),size(s,2),class(obj));
end

end
