% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Jan Olucak <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function [test_value,reference_value] = generateTestPolynomials(sz,variables,degmax)
% Generate test polynomials from CaΣoS and Multipoly

sp1 = generateRandomSparsity(sz,variables,degmax);
sp2 = generateRandomSparsity(sz,variables,degmax);

% generate random coefficients
coeffs1 = rand(1,sp1.nnz);
coeffs2 = rand(1,sp2.nnz);
    
% build polynomials
poly1 = casos.PD(sp1,coeffs1);
poly2 = casos.PD(sp2,coeffs2);

% return test values as structs
arg1.sz = size(poly1);
[arg1.i,arg1.j,arg1.degrees] = get_tuplet(sparsity(poly1));
arg1.indets = str(poly1.indeterminates);
arg1.coeffs = coeffs1;

arg2.sz = size(poly2);
[arg2.i,arg2.j,arg2.degrees] = get_tuplet(sparsity(poly2));
arg2.indets = str(poly2.indeterminates);
arg2.coeffs = coeffs2;

test_value = {arg1 arg2};

% convert to multipoly for reference
poly1_mltp = casos.toolboxes.to_multipoly(poly1);
poly2_mltp = casos.toolboxes.to_multipoly(poly2);

% return reference values
reference_value = {poly1_mltp poly2_mltp};

end
