classdef FilterLinesearch
    %FILTERLINESEARCH Generic filter line search interface.
    %
    % This class intentionally provides only a minimal API skeleton so it
    % can later be reused by different nonlinear solvers.

    properties (SetAccess=private)
        options
    end

    methods
        function obj = FilterLinesearch(opts)
            % Construct with algorithm options.
            if nargin < 1 || isempty(opts)
                opts = struct;
            end

            if ~isstruct(opts)
                error('FilterLinesearch options must be a struct.')
            end

            obj.options = opts;
        end

        function filter = initialize_filter(obj)
            error('FilterLinesearch:NotImplemented', ...
                'initialize_filter is not implemented yet.')
        end
    end
end

