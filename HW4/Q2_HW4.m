% Define the system matrices
A = [0.9863, 0.0528; -0.1189, 1.1680];
B = [0.0024; 0.0628];
Q = [1, 0; 0, 0.5];
R = 1;
Qf = [1 0; 0 0]; % Only penalizing the first state variable at the final time step

% Define the horizon
N = 200;

% Initialize matrices for dynamic programming
P = zeros(2, 2, N+1);
P(:,:,N+1) = Qf;
K = zeros(1, 2, N);
u_optimal = zeros(1, N);
x = zeros(2, N+1);

% Dynamic programming
for k = N:-1:1
    K(:,:,k) = (R + B'*P(:,:,k+1)*B)\(B'*P(:,:,k+1)*A);
    P(:,:,k) = Q + A'*P(:,:,k+1)*A - A'*P(:,:,k+1)*B*K(:,:,k);
end

% Initial state 
x(:,1) = [2;1];

% Apply control inputs
for k = 1:N
    u_optimal(:,k) = -K(:,:,k)*x(:,k);
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
