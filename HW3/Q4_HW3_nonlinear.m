% Define the LQR controller gain (from your previous computation)
K = [15.561857975282136,39.165711821426060,45.786797970807946,-13.488844074846117];

% Define system parameters
m = 500; % Mass of the carriage
M = 2000; % Mass of the load
l = 10; % Length of the towing wire
g = 10; % Acceleration due to gravity

% Refine the initial conditions to be even closer to the equilibrium
x0 = [0.0001, 0.000001, 0.0001, 0.000001]; % Very small displacement and velocity

% Time span for the simulation
T_final = 50;
tspan = [0 T_final];

% Options for ode45 to have a tighter tolerance and smaller step size
opts = odeset('RelTol',1e-8,'AbsTol',1e-10);

% Simulate the system using ode45 with options for improved accuracy
[t, x] = ode45(@(t, x) nonlinear_crane_dynamics(t, x, K, m, M, l, g), tspan, x0, opts);

% Plot the states with new controller and refined simulation
figure;
subplot(2,2,1);
plot(t, x(:,1));
xlabel('Time (s)');
ylabel('Position (m)');
title('Position Response');

subplot(2,2,2);
plot(t, x(:,2));
xlabel('Time (s)');
ylabel('Velocity (m/s)');
title('Velocity Response');

subplot(2,2,3);
plot(t, x(:,3));
xlabel('Time (s)');
ylabel('Angle (rad)');
title('Angle Response');

subplot(2,2,4);
plot(t, x(:,4));
xlabel('Time (s)');
ylabel('Angular Velocity (rad/s)');
title('Angular Velocity Response');

sgtitle('Adjusted Nonlinear System Response with LQR Control');


function dxdt = nonlinear_crane_dynamics(t, x, K, m, M, l, g)
    % Extract the states
    x1 = x(1); % Position
    x2 = x(2); % Velocity
    x3 = x(3); % Angle
    x4 = x(4); % Angular velocity

    % Control input based on LQR controller
    u = -K*10^4 * x;

    % Nonlinear dynamics of the crane system
    dx1dt = x2;
    dx2dt = (u + M*l*x4^2*sin(x3) - m*g*sin(x3)*cos(x3)) / (M + m*(1-cos(x3)^2));
    dx3dt = x4;
    dx4dt = (u*cos(x3) - (M+m)*g*sin(x3) - m*l*x4^2*sin(x3)*cos(x3)) / (l*(M + m*(1-cos(x3)^2)));

    % Return the derivatives of the state
    dxdt = [dx1dt; dx2dt; dx3dt; dx4dt];
end