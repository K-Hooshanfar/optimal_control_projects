% Define symbolic variables
syms x1 x2 x3 x4 F M m l g real

% Assign numeric values to parameters
M_val = 2000; % Modify as needed
m_val = 500;  % Modify as needed
l_val = 10;   % Modify as needed
g_val = 9.81; % Standard gravity

% Define the state variables and operating point
X = [x1; x2; x3; x4];
X0 = [0; 0; 0; 0]; % Operating point

% Define the nonlinear state equations
f1 = x2;
f2 = (-M*l*cos(x1)*sin(x1)*x2^2 + F*cos(x1) + (M+m)*g*sin(x1)) / (l*(M+m) - M*l*cos(x1)^2);
f3 = x4;
f4 = (F + M*l*sin(x1)*x2^2 + M*g*cos(x1)*sin(x1)) / (M+m - M*cos(x1)^2);

f = [f1; f2; f3; f4];

% Compute the Jacobian matrix
A = jacobian(f, X);

% Evaluate the Jacobian matrix at the operating point
A_lin = subs(A, X, X0);
A_lin = subs(A_lin, [M, m, l, g], [M_val, m_val, l_val, g_val]);

% Convert symbolic Jacobian to numeric matrix 
A_lin = double(A_lin)

% Compute the partial derivatives with respect to F
B = jacobian(f, F);

% Evaluate B at the operating point X0
B_lin = subs(B, X, X0);
B_lin = subs(B_lin, [M, m, l, g], [M_val, m_val, l_val, g_val]);

% Convert symbolic B to numeric matrix 
B_lin = double(B_lin)
