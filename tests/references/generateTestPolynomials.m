% SPDX-FileCopyrightText: 2026 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis and Jan Olucak <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function [test_value,reference_value] = generateTestPolynomials()
% Generate test polynomials from CaΣoS and Multipoly

lower = 1;
upper = 4;

m    = ceil(lower + (upper-lower)*rand());  % number of indeterminates

deg  = 0:ceil(lower + (upper-lower)*rand()); % degree of first polynomial
deg2 = 1:ceil(lower + (upper-lower)*rand());   % degree of second polynomial

% generate casos monomial vector
x   = casos.Indeterminates('x',m,1);
sp1 = monomials(x,deg);
sp2 = monomials(x,deg2);

% generate random coefficients
coeffs1 = rand(sp1.nnz,1)';
coeffs2 = rand(sp2.nnz,1)';
    
% build polynomials
poly1 = casos.PD(sp1,coeffs1);
poly2 = casos.PD(sp2,coeffs2);

% return test values as structs
test_value.nIndet  = m;
test_value.deg     = deg;
test_value.deg2    = deg2;
test_value.coeffs1 = coeffs1;
test_value.coeffs2 = coeffs2;

% convert to multipoly for reference
poly1_mltp = casos.toolboxes.to_multipoly(poly1);
poly2_mltp = casos.toolboxes.to_multipoly(poly2);

% return reference values
reference_value = {poly1_mltp poly2_mltp};

end
