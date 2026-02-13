%% Generate test polynomials for both multipoly and casos
disp('========================================');
disp('Starting: Generate test polynomials');
disp('========================================');

testValue_str = [];
refValue = [];

noPoly = 25;

for k = 1:noPoly
    [testValuek_str,refValuek] = genTestPoly();
    testValue_str = [testValue_str; testValuek_str];
    refValue  = [refValue; refValuek];
end

disp('Completed: Generate test polynomials');
disp(' ');

%% dot
disp('========================================');
disp('Starting: dot operation');
disp('========================================');
 refValue_flat = [];
 for k = 1:noPoly
       refValue_flat = [refValue_flat; refValue(k)]; 
 end
 
 refSolution = struct();
 refSolution.single = cell(1,1);
 refSolution.single{1} = full(dot( poly2basis(refValue_flat(1)), poly2basis(refValue_flat(1)) ));
 
 refSolution.multiple = cell(noPoly,1);
 for k = 1:noPoly
       refSolution.multiple{k} = full(dot( poly2basis(refValue_flat(k)), poly2basis(refValue_flat(k)) ));
 end
 
 currentpath = pwd;
cd refSolutions/
save('refSolution_multipoly_dot.mat',"testValue_str","refSolution")
cd ../

disp('Completed: dot operation');
disp(' ');

%% kron
disp('========================================');
disp('Starting: kron operation');
disp('========================================')
 refValue = reshape(refValue,2,noPoly);
 refSolution = struct();
 refSolution.single = cell(1,1);
 refSolution.single{1} = full(poly2basis(kron( refValue(1,1), refValue(2,1) )));
 
 refSolution.multiple = cell(noPoly,1);
 for k = 1:noPoly
       refSolution.multiple{k} = full(poly2basis(kron( refValue(1,k), refValue(2,k) )));
 end
cd refSolutions/
save('refSolution_multipoly_kron.mat',"testValue_str","refSolution")
cd ../

disp('Completed: kron operation');
disp(' ');

%% mpower (flatten refValue back to 1D for subsequent operations)
disp('========================================');
disp('Starting: mpower operation');
disp('========================================')
 refValue = refValue(:);
 refSolution = struct();
 
 % Test cases for different powers (2 through 4)
 powers = 2;
 caseNames = {'case_A', 'case_B', 'case_C'};
 
 for idx = 1:length(powers)
     caseName = caseNames{idx};
     power = powers(idx);
     refSolution.(caseName) = cell(noPoly,1);
     for k = 1:noPoly
         refSolution.(caseName){k} = full(poly2basis(mpower(refValue(k), power)));
     end
 end
 
 currentpath = pwd;
cd refSolutions/
save('refSolution_multipoly_mpower.mat',"testValue_str","refSolution")
cd ../

disp('Completed: mpower operation');
disp(' ');

%% mrdivide
disp('========================================');
disp('Starting: mrdivide operation');
disp('========================================')
 refSolution = struct();
 refSolution.single = cell(1,1);
 refSolution.single{1} = full(poly2basis(mrdivide(refValue(1),2)));
 
 refSolution.multiple = cell(noPoly,1);
 for k = 1:noPoly
       refSolution.multiple{k} = full(poly2basis(mrdivide(refValue(k),2)));
 end
 currentpath = pwd;
cd refSolutions/
save('refSolution_multipoly_mrdivide.mat',"testValue_str","refSolution")
cd ../

disp('Completed: mrdivide operation');
disp(' ');

%% mtimes
disp('========================================');
disp('Starting: mtimes operation');
disp('========================================')
 refValue = reshape(refValue,2,noPoly);
 refSolution = struct();
 refSolution.single = cell(1,1);
 refSolution.single{1} = full(poly2basis(mtimes( refValue(1,1), refValue(2,1) )));
 
 refSolution.multiple = cell(noPoly,1);
 for k = 1:noPoly
       refSolution.multiple{k} = full(poly2basis(mtimes( refValue(1,k), refValue(2,k) )));
 end
cd refSolutions/
save('refSolution_multipoly_mtimes.mat',"testValue_str","refSolution")
cd ../

disp('Completed: mtimes operation');
disp(' ');

