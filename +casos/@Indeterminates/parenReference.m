% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function varargout = parenReference(obj,indexOp)
% Implementing matlab.mixin.indexing.RedefinesParen.parenReference

idx = indexOp(1);

% perform reference
vars = obj.variables.(idx);

% new indeterminates
out = casos.Indeterminates;
% ensure that names are stored as row vector
out.variables = reshape(vars,1,[]);

if length(indexOp) > 1
    % forward reference
    [varargout{1:nargout}] = out.(indexOp(2:end));

else
    varargout = {out};
end

end
