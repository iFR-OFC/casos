classdef (Abstract) ConicInternal < casos.package.solvers.SolverInternal
% Common superclass for conic solvers.

properties (Abstract, Access=protected)
    fhan;
    ghan;
end

properties (Constant, Access=protected)
%     solver_options = casos.package.functions.FunctionCommon.options;
end

methods (Static)
    function options = get_options
        % Return static options.
        options = casos.package.solvers.SolverInternal.solver_options;
    end
end

methods (Abstract)
    % internal evaluation
    argout = eval(obj,argin);
end

methods
    function obj = ConicInternal(name,varargin)
        obj@casos.package.solvers.SolverInternal(name,varargin{:});
    end

    %% Common Callback interface
    function n = get_n_in(obj)
        % Return number of inputs.
        n = n_in(obj.fhan);
    end

    function n = get_n_out(obj)
        % Return number of outputs.
        n = n_out(obj.ghan);
    end

    function i = get_index_in(obj,name)
        % Return index of input argument.
        i = index_in(obj.fhan,name);
    end

    function i = get_index_out(obj,name)
        % Return index of output argument.
        i = index_out(obj.ghan,name);
    end

    function str = get_name_in(obj,i)
        % Return names of input arguments.
        str = name_in(obj.fhan,i);
    end

    function str = get_name_out(obj,i)
        % Return names of output arguments.
        str = name_out(obj.ghan,i);
    end

    function sp = get_sparsity_in(obj,i)
        % Return sparsity of input arguments.
        sp = casos.Sparsity(sparsity_in(obj.fhan,i));
    end

    function sp = get_sparsity_out(obj,i)
        % Return sparsity of output arguments.
        sp = casos.Sparsity(sparsity_out(obj.ghan,i));
    end

    function val = get_default_in(~,i)
        % Default inputs.
        switch (i) % 0-index
            case {3 6}, val = -inf; % lba, lbx
            case {4 7}, val = +inf; % uba, ubx
            otherwise, val = 0;
        end
    end

    %% Call internal
    function argout = call(obj,argin,varargin)
        % Call function.
        if isstruct(argin)
            % arguments by name
            argout = call@casos.package.solvers.SolverInternal(obj,argin,varargin{:});

        elseif nargin > 2
            % evaluate on coordinates
            error('Not implemented.')

        else
            % evaluate on matrices
            assert(length(argin) == obj.get_n_in, 'Incorrect number of inputs: Expected %d, got %d.', obj.get_n_in, length(argin));

            % get nonzero coordinates for basis
            in = cellfun(@(p,i) projectScalar(p,get_sparsity_in(obj,i)), argin(:), num2cell((1:get_n_in(obj))'-1), 'UniformOutput', false);
            % evaluate on coordinates
            argout = eval(obj,in); %#ok<EV2IN>
        end
    end
end

end

function b = projectScalar(a,sp)
% Project scalar or matrix onto sparsity pattern.

sp = casadi.Sparsity(sp);

if isempty(a)
    % create zero
    b = casadi.DM(sp);

elseif isscalar(a)
    % repeat argument to sparsity pattern
    b = casadi.DM(sp,a);

elseif isvector(a) && isvector(sp)
    % project vector onto sparsity pattern
    % reshape vector if necessary
    b = project(reshape(casadi.DM(a),size(sp)),sp);

else
    % project matrix onto sparsity pattern
    b = project(casadi.DM(a),sp);
end

end
