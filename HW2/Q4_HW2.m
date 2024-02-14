
% % % % % % قسمت ب

% syms t C1
% 
% % Given function J[x(t)]
% J = int((diff(t + 1 + C1*t*(1-t), t))^2 + (t + 1 + C1*t*(1-t))*diff(t + 1 + C1*t*(1-t), t) + (t + 1 + C1*t*(1-t))^2, t, 0, 1);
% 
% % Given approximate solution
% x_approx = t + 1 + C1*t*(1-t);
% 
% % Substitute the approximate solution into the expression J[x(t)]
% J_approx = simplify(subs(J, diff(x_approx, t), diff(t + 1 + C1*t*(1-t), t)));
% 
% % Minimize the error by setting the derivative of J_approx with respect to C1 to zero
% dJ_dc1 = diff(J_approx, C1);
% C1_value = solve(dJ_dc1 == 0, C1);
% 
% % Display the value of C1
% disp('The value of C1 obtained using the Ritz method is:');
% disp(C1_value);
% 
% % Plot the two solutions for comparison
% t_values = linspace(0, 1, 100);
% x_exact = 0.6944*exp(t_values) + 0.3056*exp(-t_values);
% x_approx_values = subs(x_approx, C1, C1_value);
% x_approx_values = double(subs(x_approx_values, t, t_values));
% 
% figure;
% plot(t_values, x_exact, 'b-', 'LineWidth', 2, 'DisplayName', 'Exact Solution');
% hold on;
% plot(t_values, x_approx_values, 'r--', 'LineWidth', 2, 'DisplayName', 'Approximate Solution');
% xlabel('t');
% ylabel('x(t)');
% title('Comparison of Exact and Approximate Solutions');
% legend('show');
% grid on;



% % % % % % % % قسمت ج

syms t C1 C2

% Define the trial function
x = t + 1 + C1*t*(1-t) + C2*t^2*(1-t);

% Define the functional J(z(t))
J = (diff(x,t)^2 + x*diff(x,t) + x^2);

% Take the integral of J with respect to t
J_integral = int(J, t, 0, 1);

% Find the partial derivatives of J_integral with respect to C1 and C2
dJ_dC1 = diff(J_integral, C1);
dJ_dC2 = diff(J_integral, C2);

% Solve the system of equations to find C1 and C2
solution = solve(dJ_dC1 == 0, dJ_dC2 == 0, C1, C2);

% Extract numeric values for C1 and C2
C1_value = double(solution.C1);
C2_value = double(solution.C2);

disp(['C1 = ', num2str(C1_value)])
disp(['C2 = ', num2str(C2_value)])

% Given values
C1_exact = 0.6944;
C2_exact = 0.3056;

% Define the time vector
t_values = linspace(0, 1, 100);

% Exact solution
x_exact = @(t) C1_exact*exp(t) + C2_exact*exp(-t);

% Approximate solution with obtained C1 and C2 values
x_approx = @(t) t + 1 + C1_value*t.*(1-t) + C2_value*t.^2.*(1-t);

% Evaluate solutions at different time points
exact_solution = x_exact(t_values);
approx_solution = x_approx(t_values);

% Plot the solutions
figure;
plot(t_values, exact_solution, 'LineWidth', 2, 'DisplayName', 'Exact Solution');
hold on;
plot(t_values, approx_solution, '--', 'LineWidth', 2, 'DisplayName', 'Approximate Solution');
xlabel('t');
ylabel('x(t)');
title('Comparison of Exact and Approximate Solutions');
legend('Location', 'best');
grid on;
hold off;

