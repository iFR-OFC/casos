% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Jan Olucak <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

%% References
rng(0)

% generate reference solutions from multipoly
disp("========================================");
disp("Starting: Generate test polynomials");
disp("========================================");

test_values_struct = struct;
reference_values = struct;

variables = casos.Indeterminates('x',5);

noPoly = 10;
maxdim = 6;
maxdeg = 3;

% generate scalar values
test_values_struct.scalar = cell(2,noPoly);
reference_values.scalar = cell(2,noPoly);

for k = 1:numel(test_values_struct.scalar)
    % create scalars
    [test_values_struct.scalar(k),reference_values.scalar(k)] = ...
                        generateTestPolynomials([1 1],variables,maxdeg);
end

% generate (column) vector values
test_values_struct.vector = cell(2,maxdim);
reference_values.vector = cell(2,maxdim);

for dim = 1:maxdim
    % create vectors of same dimensions
    [test_values_struct.vector(1,dim),reference_values.vector(1,dim)] = ...
                    generateTestPolynomials([dim-1 1],variables,maxdeg);
    [test_values_struct.vector(2,dim),reference_values.vector(2,dim)] = ...
                    generateTestPolynomials([dim-1 1],variables,maxdeg);
end

% generate matrix values
test_values_struct.matrix = cell(3,maxdim);
reference_values.matrix = cell(3,maxdim);

for dim = 1:maxdim
    % generate matrices of same dimensions
    [test_values_struct.matrix(1,dim),reference_values.matrix(1,dim)] = ...
        generateTestPolynomials([dim-1 maxdim-dim],variables,maxdeg);
    [test_values_struct.matrix(2,dim),reference_values.matrix(2,dim)] = ...
        generateTestPolynomials([dim-1 maxdim-dim],variables,maxdeg);
    % generate matrices of different dimensions
    [test_values_struct.matrix(3,dim),reference_values.matrix(3,dim)] = ...
        generateTestPolynomials([dim maxdim-dim],variables,maxdeg);
end

save("reference_values.mat","test_values_struct");

disp("Completed: Generate test polynomials");
disp(" ");

%% unary
disp("========================================");
disp("Starting: unary operation");
disp("========================================")

reference_unary = struct('scalar',struct, ...
                         'matrix',struct ...
);

% unary plus and minus
for op = ["uplus" "uminus"]
    % on scalar values
    reference_unary.scalar.(op) = cell(noPoly,1);
    for k = 1:noPoly
       reference_unary.scalar.(op){k} = multipoly2struct(feval(op,reference_values.scalar{1,k}));
    end

    % on matrix values
    reference_unary.matrix.(op) = cell(maxdim,1);
    for dim = 1:maxdim
        reference_unary.matrix.(op){dim} = multipoly2struct(feval(op,reference_values.matrix{1,dim}));
    end
end

% element-wise power with scalar exponent
reference_unary.scalar.power = cell(noPoly,4);
reference_unary.matrix.power = cell(maxdim,3);
for pow = (0:3)
    % on scalar values
    for k = 1:noPoly
        reference_unary.scalar.power{k,pow+1} = multipoly2struct(power(reference_values.scalar{1,k},pow));
    end

    % on matrix values
    for dim = 1:maxdim
        reference_unary.matrix.power{dim,pow+1} = multipoly2struct(power(reference_values.matrix{1,dim},pow));
    end
end

save("reference_values.mat","reference_unary","-append")

disp("Completed: unary operation");
disp(" ");

%% binary
disp("========================================");
disp("Starting: binary operation");
disp("========================================") 

reference_binary = struct('scalar',struct, ...
                             'inner',struct, ...
                             'outer',struct, ...
                             'matrix',struct ...
);

