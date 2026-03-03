% Generate reference solutions from multipoly
disp('========================================');
disp('Starting: Generate test polynomials');
disp('========================================');

noPoly = 25;

test_values_struct = cell(1,noPoly);
reference_values   = cell(2,noPoly);

for k = 1:noPoly
    [test_values_struct{k},reference_values(:,k)] = generateTestPolynomials();
end

save('test_values.mat',"test_values_struct");

disp('Completed: Generate test polynomials');
disp(' ');

%% dot
disp('========================================');
disp('Starting: dot operation');
disp('========================================');

reference_values_flat = cell(noPoly,1);
for k = 1:noPoly
   reference_values_flat{k} = reference_values{1,k};
end

basis = monomials(reference_values_flat{1});

reference_solutions = struct;
reference_solutions.single = cell(1,1);
reference_solutions.single{1} = full(dot(poly2basis(reference_values_flat{1}), poly2basis(reference_values_flat{1})));

reference_solutions.multiple = cell(1,noPoly);
for k = 1:noPoly
   reference_solutions.multiple{k} = full(dot(poly2basis(reference_values_flat{1}), poly2basis(reference_values_flat{k},basis)));
end

save('reference_dot.mat',"test_values_struct","reference_solutions")

disp('Completed: dot operation');
disp(' ');

%% kron
disp('========================================');
disp('Starting: kron operation');
disp('========================================')

reference_solutions = struct;
reference_solutions.single = cell(1,1);
reference_solutions.single{1} = full(poly2basis(kron(reference_values{1,1}, reference_values{2,1})));

reference_solutions.multiple = cell(1,noPoly);
for k = 1:noPoly
   reference_solutions.multiple{k} = full(poly2basis(kron(reference_values{1,k}, reference_values{2,k})));
end

save('reference_kron.mat',"test_values_struct","reference_solutions")

disp('Completed: kron operation');
disp(' ');

%% mpower
disp('========================================');
disp('Starting: mpower operation');
disp('========================================')
 
% Test cases for different powers (2 through 4)
powers = 2;
caseNames = {'case_A', 'case_B', 'case_C'};

for idx = 1:length(powers)
    caseName = caseNames{idx};
    powerVal = powers(idx);
    reference_solutions.(caseName) = cell(noPoly,1);
    for k = 1:noPoly
        reference_solutions.(caseName){k} = full(poly2basis(mpower(reference_values_flat{k}, powerVal)));
    end
end

save('reference_mpower.mat',"test_values_struct","reference_solutions")

disp('Completed: mpower operation');
disp(' ');

%% mrdivide
disp('========================================');
disp('Starting: mrdivide operation');
disp('========================================')

reference_solutions = struct;
reference_solutions.single = cell(1,1);
reference_solutions.single{1} = full(poly2basis(mrdivide(reference_values_flat{1},2)));

reference_solutions.multiple = cell(noPoly,1);
for k = 1:noPoly
   reference_solutions.multiple{k} = full(poly2basis(mrdivide(reference_values_flat{k},2)));
end

save('reference_mrdivide.mat',"test_values_struct","reference_solutions")

disp('Completed: mrdivide operation');
disp(' ');

%% mtimes
disp('========================================');
disp('Starting: mtimes operation');
disp('========================================')

reference_solutions = struct;
reference_solutions.single = cell(1,1);
reference_solutions.single{1} = full(poly2basis(mtimes(reference_values{1,1}, reference_values{2,1})));

reference_solutions.multiple = cell(noPoly,1);
for k = 1:noPoly
   reference_solutions.multiple{k} = full(poly2basis(mtimes(reference_values{1,k}, reference_values{2,k})));
end

save('reference_mtimes.mat',"test_values_struct","reference_solutions")

disp('Completed: mtimes operation');
disp(' ');

%% nabla
disp('========================================');
disp('Starting: nabla operation');
disp('========================================')

