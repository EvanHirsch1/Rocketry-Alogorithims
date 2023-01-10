clc
clear

% User inputs-------------------------------------------------------------
   
dt = 0.2;               % Time Step
Isp = 196.8;            % Specific Impulse [s]            
mp = 18200;             % Usable Propellant mass [lbm]
theta = 90*pi/180;      % Initial launch angle
tb = 65;                % Total burn time
A = 23.04;              % Project area of rocket, [ft^2]
drag_flag = 0;          % Drag reading (0 for no drag)
R = 2.09*10^7;          % Radius of Earth
i = 0;                  % Loop Counter
F = 55100;              % Thrust [lbm]
g0 = 32.2;              % Gravity Constant [ft/s]
mdot = mp/tb;           % Mass flow rate
Vy = 0;                 % Initial Vertical Rocket Velocity
Vx = 0;                 % Iniital Horizontal Rocket Velocity
t = 0;                  % Iniital Time 
x = 0;                  % Initial horizontal displacement
y = 0;                  % Initial vertical displacement
m = 25600;              % Initial Mass
dm = mdot*t;            % Change in mass

while 1
    i = i + 1;          % While loop counter
    if t > tb
        F = 0;          % Thrust turns to 0 when t > tb
    end
    g = g0*(R/(R+y))^2; % Variance in gravity
    if t <= 4   
        Vy = Vy + ((dm)/m)*g0*Isp*sin(theta) -g0*((y/(R+y))^2)*t     % Y direction Rocket Eqn
    elseif t > 4 && t <= tb
        V = -((dm)/m)*g0*Isp*cos(theta)-g0*((y/R+y)^2)*sin(theta)*t  % Net Rocket Eqn
    else
        Vx = Vx + ((m0-mp)/m)*g0*Isp*cos(theta) - g0*((y/(R+y))^2)*t % X direction Rocket Eqn
        Vy = Vy + ((m0-mp)/m)*g0*Isp*sin(theta) - g0*((y/(R+y))^2)*t % Y Direction Rocket Eqn
    end
    x = x + Vx*dt;      % X distance
    y = y + Vy*dt;      % Y Distance
    
    yplot(i) = y;       % Y Plot    
    theta(i) = theta;   % Theta Plot    
    
    t = t+dt;           % Time Step
    dm = mdot*dt;       % Change in mass
    
    if mp >0            % As long as propellant exists, change in mass
        m = m-dm;
        mp = mp-dm;
    else
        mp = 0;         % Assuming no propellant mass left
    end
    fprintf('t = %g Vx = %g_x Vy = %g\n',t,Vx,Vy);
    fprintf('x = %g y = %g theta = %g\n',x,y,theta*180/pi);
end

fprintf('ymax = %g ft time to max h = %g s\n',ymax,t_maxh);
fprintf('total time of flight = %g s   range = %g mi\n', t,x/5280);
fprintf('x at burnout = %g ft  y at burnout = %g ft\n',x_burn_y_burn);

plot_velocity(xplot,yplot,v_plot);

function plot_velocity(xplot,yplot,v_plot)
title('Altitude and speed vs. distance')
ax = plotyy(xplot,yplot,xplot,v_plot);
xlable('Distance [feet]')
axes(ax(1));
ylabel('height [ft]')
axes(ax(2));
ylabel*('velocity [ft/s]')
grid
end

    
    
        
    

        
        