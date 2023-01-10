% Rao Technique for Nozzle Design

clc
clear

% y' = Px' + Q + (Sx' + T)^ (1/2)
% y' = radial distance to the wall from point N
% x' = axial distance from point N
% 4 unknowns (P,Q,S, and T) and 4 boundary conditions
% 1: At N: X'N = 0 and Y'N = 0
% 2: At e: X'e = Xe - XN = L - XN and Y'e = ye - yN = (eps)^(1/2)*Rt - Yn
% 3: N: ThetaN is given by Rao plots
% 4: e: ThetaE is given by Rao plots

Rads = zeros(10,1);
Dist = zeros(10,1);
i = 0;
ChamberDiam = 10;       % Given Chamber Diam
ThroatDiam = 6.543;     % Given Throat Diam;         
eps = 16;               % Given Area Ratio
f = 0.8;                % Given % of conical nozzle
thetaN = deg2rad(29);   % Graphical nozzle angle 
thetaE = deg2rad(9);    % Graphical exit 

Degs = deg2rad(15);     % Converting 15 degs to rads
TansThetaN = tan(deg2rad(29));
TansThetaE = tan(deg2rad(9));
Rt = ThroatDiam/2;      % Solving for Throat Radius
R1 = Rt*0.382;          % Solving for R1
ExitDiam = sqrt(eps*ThroatDiam^2); % Solving for ExitDiam

L = f*((Rt*(sqrt(eps)-1) + R1*((1/cos(Degs)) - 1)))/tan(Degs);  % Solving for Length

yprimeE =(eps^0.5)*Rt - (Rt + R1*(1 - cos(thetaN)));    % Solving for yprimeE
xprimeE = L - R1*sin(thetaN);                           % Solving for xprimeE

P = ((yprimeE*TansThetaN) + (yprimeE*TansThetaE) - (2*xprimeE*TansThetaE*TansThetaN))/(2*yprimeE - xprimeE*TansThetaN - xprimeE*TansThetaE); % Solving for P
S = (((yprimeE - P*xprimeE)^2)*(tan(thetaN) - P))/(xprimeE*tan(thetaN) - yprimeE);      % Solving for S
Q = -S/(2*(tan(thetaN) - P));       % Solving for Q
T = Q^2;        % Solving for T

yN = (eps^(1/2))*Rt - yprimeE;  % Solving for yN
xN = L - xprimeE;               % Solving for xN

for x = [0.60873,1,2,3,4,5,10,15,20,25,29.434]  % Looping through x values
    R = yN + P*(x - xN) + Q + (S*(x - xN) + T) ^(1/2);  % Solving for Radius
    i = i + 1;      % Loop Counter
    Rads(i) = R;    % Storing radius values in table
    Dist(i) = x;    % Storing x values in table
end

VarNames = {'x (inches)','r (inches)'};
T = table(Dist,Rads)

plot(Dist(2:11,1),Rads(2:11,1))
xlabel('x (inches)')
ylabel('r (inches)')
title('Rao Technique Bell Nozzle')