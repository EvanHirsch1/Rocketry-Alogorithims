clc
clear

% User inputs-------------------------------------------------------------
   
dt = 0.2;               % Time Step
Isp = 196.8;            % Specific Impulse [s]            
mp = 18200;             % Usable Propellant mass [lbm]
theta = 90*pi/180;      % Initial launch angle
tb = 65;                % Total burn time
A = 23.04;              % Project area of rocket, [ft^2]
drag_flag = 1;          % Drag reading (0 for no drag)

R = 2.09*10^7;          % Radius of Earth
i = 0;                  % Loop Counter
g0 = 32.2;              % Gravity Constant [ft/s^2]
mdot = mp/tb;           % Mass flow rate
Vy = 0;                 % Initial Vertical Rocket Velocity
Vx = 0;                 % Iniital Horizontal Rocket Velocity
t = 0;                  % Iniital Time 
x = 0;                  % Initial horizontal displacement
y = 0;                  % Initial vertical displacement
m = 25600;              % Initial Mass
dm = mdot*dt;           % Change in mass
V = 0;                  % Initial Velocity
G = 32.2;               % G is needed
drg = 0;
guided = 1;
g = 0;
ymax = 0;
xmax = 0;



while 1
    i = i + 1;          % While loop counter
    V = sqrt(Vx*Vx + Vy*Vy);  % Velocity Calc
    if drag_flag == 1         % Drag active or not
        D = drag(A,V,y);      % Drag calc
    else 
        D = 0;  
    end
    if mp > 0                 % If there is still propellant, add thrust
        T = g0*Isp;
    end
    g = g0*(R/(R+y))^2; % Variance in gravity
    G = g*dt;           % Variance in Gravity
    
    if guided == 1      % Guided point (Still propellant
        if t <= 4       % Vertical Flight
            theta = pi/2;
            Vy = Vy + ((dm)/m)*T*sin(theta) - D*sin(theta)*dt/m - G;     % Y direction Rocket Eqn
            Vx = 0;
        elseif t > 4 && t <= tb     % Propellant being burnded
            theta = 47*pi/180;      % Constant angle of attack
            V = V + (dm/m)*T - D*dt/m - G*sin(theta);  % Net Rocket Eqn
            Vx = V*cos(theta);      % Velocity in X
            Vy = V*sin(theta);      % Velocity in flight
        else  % Ballistic
            Vx = Vx + (dm/m)*T*cos(theta) - D*cos(theta)*dt/m; % X direction Rocket Eqn
            Vy = Vy + (dm/m)*T*sin(theta) - D*sin(theta)*dt/m - G; % Y Direction Rocket Eqn
            theta = atan(Vy/Vx);    % Change in angle 
        end
    end
    
    x = x + Vx*dt;       % X distance
    y = y + Vy*dt;       % Y Distance
    drg(i) = D/32.2;     % Drag cahnge to lbm
    
    if  y > ymax         % Store ymax
        ymax = y;
        tmaxh = t;
    end
    if x > xmax          % Store xmanx
        xmax = x;
    end
    
    xplot(i) = x;        % Storing X values
    yplot(i) = y;       % Y Plot    Not w
    theta(i) = theta;   % Theta Plot    
    Vxplot(i) = Vx;     % Velocity X plot
    Vyplot(i) = Vy;     % Velocity Y plot
    Vplot(i) = V;       % Velocity Magnitude plot
    tplot(i) = t;       % Time Plot
    
    
    if y < 0            % If y goes into ground, break the loop
        y = 0;
        break
    end
    
    t = t + dt;            % Time Step
    dm = mdot*dt;        % Change in mass

    if abs(t-tb) < 0.1  % if change in abs value of time step is less than specific limit, save as burns
        y_burn = y;
        x_burn = x;
        Vx_burn = Vx;
        Vy_burn = Vy;
    end
    
    if mp > 0             % As long as propellant exists, change in mass
        m = m-dm;
        mp = mp-dm;
    else
        mp = 0;          % Assuming no propellant mass left
    end
    fprintf('t = %g Vx = %g_x Vy = %g\n',t,Vx,Vy);
    fprintf('x = %g y = %g theta = %g\n',x,y,theta*180/pi);
end

ymax = y;
t_max = t;


% Plots ------------------------------------------------------------------

fprintf('ymax = %g [ft]   time to max h = %g [s]\n',ymax,t_max);
fprintf('total time of flight = %g [s]   range = %g [mi]\n', t,x/5280);
fprintf('x at burnout = %g [ft]  y at burnout = %g [ft]\n',x,y);

plot_velocity(xplot,yplot,Vplot);

function plot_velocity(xplot,yplot,v_plot)
title('Altitude and speed vs. distance')
ax = plotyy(xplot,yplot,xplot,v_plot);
xlabel('Distance [feet]')
axes(ax(1));
ylabel('height [ft]')
axes(ax(2));
ylabel('velocity [ft/s]')
grid
end

function T = temp_vs_h(y)   % Temp change vs. altitude
h = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 60, 70, 80, 90, 100, 150, 200, 250];
temp = [59, 41.17, 23.36, 5.55, -12.26 -30.05, -47.83, -65.61, -69.7, -69.7, -69.7, -69.7, -67.43, -61.98, -56.54, -51.1, 19.4, -19.78, -88.77];
T = spline(h,temp,y); 
end

function D = drag(A,V,y)    % Drag Function
rho = 0.75*exp(-0.00004*y);
T = temp_vs_h(y/1000) + 460;
c = sqrt(1.4*53.35*T*32.173);
M = V/c;
if M < 0.6
    Cd = 0.14;
elseif M >= 0.6 && M <= 1.6
    Cd = 0.7765 - 2.266*M + 2.39*M^2 - 0.605*M^3;
elseif M > 1.6 && M <= 5.4
    Cd = 1.646 - 1.959*M + 1.07*M^2 - 0.2876*M^3 + 0.0376*M^4 - 0.00191*M^5;
else
    Cd = 0.14
end
D = 0.5*rho*V*V*A*Cd;
fprintf('v = %g ft/s M = %g Cd = %g lbf c = %g ft/s\n',V,M,Cd,c);
end

% I'm not sure what the problem is, there is likely something missing in
% the loop that I don't understand. Need something for help
    

        
        