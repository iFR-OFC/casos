% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Jan Olucak <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

rng(0)

% Generate reference solutions from multipoly
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

save("test_values.mat","test_values_struct");

disp("Completed: Generate test polynomials");
disp(" ");

%% unary
disp("========================================");
disp("Starting: unary operation");
disp("========================================")

reference_solutions = struct('scalar',struct, ...
                             'matrix',struct ...
);

% unary plus and minus
for op = ["uplus" "uminus"]
    % on scalar values
    reference_solutions.scalar.(op) = cell(noPoly,1);
    for k = 1:noPoly
       reference_solutions.scalar.(op){k} = multipoly2struct(feval(op,reference_values.scalar{1,k}));
    end

    % on matrix values
    reference_solutions.matrix.(op) = cell(maxdim,1);
    for dim = 1:maxdim
        reference_solutions.matrix.(op){dim} = multipoly2struct(feval(op,reference_values.matrix{1,dim}));
    end
end

% element-wise power with scalar exponent
reference_solutions.scalar.power = cell(noPoly,4);
reference_solutions.matrix.power = cell(maxdim,3);
for pow = (0:3)
    % on scalar values
    for k = 1:noPoly
        reference_solutions.scalar.power{k,pow+1} = multipoly2struct(power(reference_values.scalar{1,k},pow));
    end

    % on matrix values
    for dim = 1:maxdim
        reference_solutions.matrix.power{dim,pow+1} = multipoly2struct(power(reference_values.matrix{1,dim},pow));
    end
end

save("reference_unary.mat","test_values_struct","reference_solutions")

disp("Completed: unary operation");
disp(" ");

%% binary
disp("========================================");
disp("Starting: binary operation");
disp("========================================") 

reference_solutions = struct('scalar',struct, ...
                             'inner',struct, ...
                             'outer',struct, ...
                             'matrix',struct ...
);

% element-wise addition, subtraction, and multiplication
% as well as left-side (B.\A) and right-side (A./B) division
for op = ["plus" "minus" "times" "ldivide" "rdivide"]
    % on scalar values
    reference_solutions.scalar.(op) = cell(noPoly,noPoly);
    for k1 = 1:noPoly
        for k2 = 1:noPoly
            arg1 = reference_values.scalar{1,k1};
            arg2 = reference_values.scalar{2,k2};
            reference_solutions.scalar.(op){k1,k2} = multipoly2struct(eval_binary(op,arg1,arg2));
        end
    end

    % on row-by-column values
    reference_solutions.inner.(op) = cell(maxdim,maxdim);
    for d1 = 1:maxdim
        for d2 = 1:maxdim
            arg1 = reference_values.vector{1,d1}';
            arg2 = reference_values.vector{2,d2};
            
            reference_solutions.inner.(op){d1,d2} = multipoly2struct(eval_binary(op,arg1,arg2));
        end
    end

    % on column-by-row values
    reference_solutions.outer.(op) = cell(maxdim,maxdim);
    for d1 = 1:maxdim
        for d2 = 1:maxdim
            arg1 = reference_values.vector{1,d1};
            arg2 = reference_values.vector{2,d2}';

            reference_solutions.outer.(op){d1,d2} = multipoly2struct(eval_binary(op,arg1,arg2));
        end
    end

    % on matrix values
    reference_solutions.matrix.(op) = cell(maxdim,maxdim);
    for d1 = 1:maxdim
        for d2 = 1:maxdim
            arg1 = reference_values.matrix{1,d1};
            arg2 = reference_values.matrix{2,d2};

            if (~isrow(arg1) && ~isrow(arg2) && size(arg1,1) ~= size(arg2,1)) ...
                    || (~iscolumn(arg1) && ~iscolumn(arg2) && size(arg1,2) ~= size(arg2,2))
                % dimension mismatch
                continue
            end

            reference_solutions.matrix.(op){d1,d2} = multipoly2struct(eval_binary(op,arg1,arg2));
        end
    end    
end

save("reference_binary.mat","test_values_struct","reference_solutions")

disp("Completed: binary operation");
disp(" ");

%% dot
disp("========================================");
disp("Starting: dot operation");
disp("========================================");

