% SPDX-FileCopyrightText: 2024 Institute of Flight Mechanics and Controls, University of Stuttgart
% SPDX-FileCopyrightText: Author(s): Torbjørn Cunis <tcunis@ifr.uni-stuttgart.de>
% SPDX-FileContributor: For a full list of contributors, see <https://github.com/ifr-ofc/casos>
%
% Adapted from multipoly
% Source: <https://github.com/SOSAnalysis/multipoly/blob/a3d7c9ef55bebb08c38a5dcf8811c16d7e77f3a1/%40polynomial/plinearize.m>
% Version history:
% PJS 9/29/2009   Initial Coding
% PJS 10/05/2009  Update for linearizing f(x,u)
%
% SPDX-License-Identifier: GPL-3.0-only

function [A,B,f0] = plinearize(f,x,u,x0,u0)
% Linearize polynomial function.

Nx = length(x);
Nu = length(u);

% Error Checking
if nargin==2
    %   [A,f0] = plinearize(f,x)
    u = [];
    x0 = [];
    u0 = [];
elseif nargin==3

        x0 = [];
        u0 = [];        

elseif nargin==4
    %   [A,B,f0] = plinearize(f,x,u,x0)
    u0 = [];
end

% Default trim values
if isempty(x0)
    x0 = zeros(Nx,1);
end
if isempty(u0)
    u0 = zeros(Nu,1);
end
   
% Evaluate function at trim
f0 = double(subs(f,[x;u],[x0(:); u0(:)]));

% State matrix 
fx = nabla(f,x);

% check if any state is member of A matrix; if yes evaluate it at trim point; 
% otherwise convert to double
if any(ismember(fx.indeterminates.str,x.str))

    A = double(subs(fx,x,x0));

else
    A = double(fx);
end

% Control matrix
if ~isempty(u)
    fu = nabla(f,u);
    
    % check if any control is member of B matrix; if yes 
    % evaluate it at trim point; otherwise convert to double
    if any(ismember(fu.indeterminates.str,u.str))
      
        B = double(subs(fu,u,u0));

    else
        B = double(fu);
    end
else
    B = [];
end


end