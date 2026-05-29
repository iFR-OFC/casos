% SPDX-FileCopyrightText: 2025 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function Z = gramunit(w)
% Return a Gram unit basis for a given monomial sparsity pattern.

Z = casos.Sparsity(w);
% double the exponents of each monomial
Z.degmat = 2*w.degmat;

end
