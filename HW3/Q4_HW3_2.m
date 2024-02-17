% Define system parameters
m = 500; % Mass of the carriage
M = 2000; % Mass of the load
l = 10; % Length of the towing wire
g = 10; % Acceleration due to gravity

% System matrices
A = [0 1 0 0; 0 0 -m*g/M 0; 0 0 0 1; 0 0 -(M+m)*g/(M*l) 0];
B = [0; 1/M; 0; 1/(M*l)];

% Number of states
n = size(A,1);

% Calculate the controllability matrix
C = B;
for i = 1:n-1
    C = [C, A^i * B];
end

% Check if the system is controllable
if rank(C) == n
    % Use the last n columns of C as the transformation matrix T
    T = C(:, end-n+1:end);

    % Transform A and B into controllable canonical form
    A = inv(T) * A * T;
    B = inv(T) * B;
else
    error('The system is not controllable.');
end

% Choose Q and R matrices
% Q = diag([1, 1, 1, 1]); 
% R = 100; 

% Q = diag([1, 1, 1, 1]); 
% R = 0.1; 
Q = diag([100, 100, 100, 100]); 
R = 1;
% % Choose Q and R matrices
% Q = diag([1, 1, 1, 1]); 
% R = 1; 

Q = diag([0.1, 0.1, 0.1, 0.1]); 
R = 1;

% Compute the LQR controller gain
K = lqr(A, B, Q, R);
% Define initial conditions away from the equilibrium
x0 = [0.1, 0, 0.1, 0]; % Small initial displacement and velocity

% State-space model of the closed-loop system
A_cl = A - B * K;
B_cl = B;
C_cl = eye(4); % Output all states
D_cl = zeros(4, 1);

sys_cl = ss(A_cl, B_cl, C_cl, D_cl);

% Simulation time
T_final = 20;
t = 0:0.01:T_final;

% Simulate the closed-loop response with initial conditions
[y, t, x] = initial(sys_cl, x0, t);

% Control input for each time step
u = -K * x';

% Plot the states
figure;
subplot(2,1,1);
plot(t, x);
xlabel('Time (s)');
ylabel('States');
title('State Response with LQR Control');

% Plot the control input
subplot(2,1,2);
plot(t, u);
xlabel('Time (s)');
ylabel('Control Input');
title('Control Input with LQR Control');
