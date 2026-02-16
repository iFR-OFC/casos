classdef (Abstract) FunctionInternal < casos.package.functions.FunctionCommon
% Internal interface for callable functions.

properties (Abstract,SetAccess=private)
    class_name;
end

properties (SetAccess = private)
    name;
end

methods (Abstract)
    % inputs
    n = get_n_in(obj);
    s = get_name_in(obj,i);
    z = get_sparsity_in(obj,i);
    i = get_index_in(obj,str);

    % outputs
    n = get_n_out(obj);
    s = get_name_out(obj,i);
    z = get_sparsity_out(obj,i);
    i = get_index_out(obj,str);
end

methods
    function obj = FunctionInternal(name,varargin)
        % Superclass constructor.
        obj@casos.package.functions.FunctionCommon(varargin{:});
        obj.name = name;
    end

    %% Getter
    function z = get_monomials_in(obj,i)
        % Return monomials of input arguments.
        warning('DEPRECATED. Use sparsity instead.')
        z = monomials(get_sparsity_in(obj,i));
    end

    function val = get_default_in(obj,i) %#ok<INUSD>
        % Return default values of input arguments.
        val = 0;
    end

    function sz = get_size_in(obj,i)
        % Return size of input arguments.
        sz = size(get_sparsity_in(obj,i));
    end

    function z = get_monomials_out(obj,i)
        % Return monomials of output arguments.
        warning('DEPRECATED. Use sparsity instead.')
        z = monomials(get_sparsity_out(obj,i));
    end

    function sz = get_size_out(obj,i)
        % Return size of output arguments.
        sz = size(get_sparsity_out(obj,i));
    end

    function s = get_stats(~)
        % Return empty stats.
        s = struct;
    end

    function s = get_info(~)
        % Return empty info.
        s = struct;
    end

    function J = jacobian(obj) %#ok<STOUT>
        % Return Jacobian function if supported.
        error('Derivatives cannot be calculated for %s.',obj.name)
    end

    %% Call internal
    function argout_ = call(obj,argin_,varargin)
        % Call function.
        assert(iscell(argin_) || isstruct(argin_), 'Arguments must be given as cell array or struct.')

        if isstruct(argin_)
            % parse arguments by name
            argin = cell(obj.get_n_in,1);

            % name of arguments
            fn_arg = fieldnames(argin_);
            % index of arguments
            idx_in = cellfun(@(arg) obj.get_index_in(arg), fn_arg);
            % find arguments
            L = ismember(0:obj.get_n_in-1, idx_in);
            % name of outputs
            fn_out = arrayfun(@(i) obj.get_name_out(i), 0:obj.get_n_out-1, 'UniformOutput', false);
    
            % default values
            argin(~L) = arrayfun(@(i) obj.get_default_in(i), find(~L)-1, 'UniformOutput', false);
    
            % assign arguments
            argin(idx_in+1) = struct2cell(argin_);
            % call function with cell
            argout = call(obj,argin,varargin{:});
            % parse outputs
            argout_ = cell2struct(argout(:),fn_out(:));

        elseif nargin > 2 && varargin{1}
            % evaluate on coordinates
            assert(length(argin_) == obj.get_n_in, 'Incorrect number of inputs: Expected %d, got %d.', obj.get_n_in, length(argin_));

            argout_ = eval_on_basis(obj,argin_);

        else
            % evaluate on polynomials
            assert(length(argin_) == obj.get_n_in, 'Incorrect number of inputs: Expected %d, got %d.', obj.get_n_in, length(argin_));

            % get nonzero coordinates for basis
            in = cellfun(@(p,i) poly2basis(p,get_sparsity_in(obj,i)), argin_(:), num2cell((1:get_n_in(obj))'-1), 'UniformOutput', false);
            % evaluate on coordinates
            out = eval_on_basis(obj,in);
            % return polynomials as result
            argout_ = cellfun(@(c,i) casos.package.polynomial(get_sparsity_out(obj,i),c), out(:), num2cell((1:get_n_out(obj))'-1), 'UniformOutput', false);
        end
    end
end

methods (Access=protected)
    %% Internal evaluation
    function argout = eval_on_basis(obj,argin) %#ok<STOUT,INUSD>
        % Evaluate function on nonzero polynomials.
        error('Not implemented.')
    end
end

end