reference_solutions = struct;

% dot product on scalar values
reference_solutions.scalar = cell(noPoly,noPoly);
for k1 = 1:noPoly
    arg1 = reference_values.scalar{1,k1};
    basis = monomials(arg1);

    for k2 = 1:noPoly
        arg2 = reference_values.scalar{2,k2};
        reference_solutions.scalar{k1,k2} = full(dot(coordinates(arg1), coordinates(arg2,basis)));
    end
end

% dot product on matrix values
reference_solutions.matrix = cell(maxdim,maxdim);
for d1 = 1:maxdim
    arg1 = reference_values.matrix{1,d1};
    basis = monomials(arg1);

    for d2 = 1:maxdim
        arg2 = reference_values.matrix{2,d2};

        if ~isequal(size(arg1), size(arg2))
            % size mismatch
            continue
        end

        reference_solutions.matrix{d1,d2} = full(dot(coordinates(arg1,basis), coordinates(arg2,basis)));
    end
end

save("reference_dot.mat","test_values_struct","reference_solutions")

disp("Completed: dot operation");
disp(" ");

%% mtimes
disp("========================================");
disp("Starting: mtimes operation");
disp("========================================")

reference_solutions = struct('scalar',struct, ...
                             'inner',struct, ...
                             'outer',struct, ...
                             'matrix',struct ...
);

% matrix multiplication and Kronecker product
for op = ["mtimes" "kron"]
    % on scalar values
    reference_solutions.scalar.(op) = cell(noPoly,noPoly);
    for k1 = 1:noPoly
        for k2 = 1:noPoly
            arg1 = reference_values.scalar{1,k1};
            arg2 = reference_values.scalar{2,k2};
            reference_solutions.scalar.(op){k1,k2} = multipoly2struct(feval(op,arg1,arg2));
        end
    end

    % on row-by-column values
    reference_solutions.inner.(op) = cell(maxdim,maxdim);
    for d1 = 1:maxdim
        for d2 = 1:maxdim
            arg1 = reference_values.vector{1,d1}';
            arg2 = reference_values.vector{2,d2};

            if ~isequal(op,"kron") && (size(arg1,2) ~= size(arg2,1))
                % dimension mismatch
                continue
            end

            reference_solutions.inner.(op){d1,d2} = multipoly2struct(feval(op,arg1,arg2));
        end
    end

    % on column-by-row values
    reference_solutions.outer.(op) = cell(maxdim,maxdim);
    for d1 = 1:maxdim
        for d2 = 1:maxdim
            arg1 = reference_values.vector{1,d1};
            arg2 = reference_values.vector{2,d2}';
            
            reference_solutions.outer.(op){d1,d2} = multipoly2struct(feval(op,arg1,arg2));
        end
    end

    % on matrix values
    reference_solutions.matrix.(op) = cell(maxdim,maxdim);
    for d1 = 1:maxdim
        for d2 = 1:maxdim
            arg1 = reference_values.matrix{1,d1};
            arg2 = reference_values.matrix{3,d2};

            if ~isequal(op,"kron") && (size(arg1,2) ~= size(arg2,1))
                % dimension mismatch
                continue
            end

            reference_solutions.matrix.(op){d1,d2} = multipoly2struct(feval(op,arg1,arg2));
        end
    end
end

% left-side matrix division B\A
reference_solutions.scalar.mldivide = cell(noPoly,noPoly);
for k1 = 1:noPoly
    arg1 = reference_values.scalar{1,k1};

    vars = arg1.varname;
    reference_value_double = double(subs(arg1,vars,ones(size(vars))));

    for k2 = 1:noPoly
        arg2 = reference_values.scalar{2,k2};
        reference_solutions.scalar.mldivide{k1,k2} = multipoly2struct(mtimes(inv(reference_value_double),arg2));
    end
end

% right-side matrix division A/B
reference_solutions.scalar.mrdivide = cell(noPoly,noPoly);
for k2 = 1:noPoly
    arg2 = reference_values.scalar{2,k2};

    vars = arg2.varname;
    reference_value_double = double(subs(arg2,vars,ones(size(vars))));

    for k1 = 1:noPoly
        arg1 = reference_values.scalar{1,k1};
        reference_solutions.scalar.mrdivide{k1,k2} = multipoly2struct(mrdivide(arg1,reference_value_double));
    end
