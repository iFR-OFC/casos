% SPDX-FileCopyrightText: 2023 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef UnifiedReturnStatus

enumeration
    SOLVER_RET_SUCCESS
    SOLVER_RET_UNKNOWN
    SOLVER_RET_LIMITED
    SOLVER_RET_NAN
    SOLVER_RET_INFEASIBLE
end

methods
    function s = addfield(status,s)
        % Add unified return status to structure.
        s.UNIFIED_RETURN_STATUS = char(status);
    end
end

end