reference_solutions = struct;
reference_solutions.single = cell(1,1);
reference_solutions.single{1} = full(poly2basis(jacobian(reference_values_flat{1}, mpvar('x',reference_values{1}.nvars,1))));

reference_solutions.multiple = cell(noPoly,1);
for k = 1:noPoly
   reference_solutions.multiple{k} = full(poly2basis(jacobian(reference_values_flat{k}, mpvar('x',reference_values_flat{k}.nvars,1))));
end

save('reference_nabla.mat',"test_values_struct","reference_solutions")

disp('Completed: nabla operation');
disp(' ');

%% plus
disp('========================================');
disp('Starting: plus operation');
disp('========================================') 

reference_solutions = struct;

% Test case A: constant + constant (5 + 5)
reference_solutions.case_A = cell(1,1);
reference_solutions.case_A{1} = 10;

% Test case B: single polynomial + constant (testValue(1) + 3)
reference_solutions.case_B = cell(2*noPoly,1);
idx = 1;
for k = 1:noPoly
   reference_solutions.case_B{idx} = full(poly2basis(plus(reference_values_flat{k}, 3)));
   idx = idx + 1;
end

% Test case C: n polynomials + constant (testValue(1:10) + 4)
reference_solutions.case_C = cell(10,1);
for k = 1:10
   reference_solutions.case_C{k} = full(poly2basis(plus(reference_values_flat{k}, 4)));
end

% Test case D: constant + single polynomial (4 + testValue(1))
reference_solutions.case_D = cell(2*noPoly,1);
idx = 1;
for k = 1:noPoly
   reference_solutions.case_D{idx} = full(poly2basis(plus(4, reference_values_flat{k})));
   idx = idx + 1;
end
 
% Test case E: single polynomial + single polynomial (testValue(1) + testValue(2))
reference_solutions.case_E = cell(2*noPoly,1);
idx = 1;
for k = 1:noPoly
   reference_solutions.case_E{idx} = full(poly2basis(plus(reference_values_flat{k}, reference_values_flat{end-k+1})));
   idx = idx + 1;
end

% Test case F: n polynomials + single polynomial (testValue(1:10) + testValue(1))
reference_solutions.case_F = cell(10,1);
for k = 1:10
   reference_solutions.case_F{k} = full(poly2basis(plus(reference_values_flat{k}, reference_values_flat{1})));
end

% Test case G: constant + n polynomials (5 + testValue(1:10))
reference_solutions.case_G = cell(10,1);
for k = 1:10
   reference_solutions.case_G{k} = full(poly2basis(plus(5, reference_values_flat{k})));
end

% Test case H: single polynomial + n polynomials (testValue(1) + testValue(1:10))
reference_solutions.case_H = cell(10,1);
for k = 1:10
   reference_solutions.case_H{k} = full(poly2basis(plus(reference_values_flat{1}, reference_values_flat{k})));
end

% Test case I: n polynomials + n polynomials (testValue(1:10) + testValue(11:20))
reference_solutions.case_I = cell(10,1);
for k = 1:10
   reference_solutions.case_I{k} = full(poly2basis(plus(reference_values_flat{k}, reference_values_flat{k+10})));
end

save('reference_plus.mat',"test_values_struct","reference_solutions")

disp('Completed: plus operation');
disp(' ');

%% minus
disp('========================================');
disp('Starting: minus operation');
disp('========================================')

reference_solutions = struct;

% Test case A: constant - constant (5 - 5)
reference_solutions.case_A = cell(1,1);
reference_solutions.case_A{1} = 0;

% Test case B: single polynomial - constant (testValue(1) - 3)
reference_solutions.case_B = cell(2*noPoly,1);
idx = 1;
for k = 1:noPoly
   reference_solutions.case_B{idx} = full(poly2basis(minus(reference_values_flat{k}, 3)));
   idx = idx + 1;
end

% Test case C: n polynomials - constant (testValue(1:10) - 4)
reference_solutions.case_C = cell(10,1);
for k = 1:10
   reference_solutions.case_C{k} = full(poly2basis(minus(reference_values_flat{k}, 4)));
