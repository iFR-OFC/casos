% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef (Abstract,HandleCompatible) Printable
% Base class for display.

methods (Abstract)
    % Return string representation(s) as cell array.
    out = str(obj);
end

methods
    function disp(obj)
        % Print string representation to command line.
        disp(cell2mat(str(obj)));
    end
end

methods (Access=public)
    disp_matrix(obj,varargin);
    c = to_char(obj);
end

end
