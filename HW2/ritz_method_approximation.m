function ritz_method_approximation(n_terms, t0, tf, x_t0, x_tf)
    
    syms t;

    % Define the trial function
    phi0 = ((x_tf-x_t0)/tf)*t + x_t0;
    phi = @(i) t^i * (tf - t);

    % Build the trial function with n_terms
    x_trial = phi0;
    C_values = sym('C', [1, n_terms], 'real');
    for i = 1:n_terms
        x_trial = x_trial + C_values(i) * phi(i);
    end

    % Define the functional J(z(t))
    J = (diff(x_trial, t)^2 + x_trial * diff(x_trial, t) + x_trial^2);

    % Take the integral of J with respect to t
    J_integral = int(J, t, t0, tf);

    % Substitute the solutions into the expression
    J_subs = subs(J_integral, C_values, sym('C', [1, n_terms], 'real'));

    % Find the partial derivatives of J_subs with respect to Ci
    dJ_dC = gradient(J_subs, C_values);

    % Solve the system of equations to find Ci
    solution = solve(dJ_dC == zeros(1, n_terms), C_values);

    % Display the values of C1, C2, ..., Cn
    disp('Values of Ci:');
    if n_terms == 1
        disp(['C1 = ', num2str(double(solution(1)))]);
    else
        for i = 1:n_terms
           disp(['C', num2str(i), ' = ', num2str(double(solution.(['C', num2str(i)])))]);
        end
    end
end