end

% Test case D: constant - single polynomial (4 - testValue(1))
reference_solutions.case_D = cell(2*noPoly,1);
idx = 1;
for k = 1:noPoly
   reference_solutions.case_D{idx} = full(poly2basis(minus(4, reference_values_flat{k})));
   idx = idx + 1;
end

% Test case E: single polynomial - single polynomial (testValue(1) - testValue(2))
reference_solutions.case_E = cell(2*noPoly,1);
idx = 1;
for k = 1:noPoly
   reference_solutions.case_E{idx} = full(poly2basis(minus(reference_values_flat{k}, reference_values_flat{end-k+1})));
   idx = idx + 1;
end

% Test case F: n polynomials - single polynomial (testValue(1:10) - testValue(1))
reference_solutions.case_F = cell(10,1);
for k = 1:10
   reference_solutions.case_F{k} = full(poly2basis( minus(reference_values_flat{k}, reference_values_flat{1})));
end

% Test case G: constant - n polynomials (5 - testValue(1:10))
reference_solutions.case_G = cell(10,1);
for k = 1:10
   reference_solutions.case_G{k} = full(poly2basis(minus(5, reference_values_flat{k})));
end

% Test case H: single polynomial - n polynomials (testValue(1) - testValue(1:10))
reference_solutions.case_H = cell(10,1);
for k = 1:10
   reference_solutions.case_H{k} = full(poly2basis(minus(reference_values_flat{1}, reference_values_flat{k})));
end

% Test case I: n polynomials - n polynomials (testValue(1:10) - testValue(11:20))
reference_solutions.case_I = cell(10,1);
for k = 1:10
 reference_solutions.case_I{k} = full(poly2basis(minus(reference_values_flat{k}, reference_values_flat{k+10})));
end

save('reference_minus.mat',"test_values_struct","reference_solutions")

disp('Completed: minus operation');
disp(' ');

%% uminus
disp('========================================');
disp('Starting: uminus operation');
disp('========================================')

reference_solutions = struct;
reference_solutions.single = cell(1,1);
reference_solutions.single{1} = full(poly2basis(uminus(reference_values_flat{1})));

reference_solutions.multiple = cell(10,1);
for k = 1:10
   reference_solutions.multiple{k} = full(poly2basis(uminus(reference_values_flat{k})));
end

save('reference_uminus.mat',"test_values_struct","reference_solutions")

disp('Completed: uminus operation');
disp(' ');

%% uplus
disp('========================================');
disp('Starting: uplus operation');
disp('========================================')

reference_solutions = struct;
reference_solutions.single = cell(1,1);
reference_solutions.single{1} = full(poly2basis(uplus(reference_values_flat{1})));

reference_solutions.multiple = cell(10,1);
for k = 1:10
   reference_solutions.multiple{k} = full(poly2basis(uplus(reference_values_flat{k})));
end

save('reference_uplus.mat',"test_values_struct","reference_solutions")

disp('Completed: uplus operation');
disp(' ');

%% times
disp('========================================');
disp('Starting: times operation');
disp('========================================')

reference_solutions = struct;
reference_solutions.single = cell(1,1);
reference_solutions.single{1} = full(poly2basis(times(reference_values_flat{1}, reference_values_flat{2})));

reference_solutions.multiple = cell(10,1);
for k = 1:10
   reference_solutions.multiple{k} = full(poly2basis(times(reference_values_flat{k}, reference_values_flat{k+10})));
end

save('reference_times.mat',"test_values_struct","reference_solutions")

disp('Completed: times operation');
disp(' ');

%% power
disp('========================================');
disp('Starting: power operation');
disp('========================================')

reference_solutions = struct;
reference_solutions.single = cell(1,1);
reference_solutions.single{1} = full(poly2basis(power(reference_values_flat{1}, 3)));

save('reference_power.mat',"test_values_struct","reference_solutions")

disp('Completed: power operation');
disp(' ');