end

% matrix power with scalar exponents
reference_solutions.scalar.mpower = cell(noPoly,4);
for pow = (0:3)
    for k = 1:noPoly
        arg1 = reference_values.scalar{1,k};
        reference_solutions.scalar.mpower{k,pow+1} = multipoly2struct(mpower(arg1,pow));
    end
end

save("reference_mtimes.mat","test_values_struct","reference_solutions")

disp("Completed: mtimes operation");
disp(" ");

%% nabla
disp("========================================");
disp("Starting: nabla operation");
disp("========================================")

reference_solutions = struct('scalar',struct, ...
                             'column',struct, ...
                             'row',struct, ...
                             'matrix',struct ...
);

% nabla with respect to single variable (derivative)
reference_solutions.scalar.derivative = cell(noPoly,4);
reference_solutions.column.derivative = cell(maxdim,4);
reference_solutions.row.derivative = cell(maxdim,4);
reference_solutions.matrix.derivative = cell(maxdim,4);

for ivar = 1:4
    % on scalar values
    for k = 1:noPoly
        reference_solutions.scalar.derivative{k,ivar} = multipoly2struct(eval_nabla("single",reference_values.scalar{1,k},ivar));
    end

    % on column vector values
    for d = 1:maxdim
        reference_solutions.column.derivative{d,ivar} = multipoly2struct(eval_nabla("single",reference_values.vector{1,d},ivar));
    end

    % on row vector values
    for d = 1:maxdim
        reference_solutions.row.derivative{d,ivar} = multipoly2struct(eval_nabla("single",reference_values.vector{2,d}',ivar));
    end

    % on matrix values
    for d = 1:maxdim
        reference_solutions.matrix.derivative{d,ivar} = multipoly2struct(eval_nabla("single",reference_values.matrix{1,d},ivar));
    end
end

% nabla with respect to multiple variables (gradient)
reference_solutions.scalar.gradient = cell(noPoly,4);
reference_solutions.column.gradient = cell(maxdim,4);
reference_solutions.row.gradient = cell(maxdim,4);
reference_solutions.matrix.gradient = cell(maxdim,4);

for ivar = 1:4
    % on scalar values
    for k = 1:noPoly
        reference_solutions.scalar.gradient{k,ivar} = multipoly2struct(eval_nabla("multiple",reference_values.scalar{2,k},ivar));
    end

    % on column vector values
    for d = 1:maxdim
        reference_solutions.column.gradient{d,ivar} = multipoly2struct(eval_nabla("multiple",reference_values.vector{2,d},ivar));
    end

    % on row vector values
    for d = 1:maxdim
        reference_solutions.row.gradient{d,ivar} = multipoly2struct(eval_nabla("multiple",reference_values.vector{1,d}',ivar));
    end

    % on matrix values
    for d = 1:maxdim
        reference_solutions.matrix.gradient{d,ivar} = multipoly2struct(eval_nabla("multiple",reference_values.matrix{2,d},ivar));
    end
end

save("reference_nabla.mat","test_values_struct","reference_solutions")

disp("Completed: nabla operation");
disp(" ");

%% poly2basis
disp("========================================");
disp("Starting: poly2basis operation");
disp("========================================")

reference_solutions = struct;

reference_solutions.poly2basis = cell(noPoly,noPoly);
for k1 = 1:noPoly
    basis = monomials(reference_values{1,k1});
    for k2 = 1:noPoly
        reference_solutions.poly2basis{k1,k2} = poly2basis(reference_values{2,k2},basis);
    end
end

save("reference_poly2basis.mat","test_values_struct","reference_solutions")

disp("Completed: coordinates operation");
disp(" ");

%% remove_coeffs
disp("========================================");
disp("Starting: remove_coeffs operation");
disp("========================================")

reference_solutions = struct;

reference_solutions.remove_coeffs = cell(noPoly,3);
for decade = 1:3
    for k = 1:noPoly
        tol = prctile(coordinates(reference_values{k}),10*decade);
    
        reference_solutions.remove_coeffs{k,decade} = multipoly2struct(cleanpoly(reference_values{k}, tol));
    end
end

save("reference_remove_coeffs.mat","test_values_struct","reference_solutions")

disp("Completed: remove_coeffs operation");
disp(" ");

%% subs
disp("========================================");
disp("Starting: subs operation");
disp("========================================")

reference_solutions = struct;

% substitute single variable
reference_solutions.single = cell(noPoly,4);
for ivar = 1:4
    for k = 1:noPoly
        vars = reference_values{1,k}.varname;
        if ivar > length(vars)
            % variable not in polynomial
            var = {'y'};
        else
            var = vars(ivar);
        end

        reference_solutions.single{k,ivar} = multipoly2struct(subs(reference_values{1,k},var,reference_values{2,k}));
    end
end

% substitute multiple variables
reference_solutions.multiple = cell(noPoly,4);
for ivar = 1:4
    for k = 1:noPoly
        vars = reference_values{1,k}.varname;
        if ivar <= length(vars)
            % replace variable
            vars(ivar) = {'y'};
        end
        if k < noPoly/2
            new = vertcat(reference_values{2,k+(1:length(vars))});
        else
            new = vertcat(reference_values{2,(end-k)+(1:length(vars))});
        end

        reference_solutions.multiple{k,ivar} = multipoly2struct(subs(reference_values{1,k},vars,new));
    end
end

save("reference_subs.mat","test_values_struct","reference_solutions")

disp("Completed: subs operation");
disp(" ");

%% concat
disp("========================================");
disp("Starting: concat operation");
disp("========================================")

reference_solutions = struct;

% concatenate to m-by-n matrix
reference_solutions.concat = cell(2,5);
for dim1 = 1:5
    dim2 = 6-dim1;

    for k = 1:2
        args_to_vertcat = mat2cell(reference_values(k,1:(dim1*dim2)), 1, repmat(dim1,1,dim2));
        args_to_horzcat = cellfun(@(c) vertcat(c{:}), args_to_vertcat, 'UniformOutput', false);

        reference_solutions.concat{k,dim1} = multipoly2struct(horzcat(args_to_horzcat{:}));
    end
end

% horizontal concatenation
reference_solutions.horzcat = cell(1,4);
for dim1 = 1:4
    dim2 = 5-dim1;
    dim3 = 6-dim1;

    p1 = reshape([reference_values{1,1:(dim1*dim2)}],dim1,dim2);
    p2 = reshape([reference_values{2,1:(dim1*dim3)}],dim1,dim3);

    reference_solutions.horzcat{dim1} = multipoly2struct(horzcat(p1,p2));
end

% vertical concatenation
reference_solutions.vertcat = cell(1,4);
for dim3 = 1:4
    dim1 = 5-dim3;
    dim2 = 6-dim3;

    p1 = reshape([reference_values{1,1:(dim1*dim3)}],dim1,dim3);
    p2 = reshape([reference_values{2,1:(dim2*dim3)}],dim2,dim3);

    reference_solutions.vertcat{dim3} = multipoly2struct(vertcat(p1,p2));
end

% diagonal concatenation
reference_solutions.diagcat = cell(4,4);
for dim1 = 1:4
for dim3 = 1:4
    dim2 = 5-dim1;
    dim4 = 6-dim3;

    p1 = reshape([reference_values{1,1:(dim1*dim2)}],dim1,dim2);
    p2 = reshape([reference_values{2,1:(dim3*dim4)}],dim3,dim4);

    reference_solutions.diagcat{dim1,dim3} = multipoly2struct(blkdiag(p1,p2));
end
end

save("reference_concat.mat","test_values_struct","reference_solutions")

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
% save("reference_sum.mat","test_values_struct","reference_solutions")
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
% save("reference_transpose.mat","test_values_struct","reference_solutions")
% 
% disp("Completed: transpose operation");
% disp(" ");

%% Fini
disp("========================================");
disp("All reference values generated successfully!");
disp("========================================")