% element-wise addition, subtraction, and multiplication
% as well as left-side (B.\A) and right-side (A./B) division
for op = ["plus" "minus" "times" "ldivide" "rdivide"]
    % on scalar values
    reference_binary.scalar.(op) = cell(noPoly,noPoly);
    for k1 = 1:noPoly
        for k2 = 1:noPoly
            arg1 = reference_values.scalar{1,k1};
            arg2 = reference_values.scalar{2,k2};
            reference_binary.scalar.(op){k1,k2} = multipoly2struct(eval_binary(op,arg1,arg2));
        end
    end

    % on row-by-column values
    reference_binary.inner.(op) = cell(maxdim,maxdim);
    for d1 = 1:maxdim
        for d2 = 1:maxdim
            arg1 = reference_values.vector{1,d1}';
            arg2 = reference_values.vector{2,d2};

            reference_binary.inner.(op){d1,d2} = multipoly2struct(eval_binary(op,arg1,arg2));
        end
    end

    % on column-by-row values
    reference_binary.outer.(op) = cell(maxdim,maxdim);
    for d1 = 1:maxdim
        for d2 = 1:maxdim
            arg1 = reference_values.vector{1,d1};
            arg2 = reference_values.vector{2,d2}';

            reference_binary.outer.(op){d1,d2} = multipoly2struct(eval_binary(op,arg1,arg2));
        end
    end

    % on matrix values
    reference_binary.matrix.(op) = cell(maxdim,maxdim);
    for d1 = 1:maxdim
        for d2 = 1:maxdim
            arg1 = reference_values.matrix{1,d1};
            arg2 = reference_values.matrix{2,d2};

            if (~isrow(arg1) && ~isrow(arg2) && size(arg1,1) ~= size(arg2,1)) ...
                    || (~iscolumn(arg1) && ~iscolumn(arg2) && size(arg1,2) ~= size(arg2,2))
                % dimension mismatch
                continue
            end

            reference_binary.matrix.(op){d1,d2} = multipoly2struct(eval_binary(op,arg1,arg2));
        end
    end    
end

save("reference_values.mat","reference_binary","-append")

disp("Completed: binary operation");
disp(" ");

%% dot
disp("========================================");
disp("Starting: dot operation");
disp("========================================");

reference_dot = struct('scalar',struct, ...
                        'matrix',struct ...
);

% dot product on scalar values
reference_dot.scalar.dot = cell(noPoly,noPoly);
for k1 = 1:noPoly
    arg1 = reference_values.scalar{1,k1};
    basis = monomials(arg1);

    for k2 = 1:noPoly
        arg2 = reference_values.scalar{2,k2};
        reference_dot.scalar.dot{k1,k2} = full(dot(coordinates(arg1), coordinates(arg2,basis)));
    end
end

% dot product on matrix values
reference_dot.matrix.dot = cell(maxdim,maxdim);
for d1 = 1:maxdim
    arg1 = reference_values.matrix{1,d1};
    basis = monomials(arg1);

    for d2 = 1:maxdim
        arg2 = reference_values.matrix{2,d2};

        if ~isequal(size(arg1), size(arg2))
            % size mismatch
            continue
        end

        reference_dot.matrix.dot{d1,d2} = full(dot(coordinates(arg1,basis), coordinates(arg2,basis)));
    end
end

save("reference_values.mat","reference_dot","-append")

disp("Completed: dot operation");
disp(" ");

%% mtimes
disp("========================================");
disp("Starting: mtimes operation");
disp("========================================")

reference_mtimes = struct('scalar',struct, ...
                             'inner',struct, ...
                             'outer',struct, ...
                             'matrix',struct ...
);

% matrix multiplication and Kronecker product
for op = ["mtimes" "kron"]
    % on scalar values
    reference_mtimes.scalar.(op) = cell(noPoly,noPoly);
    for k1 = 1:noPoly
        for k2 = 1:noPoly
            arg1 = reference_values.scalar{1,k1};
            arg2 = reference_values.scalar{2,k2};
            reference_mtimes.scalar.(op){k1,k2} = multipoly2struct(feval(op,arg1,arg2));
        end
    end

    % on row-by-column values
    reference_mtimes.inner.(op) = cell(maxdim,maxdim);
    for d1 = 1:maxdim
        for d2 = 1:maxdim
            arg1 = reference_values.vector{1,d1}';
            arg2 = reference_values.vector{2,d2};

            if ~isequal(op,"kron") && (size(arg1,2) ~= size(arg2,1))
                % dimension mismatch
                continue
            end

            reference_mtimes.inner.(op){d1,d2} = multipoly2struct(feval(op,arg1,arg2));
        end
    end

    % on column-by-row values
    reference_mtimes.outer.(op) = cell(maxdim,maxdim);
    for d1 = 1:maxdim
        for d2 = 1:maxdim
            arg1 = reference_values.vector{1,d1};
            arg2 = reference_values.vector{2,d2}';

            reference_mtimes.outer.(op){d1,d2} = multipoly2struct(feval(op,arg1,arg2));
        end
    end

    % on matrix values
    reference_mtimes.matrix.(op) = cell(maxdim,maxdim);
    for d1 = 1:maxdim
        for d2 = 1:maxdim
            arg1 = reference_values.matrix{1,d1};
            arg2 = reference_values.matrix{3,d2};

            if ~isequal(op,"kron") && (size(arg1,2) ~= size(arg2,1))
                % dimension mismatch
                continue
            end

            reference_mtimes.matrix.(op){d1,d2} = multipoly2struct(feval(op,arg1,arg2));
        end
    end
