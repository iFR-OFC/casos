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

noPoly = 10;

test_values_struct = cell(2,noPoly);
reference_values   = cell(2,noPoly);

for k = 1:noPoly
    [test_values_struct(:,k),reference_values(:,k)] = generateTestPolynomials();
end

save("test_values.mat","test_values_struct");

disp("Completed: Generate test polynomials");
disp(" ");

%% unary
disp("========================================");
disp("Starting: unary operation");
disp("========================================")

reference_solutions = struct;

% unary plus and minus
for op = ["uplus" "uminus"]
    reference_solutions.(op) = cell(noPoly,1);
    for k = 1:noPoly
       reference_solutions.(op){k} = multipoly2struct(feval(op,reference_values{k}));
    end
end

% element-wise power with scalar exponent
reference_solutions.power = cell(noPoly,3);
for pow = (2:4)
    for k = 1:noPoly
        reference_solutions.power{k,pow-1} = multipoly2struct(power(reference_values{k},pow));
    end
end

% unary operation on vector
reference_solutions.vector = struct;
for op = ["uplus" "uminus"]
    reference_solutions.vector.(op) = cell(1,5);
    for dim1 = 1:5
        dim2 = 6-dim1;
        value = reshape([reference_values{1:(dim1*dim2)}],dim1,dim2);
        reference_solutions.vector.(op){dim1} = multipoly2struct(feval(op,value));
    end
end

save("reference_unary.mat","test_values_struct","reference_solutions")

disp("Completed: unary operation");
disp(" ");

%% binary
disp("========================================");
disp("Starting: binary operation");
disp("========================================") 

reference_solutions = struct;

% element-wise addition, subtraction, multiplication
for op = ["plus" "minus" "times"]
    reference_solutions.(op) = cell(noPoly,noPoly);
    for k1 = 1:noPoly
        for k2 = 1:noPoly
            reference_solutions.(op){k1,k2} = multipoly2struct(feval(op,reference_values{1,k1},reference_values{2,k2}));
        end
    end
end

% left-side division B.\A
reference_solutions.ldivide = cell(noPoly,noPoly);
for k1 = 1:noPoly
    vars = reference_values{1,k1}.varname;
    reference_value_double = double(subs(reference_values{1,k1},vars,ones(size(vars))));

    for k2 = 1:noPoly
        reference_solutions.ldivide{k1,k2} = multipoly2struct(times(inv(reference_value_double),reference_values{2,k2}));
    end
end

% right-side division A./B
reference_solutions.rdivide = cell(noPoly,noPoly);
for k2 = 1:noPoly
    vars = reference_values{2,k2}.varname;
    reference_value_double = double(subs(reference_values{2,k2},vars,ones(size(vars))));

    for k1 = 1:noPoly
        reference_solutions.rdivide{k1,k2} = multipoly2struct(rdivide(reference_values{1,k1},reference_value_double));
    end
end

save("reference_binary.mat","test_values_struct","reference_solutions")

disp("Completed: binary operation");
disp(" ");

%% dot
disp("========================================");
disp("Starting: dot operation");
disp("========================================");

% dot product
reference_solutions.dot = cell(noPoly,noPoly);
for k1 = 1:noPoly
    basis = monomials(reference_values{1,k1});

    for k2 = 1:noPoly
       reference_solutions.dot{k1,k2} = full(dot(coordinates(reference_values{1,k1}), coordinates(reference_values{2,k2},basis)));
    end
end

save("reference_dot.mat","test_values_struct","reference_solutions")

disp("Completed: dot operation");
disp(" ");

%% mtimes
disp("========================================");
disp("Starting: mtimes operation");
disp("========================================")

reference_solutions = struct;

% matrix multiplication
reference_solutions.mtimes = cell(noPoly,noPoly);
for k1 = 1:noPoly
    for k2 = 1:noPoly
        reference_solutions.mtimes{k1,k2} = multipoly2struct(mtimes(reference_values{1,k1},reference_values{2,k2}));
    end
end

% Kronecker product
reference_solutions.kron = cell(noPoly,noPoly);
for k1 = 1:noPoly
    for k2 = 1:noPoly
        reference_solutions.kron{k1,k2} = multipoly2struct(kron(reference_values{1,k1},reference_values{2,k2}));
    end
end

% left-side matrix division B\A
reference_solutions.mldivide = cell(noPoly,noPoly);
for k1 = 1:noPoly
    vars = reference_values{1,k1}.varname;
    reference_value_double = double(subs(reference_values{1,k1},vars,ones(size(vars))));

    for k2 = 1:noPoly
        reference_solutions.mldivide{k1,k2} = multipoly2struct(mtimes(inv(reference_value_double),reference_values{2,k2}));
    end
end

% right-side matrix division A/B
reference_solutions.mrdivide = cell(noPoly,noPoly);
for k2 = 1:noPoly
    vars = reference_values{2,k2}.varname;
    reference_value_double = double(subs(reference_values{2,k2},vars,ones(size(vars))));

    for k1 = 1:noPoly
        reference_solutions.mrdivide{k1,k2} = multipoly2struct(mrdivide(reference_values{1,k1},reference_value_double));
    end
end

% matrix power with scalar exponents
reference_solutions.mpower = cell(noPoly,3);
for pow = (2:4)
    for k = 1:noPoly
        reference_solutions.mpower{k,pow-1} = multipoly2struct(mpower(reference_values{k},pow));
    end
end

save("reference_mtimes.mat","test_values_struct","reference_solutions")

disp("Completed: mtimes operation");
disp(" ");

%% nabla
disp("========================================");
disp("Starting: nabla operation");
disp("========================================")

reference_solutions = struct;

% nabla with respect to single variable (derivative)
reference_solutions.derivative = cell(noPoly,4);
for ivar = 1:4
    for k = 1:noPoly
        vars = reference_values{k}.varname;
        if ivar > length(vars)
            % variable not in polynomial
            var = {'y'};
        else
            var = vars(ivar);
        end

        reference_solutions.derivative{k,ivar} = multipoly2struct(jacobian(reference_values{k},var));
    end
end

% nabla with respect to multiple variables (gradient)
reference_solutions.gradient = cell(noPoly,4);
for ivar = 1:4
    for k = 1:noPoly
        vars = reference_values{k}.varname;
        if ivar <= length(vars)
            % replace variable
            vars(ivar) = {'y'};
        end

        reference_solutions.gradient{k,ivar} = multipoly2struct(jacobian(reference_values{k},vars));
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
