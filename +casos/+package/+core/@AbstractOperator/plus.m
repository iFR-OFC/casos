% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function c = plus(a,b)
% Add two linear operators.

assert(isequal(size(a),size(b)),'Dimensions of operators mismatch.')

% join input nonzero coordinates
[Sin,I1in,I2in] = op_join(a.sparsity_in,b.sparsity_in);
% join output nonzero coordinates
[Sout,I1out,I2out] = op_join(a.sparsity_out,b.sparsity_out);

% size of resulting operator matrix
sz = [nnz(Sout) nnz(Sin)];

% expand matrices to joint nonzeros
A = expand(a.matrix,sz,I1in,I1out);
B = expand(b.matrix,sz,I2in,I2out);

% new operator
c = a.new_operator(A+B,Sin,Sout);

end