end

% left-side matrix division B\A
reference_mtimes.scalar.mldivide = cell(noPoly,noPoly);
for k1 = 1:noPoly
    arg1 = reference_values.scalar{1,k1};

    vars = arg1.varname;
    reference_value_double = double(subs(arg1,vars,ones(size(vars))));

    for k2 = 1:noPoly
        arg2 = reference_values.scalar{2,k2};
        reference_mtimes.scalar.mldivide{k1,k2} = multipoly2struct(mtimes(inv(reference_value_double),arg2));
    end
end

% right-side matrix division A/B
reference_mtimes.scalar.mrdivide = cell(noPoly,noPoly);
for k2 = 1:noPoly
    arg2 = reference_values.scalar{2,k2};

    vars = arg2.varname;
    reference_value_double = double(subs(arg2,vars,ones(size(vars))));

    for k1 = 1:noPoly
        arg1 = reference_values.scalar{1,k1};
        reference_mtimes.scalar.mrdivide{k1,k2} = multipoly2struct(mrdivide(arg1,reference_value_double));
    end
end

% matrix power with scalar exponents
reference_mtimes.scalar.mpower = cell(noPoly,4);
for pow = (0:3)
    for k = 1:noPoly
        arg1 = reference_values.scalar{1,k};
        reference_mtimes.scalar.mpower{k,pow+1} = multipoly2struct(mpower(arg1,pow));
    end
end

save("reference_values.mat","reference_mtimes","-append")

disp("Completed: mtimes operation");
disp(" ");

%% nabla
disp("========================================");
disp("Starting: nabla operation");
disp("========================================")

reference_nabla = struct('scalar',struct, ...
                         'column',struct, ...
                         'row',struct, ...
                         'matrix',struct ...
);

% nabla with respect to single variable (derivative)
reference_nabla.scalar.derivative = cell(noPoly,4);
reference_nabla.column.derivative = cell(maxdim,4);
reference_nabla.row.derivative = cell(maxdim,4);
reference_nabla.matrix.derivative = cell(maxdim,4);

