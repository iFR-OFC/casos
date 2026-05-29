% SPDX-FileCopyrightText: 2023 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

function sol = conicInternal(name,solver,conic,varargin)
% Internal interface for conic (SDP) solvers.
        
switch lower(solver)
    case 'sedumi'
        % solve conic problem using SeDuMi
        sol = casos.package.solvers.SedumiInterface(name,conic,varargin{:});

    case 'mosek'
        % solve conic problem using MOSEK
        sol = casos.package.solvers.MosekInterface(name,conic,varargin{:});

    case 'scs'
        % solve conic problem using SCS
        sol = casos.package.solvers.SCSInterface(name,conic,varargin{:});

    case 'clarabel'
        % solve conic problem using Clarabel
        sol = casos.package.solvers.ClarabelInterface(name,conic,varargin{:});
        
    otherwise
        % fall back to CasADi conic interface
        sol = casadi.conic(name,solver,conic, varargin{:});
end

end
