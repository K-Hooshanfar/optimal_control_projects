%estefade az dastore dlqr


% Define the system matrices
A = [0.9863, 0.0528; -0.1189, 1.1680];
B = [0.0024; 0.0628];
Q = [1, 0; 0, 0.5];
R = 1;

% Define the horizon
N = 3;

% Preallocate arrays for states and inputs
x = zeros(2, N+1);  % +1 for the initial state
u_optimal = zeros(1, N);

% Compute the optimal feedback gain K using dlqr
[K, S, e] = dlqr(A, B, Q, R);

% Assuming the initial state is zero
x(:,1) = [2; 1];

% Simulation of the system with the optimal control law
for k = 1:N
    u_optimal(:,k) = -K*x(:,k);
    x(:,k+1) = A*x(:,k) + B*u_optimal(:,k);
end

% Time vector for plotting
time = 0:N;

% Plot the states
figure;
subplot(1, 2, 1);
stairs(time, x(1,:), 'LineWidth', 2);
hold on;
stairs(time, x(2,:), 'LineWidth', 2);
xlabel('Time steps');
ylabel('States');
title('System States Over Time');
legend('State x_1', 'State x_2');
grid on;

% Plot the control input
subplot(1, 2, 2);
stairs(time(1:N), u_optimal(1,:), 'LineWidth', 2);
xlabel('Time steps');
ylabel('Control Input');
title('Control Input Over Time');
legend('Control input u');
grid on;
