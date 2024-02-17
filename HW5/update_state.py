def update_state(C, m_k, Sigma_k_k_minus_1, x_k_k_minus_1, x_k_minus_1, S_v):
    G_k = Sigma_k_k_minus_1 @ C.T @ np.linalg.inv(S_v + C @ Sigma_k_k_minus_1 @ C.T)
    x_k_k = x_k_k_minus_1 + G_k @ (m_k - C @ x_k_k_minus_1)
    Sigma_k_k = Sigma_k_k_minus_1 - G_k @ C @ Sigma_k_k_minus_1
    return x_k_k, Sigma_k_k