%% nabla (flatten refValue back for nabla)
disp('========================================');
disp('Starting: nabla operation');
disp('========================================')
 refValue = refValue(:);
 refSolution = struct();
 refSolution.single = cell(1,1);
 refSolution.single{1} = full(poly2basis(jacobian(refValue(1), mpvar('x',refValue(1).nvars,1))));
 
 refSolution.multiple = cell(noPoly,1);
 for k = 1:noPoly
       refSolution.multiple{k} = full(poly2basis(jacobian(refValue(k), mpvar('x',refValue(k).nvars,1))));
 end
 currentpath = pwd;
cd refSolutions/
save('refSolution_multipoly_nabla.mat',"testValue_str","refSolution")
cd ../

disp('Completed: nabla operation');
disp(' ');

%% plus
disp('========================================');
disp('Starting: plus operation');
disp('========================================') 
 % Build flat arrays matching the testValue structure
 refValue_flat = [];
 for k = 1:noPoly
       refValue_flat = [refValue_flat; refValue(k)]; 
 end
 
 refSolution = struct();
 
 % Test case A: constant + constant (5 + 5)
 refSolution.case_A = cell(1,1);
 refSolution.case_A{1} = 10;
 
 % Test case B: single polynomial + constant (testValue(1) + 3)
 refSolution.case_B = cell(noPoly*2,1);
 idx = 1;
 for k = 1:noPoly
       refSolution.case_B{idx} = full(poly2basis( plus(refValue(k), 3)));
       idx = idx + 1;
 end
 
 % Test case C: n polynomials + constant (testValue(1:10) + 4)
 refSolution.case_C = cell(10,1);
 for k = 1:10
       refSolution.case_C{k} = full(poly2basis( plus(refValue_flat(k), 4)));
 end
 
 % Test case D: constant + single polynomial (4 + testValue(1))
 refSolution.case_D = cell(noPoly*2,1);
 idx = 1;
 for k = 1:noPoly
       refSolution.case_D{idx} = full(poly2basis( plus(4, refValue(k))));
       idx = idx + 1;
 end
 
 % Test case E: single polynomial + single polynomial (testValue(1) + testValue(2))
 refSolution.case_E = cell(noPoly*2,1);
 idx = 1;
 for k = 1:noPoly
       refSolution.case_E{idx} = full(poly2basis( plus(refValue_flat(1), refValue_flat(2))));
       idx = idx + 1;
 end
 
 % Test case F: n polynomials + single polynomial (testValue(1:10) + testValue(1))
 refSolution.case_F = cell(10,1);
 for k = 1:10
       refSolution.case_F{k} = full(poly2basis( plus(refValue_flat(k), refValue_flat(1))));
 end
 
 % Test case G: constant + n polynomials (5 + testValue(1:10))
 refSolution.case_G = cell(10,1);
 for k = 1:10
       refSolution.case_G{k} = full(poly2basis( plus(5, refValue_flat(k))));
 end
 
 % Test case H: single polynomial + n polynomials (testValue(1) + testValue(1:10))
 refSolution.case_H = cell(10,1);
 for k = 1:10
       refSolution.case_H{k} = full(poly2basis( plus(refValue_flat(1), refValue_flat(k))));
 end
 
 % Test case I: n polynomials + n polynomials (testValue(1:10) + testValue(11:20))
 refSolution.case_I = cell(10,1);
 for k = 1:10
       refSolution.case_I{k} = full(poly2basis( plus(refValue_flat(k), refValue_flat(k+10))));
 end

 currentpath = pwd;
cd refSolutions/
save('refSolution_multipoly_plus.mat',"testValue_str","refSolution")
cd ../

disp('Completed: plus operation');
disp(' ');

%% times
disp('========================================');
disp('Starting: times operation');
disp('========================================')
 refValue = reshape(refValue,2*noPoly,1);
 refSolution = struct();
 refSolution.single = cell(1,1);
 refSolution.single{1} = full(poly2basis(times(refValue(1), refValue(2))));
 
 refSolution.multiple = cell(10,1);
 for k = 1:10
       refSolution.multiple{k} = full(poly2basis(times(refValue(k), refValue(k+10))));
 end
cd refSolutions/
save('refSolution_multipoly_times.mat',"testValue_str","refSolution")
cd ../

disp('Completed: times operation');
disp(' ');

%% power
disp('========================================');
disp('Starting: power operation');
disp('========================================')
 refValue = refValue(:);
 refSolution = struct();
 refSolution.single = cell(1,1);
 refSolution.single{1} = full(poly2basis(power(refValue(1), 3)));
