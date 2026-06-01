% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% SPDX-License-Identifier: GPL-3.0-only

classdef IncompatibleSizesError < MException
% Error thrown if inputs have compatible sizes for an operation.

methods (Access=protected)
    function err = IncompatibleSizesError(id,msg,a,b)
        % New error with identifier.
        err@MException(id,msg,size2str(a),size2str(b));
    end
end

methods (Static)
    function err = basic(a,b)
        % New error for basic operation.
        err = casos.package.core.IncompatibleSizesError('MATLAB:sizeDimensionsMustMatch', ...
                'Polynomials have incompatible sizes for this operation: [%s] vs. [%s].',a,b);
    end

    function err = concat(a,b)
        % New error for concatenation.
        err = casos.package.core.IncompatibleSizesError('MATLAB:catenate:dimensionMismatch', ...
                'Dimensions of polynomials being concatenated are not consistent: [%s] vs. [%s].',a,b);
    end

    function err = matrix(a,b)
        % New error for matrix operation.
        err = casos.package.core.IncompatibleSizesError('MATLAB:innerdim', ...
                'Incorrect dimensions for polynomial matrix multiplication: [%s] vs. [%s].',a,b);
    end

    function err = other(a,b)
        % New error for other operations.
        err = casos.package.core.IncompatibleSizesError('', ...
                'Polynomial dimension mismatch: [%s] vs. [%s].',a,b);
    end
end

end

function str = size2str(obj)
    % Convert array size to string.
    str = sprintf('%dx%d', size(obj,1), size(obj,2));
end
