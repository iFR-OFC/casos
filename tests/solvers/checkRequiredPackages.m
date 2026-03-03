function [available,missing_packages] = checkRequiredPackages(packages)
    % Define a list of required packages and their check functions
    % packages = {'mosek'};
    check_package = @(name) (exist(name, 'file') >= 2);

    % Initialize the flag for package availability
    package_available = false(size(packages));

    % Check each package
    for i = 1:numel(packages)
        name = packages{i};
        package_available(i) = check_package(name);
    end

    % set output
    missing_packages = packages(~package_available);
    available = all(package_available);
end
