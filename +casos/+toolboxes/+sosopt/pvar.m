% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function varargout = pvar(varargin)
% Create scalar indeterminate variables.

varargout = cell(1,nargout);

% call constructor for each input
for i = 1:nargin
    % new indeterminate variable
    p = casos.PS(varargin{i});

    if nargout == 0
        % create variable in workspace
        assert(ischar(varargin{i}),'Inputs must be strings.')

        assignin('caller',varargin{i},p);
    else
        % return variables
        varargout{i} = p;
    end
end

end