cd refSolutions/
save('refSolution_multipoly_power.mat',"testValue_str","refSolution")
cd ../

disp('Completed: power operation');
disp(' ');

%% prod
disp('========================================');
disp('Starting: prod operation');
disp('========================================')
 refSolution = struct();
 refSolution.single = cell(1,1);
 refSolution.single{1} = full(poly2basis(prod(refValue(1), 1)));
 
 refSolution.multiple = cell(10,1);
 for k = 1:10
       refSolution.multiple{k} = full(poly2basis(prod(refValue(k), 2)));
 end
cd refSolutions/
save('refSolution_multipoly_prod.mat',"testValue_str","refSolution")
cd ../

disp('Completed: prod operation');
disp(' ');

%% poly2basis
disp('========================================');
disp('Starting: poly2basis operation');
disp('========================================')
 refSolution = struct();
 refSolution.single = cell(1,1);
 refSolution.single{1} = full(poly2basis(refValue(1)));
 
 refSolution.multiple = cell(noPoly,1);
 for k = 1:noPoly
       refSolution.multiple{k} = full(poly2basis(refValue(k)));
 end
cd refSolutions/
save('refSolution_multipoly_poly2basis.mat',"testValue_str","refSolution")
cd ../

disp('Completed: poly2basis operation');
disp(' ');

%% rdivide
disp('========================================');
disp('Starting: rdivide operation');
disp('========================================')
 refSolution = struct();
 refSolution.single = cell(1,1);
 refSolution.single{1} = full(poly2basis(rdivide(refValue(1), 2)));
 
 refSolution.multiple = cell(10,1);
 for k = 1:10
       refSolution.multiple{k} = full(poly2basis(rdivide(refValue(k), 3)));
 end
cd refSolutions/
save('refSolution_multipoly_rdivide.mat',"testValue_str","refSolution")
cd ../

disp('Completed: rdivide operation');
disp(' ');

%% sum
disp('========================================');
disp('Starting: sum operation');
disp('========================================')
 refSolution = struct();
 refSolution.single = cell(1,1);
 refSolution.single{1} = full(poly2basis(sum(refValue(1), 2)));
 
 refSolution.multiple = cell(10,1);
 for k = 1:10
       refSolution.multiple{k} = full(poly2basis(sum(refValue(k), 1)));
 end
cd refSolutions/
save('refSolution_multipoly_sum.mat',"testValue_str","refSolution")
cd ../

disp('Completed: sum operation');
disp(' ');

%% transpose
disp('========================================');
disp('Starting: transpose operation');
disp('========================================')
 refSolution = struct();
 refSolution.single = cell(1,1);
 refSolution.single{1} = full(poly2basis(transpose(refValue(1))));
 
 refSolution.multiple = cell(10,1);
 for k = 1:10
       refSolution.multiple{k} = full(poly2basis(transpose(refValue(k))));
 end
cd refSolutions/
save('refSolution_multipoly_transpose.mat',"testValue_str","refSolution")
cd ../

disp('Completed: transpose operation');
disp(' ');

%% remove_coeffs
disp('========================================');
disp('Starting: remove_coeffs operation');
disp('========================================')
 refSolution = struct();
 refSolution.single = cell(1,1);
 refSolution.single{1} = full(poly2basis(cleanpoly(refValue(1), 1e-3)));
 
 refSolution.multiple = cell(10,1);
 for k = 1:10
       refSolution.multiple{k} = full(poly2basis(cleanpoly(refValue(k), 1e-1)));
 end
cd refSolutions/
save('refSolution_multipoly_remove_coeffs.mat',"testValue_str","refSolution")
cd ../

disp('Completed: remove_coeffs operation');
disp(' ');

%% subs
disp('========================================');
disp('Starting: subs operation');
disp('========================================')
 refSolution = struct();
 refSolution.single = cell(1,1);
 refSolution.single{1} = full(poly2basis(subs(refValue(1), mpvar('x',refValue(1).nvars,1), ones(refValue(1).nvars,1))));
cd refSolutions/
save('refSolution_multipoly_subs.mat',"testValue_str","refSolution")
cd ../

disp('Completed: subs operation');
disp(' ');
disp('========================================');
disp('All reference values generated successfully!');
disp('========================================')