for ivar = 1:4
    % on scalar values
    for k = 1:noPoly
        reference_nabla.scalar.derivative{k,ivar} = multipoly2struct(eval_nabla("single",reference_values.scalar{1,k},ivar));
    end

    % on column vector values
    for d = 1:maxdim
        reference_nabla.column.derivative{d,ivar} = multipoly2struct(eval_nabla("single",reference_values.vector{1,d},ivar));
    end

    % on row vector values
    for d = 1:maxdim
        reference_nabla.row.derivative{d,ivar} = multipoly2struct(eval_nabla("single",reference_values.vector{2,d}',ivar));
    end

    % on matrix values
    for d = 1:maxdim
        reference_nabla.matrix.derivative{d,ivar} = multipoly2struct(eval_nabla("single",reference_values.matrix{1,d},ivar));
    end
end

% nabla with respect to multiple variables (gradient)
reference_nabla.scalar.gradient = cell(noPoly,4);
reference_nabla.column.gradient = cell(maxdim,4);
reference_nabla.row.gradient = cell(maxdim,4);
reference_nabla.matrix.gradient = cell(maxdim,4);

for ivar = 1:4
    % on scalar values
    for k = 1:noPoly
        reference_nabla.scalar.gradient{k,ivar} = multipoly2struct(eval_nabla("multiple",reference_values.scalar{2,k},ivar));
    end

    % on column vector values
    for d = 1:maxdim
        reference_nabla.column.gradient{d,ivar} = multipoly2struct(eval_nabla("multiple",reference_values.vector{2,d},ivar));
    end

    % on row vector values
    for d = 1:maxdim
        reference_nabla.row.gradient{d,ivar} = multipoly2struct(eval_nabla("multiple",reference_values.vector{1,d}',ivar));
    end

    % on matrix values
    for d = 1:maxdim
        reference_nabla.matrix.gradient{d,ivar} = multipoly2struct(eval_nabla("multiple",reference_values.matrix{2,d},ivar));
    end
end

save("reference_values.mat","reference_nabla","-append")

disp("Completed: nabla operation");
disp(" ");

%% poly2basis
disp("========================================");
disp("Starting: poly2basis operation");
disp("========================================")

reference_poly2basis = struct('scalar',struct, ...
                                 'column',struct, ...
                                 'row',struct, ...
                                 'matrix',struct ...
);

% on scalar values
reference_poly2basis.scalar.poly2basis = cell(noPoly,noPoly);
for k1 = 1:noPoly
    for k2 = 1:noPoly
        arg1 = reference_values.scalar{1,k1};
        arg2 = reference_values.scalar{2,k2};
        reference_poly2basis.scalar.poly2basis{k1,k2} = eval_poly2basis(arg1,arg2);
    end
end

% on column vector values
reference_poly2basis.column.poly2basis = cell(maxdim,maxdim);
for d1 = 1:maxdim
    for d2 = 1:maxdim
        arg1 = reference_values.vector{1,d1};
        arg2 = reference_values.vector{2,d2};

        if ~isequal(size(arg1),size(arg2))
            % size mismatch
            continue;
        end

        reference_poly2basis.column.poly2basis{d1,d2} = eval_poly2basis(arg1,arg2);
    end
end

% on row vector values
reference_poly2basis.row.poly2basis = cell(maxdim,maxdim);
for d1 = 1:maxdim
    for d2 = 1:maxdim
        arg1 = reference_values.vector{1,d1}';
        arg2 = reference_values.vector{2,d2}';

        if ~isequal(size(arg1),size(arg2))
            % size mismatch
            continue;
        end

        reference_poly2basis.row.poly2basis{d1,d2} = eval_poly2basis(arg1,arg2);
    end
end

% on matrix values
reference_poly2basis.matrix.poly2basis = cell(maxdim,maxdim);
for d1 = 1:maxdim
    for d2 = 1:maxdim
        arg1 = reference_values.matrix{1,d1};
        arg2 = reference_values.matrix{2,d2};

        if ~isequal(size(arg1),size(arg2))
            % size mismatch
            continue;
        end

        reference_poly2basis.matrix.poly2basis{d1,d2} = eval_poly2basis(arg1,arg2);
    end
end

save("reference_values.mat","reference_poly2basis","-append")

disp("Completed: coordinates operation");
disp(" ");

%% remove_coeffs
disp("========================================");
disp("Starting: remove_coeffs operation");
disp("========================================")

reference_remove_coeffs = struct('scalar',struct, ...
                                 'column',struct, ...
                                 'row',struct, ...
                                 'matrix',struct ...
);

reference_remove_coeffs.scalar.remove_coeffs = cell(noPoly,3);
reference_remove_coeffs.column.remove_coeffs = cell(maxdim,3);
reference_remove_coeffs.row.remove_coeffs = cell(maxdim,3);
reference_remove_coeffs.matrix.remove_coeffs = cell(maxdim,3);

for decade = 1:3
    % on scalar values
    for k = 1:noPoly
        arg1 = reference_values.scalar{1,k};
        arg2 = reference_values.scalar{2,k};

        reference_remove_coeffs.scalar.remove_coeffs{k,decade} = multipoly2struct(eval_remove_coeffs(arg1,arg2,10*decade));
    end

    % on column vector values
    for d = 1:maxdim
        arg1 = reference_values.vector{1,d};
        arg2 = reference_values.vector{2,d};

        reference_remove_coeffs.column.remove_coeffs{d,decade} = multipoly2struct(eval_remove_coeffs(arg1,arg2,10*decade));
    end

    % on row vector values
    for d = 1:maxdim
        arg1 = reference_values.vector{1,d}';
        arg2 = reference_values.vector{2,d}';

        reference_remove_coeffs.row.remove_coeffs{d,decade} = multipoly2struct(eval_remove_coeffs(arg1,arg2,10*decade));
    end

    % on matrix values
    for d = 1:maxdim
        arg1 = reference_values.matrix{1,d};
        arg2 = reference_values.matrix{2,d};

        reference_remove_coeffs.matrix.remove_coeffs{d,decade} = multipoly2struct(eval_remove_coeffs(arg1,arg2,10*decade));
    end
end

save("reference_values.mat","reference_remove_coeffs","-append")

disp("Completed: remove_coeffs operation");
disp(" ");

%% subs
disp("========================================");
disp("Starting: subs operation");
disp("========================================")

reference_subs = struct('scalar',struct, ...
                         'column',struct, ...
                         'row',struct, ...
                         'matrix',struct ...
);

% substitute single variable
reference_subs.scalar.single = cell(noPoly,4);
reference_subs.column.single = cell(maxdim,4);
reference_subs.row.single = cell(maxdim,4);
reference_subs.matrix.single = cell(maxdim,4);

for ivar = 1:4
    % on scalar values
    for k = 1:noPoly
        arg = reference_values.scalar{1,k};
        new = reference_values.scalar{2,k};

        reference_subs.scalar.single{k,ivar} = multipoly2struct(eval_subs("single",arg,ivar,new));
    end

    % on column vector values
    for d = 1:maxdim
        arg = reference_values.vector{1,d};
        new = reference_values.scalar{1,d};

        reference_subs.column.single{d,ivar} = multipoly2struct(eval_subs("single",arg,ivar,new));
    end

    % on row vector values
    for d = 1:maxdim
        arg = reference_values.vector{2,d}';
        new = reference_values.scalar{2,d};

        reference_subs.row.single{d,ivar} = multipoly2struct(eval_subs("single",arg,ivar,new));
    end

    % on matrix values
    for d = 1:maxdim
        arg = reference_values.matrix{2,d};
        new = reference_values.scalar{1,d};

        reference_subs.matrix.single{d,ivar} = multipoly2struct(eval_subs("single",arg,ivar,new));
    end
end

% substitute multiple variables
reference_subs.scalar.multiple = cell(noPoly,4);
reference_subs.column.multiple = cell(maxdim,4);
reference_subs.row.multiple = cell(maxdim,4);
reference_subs.matrix.multiple = cell(maxdim,4);

for ivar = 1:4
    % on scalar values
    for k = 1:noPoly
        arg = reference_values.scalar{2,k};
        new = reference_values.vector{2,arg.nvars+1};

        reference_subs.scalar.multiple{k,ivar} = multipoly2struct(eval_subs("multiple",arg,ivar,new));
    end

    % on column vector values
    for d = 1:maxdim
        arg = reference_values.vector{2,d};
        new = reference_values.vector{1,arg.nvars+1};

        reference_subs.column.multiple{d,ivar} = multipoly2struct(eval_subs("multiple",arg,ivar,new));
    end

    % on row vector values
    for d = 1:maxdim
        arg = reference_values.vector{1,d}';
        new = reference_values.vector{2,arg.nvars+1};

        reference_subs.row.multiple{d,ivar} = multipoly2struct(eval_subs("multiple",arg,ivar,new));
    end

    % on matrix values
    for d = 1:maxdim
        arg = reference_values.matrix{1,d};
        new = reference_values.vector{1,arg.nvars+1};

        reference_subs.matrix.multiple{d,ivar} = multipoly2struct(eval_subs("multiple",arg,ivar,new));
    end
end

save("reference_values.mat","reference_subs","-append")

disp("Completed: subs operation");
disp(" ");

%% concat
disp("========================================");
disp("Starting: concat operation");
disp("========================================")

reference_concat = struct('scalar',struct, ...
                             'column',struct, ...
                             'row',struct, ...
                             'matrix',struct ...
);

% concatenate to m-by-n matrix from scalars
reference_concat.scalar.concat = cell(2,5);
for nrow = 1:5
    ncol = 6-nrow;

    for k = 1:2
        args_to_vertcat = mat2cell(reference_values.scalar(k,1:(nrow*ncol)), 1, repmat(nrow,1,ncol));
        args_to_horzcat = cellfun(@(c) vertcat(c{:}), args_to_vertcat, 'UniformOutput', false);

        reference_concat.scalar.concat{k,nrow} = multipoly2struct(horzcat(args_to_horzcat{:}));
    end
end

% concatenation of column vectors
reference_concat.column.diagcat = cell(maxdim,maxdim);
reference_concat.column.horzcat = cell(maxdim,maxdim);
reference_concat.column.vertcat = cell(maxdim,maxdim);

for d1 = 1:maxdim
    for d2 = 1:maxdim
        arg1 = reference_values.vector{1,d1};
        arg2 = reference_values.vector{2,d2};

        % diagonal concatenation
        reference_concat.column.diagcat{d1,d2} = multipoly2struct(blkdiag(arg1,arg2));
        % horizontal concatenation
        if isempty(arg1) || isempty(arg2) || size(arg1,1) == size(arg2,1)
            reference_concat.column.horzcat{d1,d2} = multipoly2struct(horzcat(arg1,arg2));
        end
        % vertical concatenation 
        if isempty(arg1) || isempty(arg2) || size(arg1,2) == size(arg2,2)
            reference_concat.column.vertcat{d1,d2} = multipoly2struct(vertcat(arg1,arg2));
        end
    end
end

% concatenation of row vectors
reference_concat.row.diagcat = cell(maxdim,maxdim);
reference_concat.row.horzcat = cell(maxdim,maxdim);
reference_concat.row.vertcat = cell(maxdim,maxdim);

for d1 = 1:maxdim
    for d2 = 1:maxdim
        arg1 = reference_values.vector{1,d1}';
        arg2 = reference_values.vector{2,d2}';

        % diagonal concatenation
        reference_concat.row.diagcat{d1,d2} = multipoly2struct(blkdiag(arg1,arg2));
        % horizontal concatenation
        if isempty(arg1) || isempty(arg2) || size(arg1,1) == size(arg2,1)
            reference_concat.row.horzcat{d1,d2} = multipoly2struct(horzcat(arg1,arg2));
        end
        % vertical concatenation 
        if isempty(arg1) || isempty(arg2) || size(arg1,2) == size(arg2,2)
            reference_concat.row.vertcat{d1,d2} = multipoly2struct(vertcat(arg1,arg2));
        end
    end
end

% concatenation of matrices
reference_concat.matrix.diagcat = cell(maxdim,maxdim);
reference_concat.matrix.horzcat = cell(maxdim,maxdim);
reference_concat.matrix.vertcat = cell(maxdim,maxdim);

for d1 = 1:maxdim
    for d2 = 1:maxdim
        arg1 = reference_values.matrix{1,d1};
        arg2 = reference_values.matrix{2,d2};

        % diagonal concatenation
        reference_concat.matrix.diagcat{d1,d2} = multipoly2struct(blkdiag(arg1,arg2));
        if isempty(arg1) && isempty(arg2)
            % empty concatenation
            reference_concat.matrix.horzcat{d1,d2} = multipoly2struct(polynomial);
            reference_concat.matrix.vertcat{d1,d2} = multipoly2struct(polynomial);
            continue
        end
        % horizontal concatenation
        if isempty(arg1) || isempty(arg2) || size(arg1,1) == size(arg2,1)
            reference_concat.matrix.horzcat{d1,d2} = multipoly2struct(horzcat(arg1,arg2));
        end
        % vertical concatenation 
        if isempty(arg1) || isempty(arg2) || size(arg1,2) == size(arg2,2)
            reference_concat.matrix.vertcat{d1,d2} = multipoly2struct(vertcat(arg1,arg2));
        end
    end
end

save("reference_values.mat","reference_concat","-append")

disp("Completed: concat operation");
disp(" ");

% %% sum
% disp("========================================");
% disp("Starting: sum operation");
% disp("========================================")
% 
% reference_solutions = struct;
% reference_solutions.single = cell(1,1);
% reference_solutions.single{1} = multipoly2struct(sum(reference_values_flat{1}, 2)));
% 
% reference_solutions.multiple = cell(10,1);
% for k = 1:10
%    reference_solutions.multiple{k} = multipoly2struct(sum(reference_values_flat{k}, 1)));
% end
% 
% save("reference_values.mat","reference_solutions","-append")
% 
% disp("Completed: sum operation");
% disp(" ");
% 
% %% prod
% disp("========================================");
% disp("Starting: prod operation");
% disp("========================================")
% 
% reference_solutions = struct;
% reference_solutions.single = cell(1,1);
% reference_solutions.single{1} = multipoly2struct(prod(reference_values_flat{1}, 1)));
% 
% reference_solutions.multiple = cell(10,1);
% for k = 1:10
%    reference_solutions.multiple{k} = multipoly2struct(prod(reference_values_flat{k}, 2)));
% end
% 
% save("reference_prod.mat","test_values_struct","reference_solutions")
% 
% disp("Completed: prod operation");
% disp(" ");
% 
% %% transpose
% disp("========================================");
% disp("Starting: transpose operation");
% disp("========================================")
% 
% reference_solutions = struct;
% reference_solutions.single = cell(1,1);
% reference_solutions.single{1} = multipoly2struct(transpose(reference_values_flat{1})));
% 
% reference_solutions.multiple = cell(10,1);
% for k = 1:10
%    reference_solutions.multiple{k} = multipoly2struct(transpose(reference_values_flat{k})));
% end
% 
% save("reference_values.mat","reference_solutions","-append")
% 
% disp("Completed: transpose operation");
% disp(" ");

%% Fini
disp("========================================");
disp("All reference values generated successfully!");
disp("========================================")
