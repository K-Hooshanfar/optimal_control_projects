def predict_state(A, B, u_k, B_w, w, x_k_minus_1, Sigma_k_minus_1):
    x_k_k_minus_1 = A @ x_k_minus_1 + B @ u_k + B_w @ w
    Sigma_k_k_minus_1 = A @ Sigma_k_minus_1 @ A.T + B_w @ S_w @ B_w.T
    return x_k_k_minus_1, Sigma_k_k_minus_1