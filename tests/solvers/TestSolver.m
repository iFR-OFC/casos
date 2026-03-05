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
