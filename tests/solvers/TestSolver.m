classdef (Abstract) TestSolver < matlab.unittest.TestCase
% Base class for solver tests.

properties (Abstract, Access=protected, Constant)
    packages;
end

methods (TestClassSetup)
    function setupClass(test_case)
        [available,missing] = checkRequiredPackages(test_case.packages);

        if ~available
            default = 'The following required packages are missing: %s.';
            message = sprintf(default, strjoin(missing, ', '));
            test_case.assumeTrue(available, message);
        end
    end
end

end
