function dVdt = V2Rocket(t,y)
    % y(1) -> Vx: Velocity in the x direction
    % y(2) -> Vy: Velocity in the y direction
    % y(3) -> x: Horizontal Position
    % y(4) -> h: Vertical Position
    % y(5) -> theta; Angle of Attack
    % y(6) -> Mass
    % dVdt(1) -> dVx/dt
    % dVdt(2) -> dVy/dt
    % dVdt(3) -> dx/dt
    % dVdt(4) -> dy/dt
    % dVdt(5) -> dthetha/dt
    % dVdt(6) -> dm/dt
    
F = 55100;  % Thrust
mdot = 280; % mass flow rate
Go = 32.2;  % Gravity  
Isp = 300;  % Specific impulse assumed 300s
rho = 14.7; % This is also channging but assumed at sea level
A = 1; % Need this value as a given
Cd = 1; % Need this value, even though it's changing
R = 2.09*10^7; % Radius of earth  
mpo = 25600;

    dVdt = zeros(6,1);
        dVdt(1) = y(1) + (y(6)/dVdt(6))*Go*Isp*cos(y(5));
        dVdt(2) = y(2) + (y(6)/dVdt(6))*Go*Isp*sin(y(5)) - Go*y(4)/(((R+y(4))^2)*t);
        dVdt(3) = dVdt(3) + dVdt(1)*t;
        dVdt(4) = dVdt(4) + dVdt(2)*t;
        dVdt(5) = atan(dVdt(1)/dVdt(2));
        dVdt(6) = dVdt(6) - mdot.*t;