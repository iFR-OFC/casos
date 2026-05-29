% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef VerbosityLevel < uint32
% Level of verbosity for logging.

enumeration
    off     (0)     % no display
    error   (1)     % errors only
    warning (2)     % errors and warnings
    info    (3)     % information
    debug   (4)     % debug messages
    tout    (inf)   % everything
end

end
