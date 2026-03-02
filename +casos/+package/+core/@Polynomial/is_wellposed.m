% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function tf = is_wellposed(obj)
% Check if polynomial is well posed.

tf = is_wellposed@casos.package.core.GenericPolynomial(obj) ... check sparsity
    && is_equal(sparsity(obj.coeffs), coeff_sparsity(obj.get_sparsity));

end