%% prod
disp('========================================');
disp('Starting: prod operation');
disp('========================================')

reference_solutions = struct;
reference_solutions.single = cell(1,1);
reference_solutions.single{1} = full(poly2basis(prod(reference_values_flat{1}, 1)));

reference_solutions.multiple = cell(10,1);
for k = 1:10
   reference_solutions.multiple{k} = full(poly2basis(prod(reference_values_flat{k}, 2)));
end

save('reference_prod.mat',"test_values_struct","reference_solutions")

disp('Completed: prod operation');
disp(' ');

%% poly2basis
disp('========================================');
disp('Starting: poly2basis operation');
disp('========================================')

reference_solutions = struct;
reference_solutions.single = cell(1,1);
reference_solutions.single{1} = full(poly2basis(reference_values_flat{1}));

reference_solutions.multiple = cell(noPoly,1);
for k = 1:noPoly
   reference_solutions.multiple{k} = full(poly2basis(reference_values_flat{k}));
end

save('reference_poly2basis.mat',"test_values_struct","reference_solutions")

disp('Completed: poly2basis operation');
disp(' ');

%% rdivide
disp('========================================');
disp('Starting: rdivide operation');
disp('========================================')

reference_solutions = struct;
reference_solutions.single = cell(1,1);
reference_solutions.single{1} = full(poly2basis(rdivide(reference_values_flat{1}, 2)));

reference_solutions.multiple = cell(10,1);
for k = 1:10
   reference_solutions.multiple{k} = full(poly2basis(rdivide(reference_values_flat{k}, 3)));
end

save('reference_rdivide.mat',"test_values_struct","reference_solutions")

disp('Completed: rdivide operation');
disp(' ');

%% sum
disp('========================================');
disp('Starting: sum operation');
disp('========================================')

reference_solutions = struct;
reference_solutions.single = cell(1,1);
reference_solutions.single{1} = full(poly2basis(sum(reference_values_flat{1}, 2)));

reference_solutions.multiple = cell(10,1);
for k = 1:10
   reference_solutions.multiple{k} = full(poly2basis(sum(reference_values_flat{k}, 1)));
end

save('reference_sum.mat',"test_values_struct","reference_solutions")

disp('Completed: sum operation');
disp(' ');

%% transpose
disp('========================================');
disp('Starting: transpose operation');
disp('========================================')

reference_solutions = struct;
reference_solutions.single = cell(1,1);
reference_solutions.single{1} = full(poly2basis(transpose(reference_values_flat{1})));

reference_solutions.multiple = cell(10,1);
for k = 1:10
   reference_solutions.multiple{k} = full(poly2basis(transpose(reference_values_flat{k})));
end

save('reference_transpose.mat',"test_values_struct","reference_solutions")

disp('Completed: transpose operation');
disp(' ');

%% remove_coeffs
disp('========================================');
disp('Starting: remove_coeffs operation');
disp('========================================')

reference_solutions = struct;
reference_solutions.single = cell(1,1);
reference_solutions.single{1} = full(poly2basis(cleanpoly(reference_values_flat{1}, 1e-3)));

reference_solutions.multiple = cell(10,1);
for k = 1:10
   reference_solutions.multiple{k} = full(poly2basis(cleanpoly(reference_values_flat{k}, 1e-1)));
end

save('reference_remove_coeffs.mat',"test_values_struct","reference_solutions")

disp('Completed: remove_coeffs operation');
disp(' ');

%% subs
disp('========================================');
disp('Starting: subs operation');
disp('========================================')

reference_solutions = struct;
reference_solutions.single = cell(1,1);
reference_solutions.single{1} = full(poly2basis(subs(reference_values_flat{1}, mpvar('x',reference_values_flat{1}.nvars,1), ones(reference_values_flat{1}.nvars,1))));

save('reference_subs.mat',"test_values_struct","reference_solutions")

disp('Completed: subs operation');
disp(' ');
disp('========================================');
disp('All reference values generated successfully!');
disp('========================================')
