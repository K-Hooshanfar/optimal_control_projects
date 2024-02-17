% Define the system matrices
A = [0.9863, 0.0528; -0.1189, 1.1680];
B = [0.0024; 0.0628];

% Define the horizon and initial condition
N = 2;  % horizon for the dynamic programming
x0 = [2; 1];  % initial condition of the system

% Initialize arrays to store the optimal inputs and states
u_optimal = zeros(size(B, 2), N + 1);
x_optimal = zeros(size(A, 1), N + 1);
x_optimal(:, 1) = x0;

% Cost function parameters
Q = [1, 0; 0, 0.5];
R = 1;
Qf = [0, 0; 0, 1];  % Terminal cost matrix for (x1(3))^2

% Dynamic programming
P = zeros(size(A, 1), size(A, 1), N + 1);
P(:, :, N + 1) = Qf;
for k = N:-1:1
    % Calculate the gain matrix
    K = inv(B' * P(:, :, k + 1) * B + R) * (B' * P(:, :, k + 1) * A);
    u_optimal(:, k + 1) = -K * x_optimal(:, k + 1);
    P(:, :, k) = Q + A' * P(:, :, k + 1) * A - A' * P(:, :, k + 1) * B * K;
    x_optimal(:, k + 1) = A * x_optimal(:, k + 1) + B * u_optimal(:, k + 1);
end

% Calculate the optimal input for k=0
K = inv(B' * P(:, :, 1) * B + R) * (B' * P(:, :, 1) * A);
u_optimal(:, 1) = -K * x_optimal(:, 1);

% Update state for k=0
x_optimal(:, 2) = A * x_optimal(:, 1) + B * u_optimal(:, 1);

% Calculate the cost for each time step
J_k = zeros(1, N + 1);
for k = 1:N + 1
    J_k(k) = (x_optimal(1, k))^2 + 0.5 * (x_optimal(2, k))^2 + (u_optimal(1, k))^2;
end

% Plot the system state signal, control input, and cost
figure;

% Plot state signals
subplot(1, 3, 1);
stairs(0:N, x_optimal(1, :), 'LineWidth', 2, 'DisplayName', 'x1');
hold on;
stairs(0:N, x_optimal(2, :), 'LineWidth', 2, 'DisplayName', 'x2');
title('State Signals');
xlabel('Time step');
ylabel('State');
legend;

% Plot control input
subplot(1, 3, 2);
stairs(0:N, u_optimal(1, :), 'LineWidth', 2);
title('Control Input');
xlabel('Time step');
ylabel('Input');
xlim([0, 10]);  % Set x-axis range

% Plot cost
subplot(1, 3, 3);
plot(0:N, J_k, 'o-', 'LineWidth', 2);
title('Cost Function');
xlabel('Time step');
ylabel('Cost');
xlim([0, 10]);  % Set x-axis range

sgtitle('Optimal Control with Dynamic Programming');
