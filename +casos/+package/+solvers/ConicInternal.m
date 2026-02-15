classdef (Abstract) ConicInternal < casos.package.solvers.SolverCommon & casos.package.functions.FunctionInternal
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
        obj@casos.package.functions.FunctionInternal(name);
        obj@casos.package.solvers.SolverCommon(varargin{:});
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

    %% Call internal
    function argout = call(obj,argin,on_basis)
        % Call function.
        if nargin > 2 && on_basis
            % evaluate on coordinates
            error('Not implemented.')

        else
            % get nonzero coordinates for basis
            in = cellfun(@(p,i) casadi.DM(p), argin(:), num2cell((1:get_n_in(obj))'-1), 'UniformOutput', false);
            % evaluate on coordinates
            argout = eval(obj,in);
        end
    end
end

end
