% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Jan Olucak <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef (Abstract) TestSolver < matlab.unittest.TestCase
% Base class for solver tests.

methods 
    function check_required_package(test_case,package)
        switch (package)
            case 'mosek'
                package = 'mosekopt';
            case 'clarabel'
                package = 'clarabel_mex';
        end

        message = sprintf('Required package is missing: %s.', package);
        
        test_case.assumeTrue(exist(package,'file') >= 2, message);
    end
end

end
