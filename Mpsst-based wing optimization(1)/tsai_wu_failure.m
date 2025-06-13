function [failure,failure_index] = tsai_wu_failure(sigma1, sigma2, tau12)
% 将输入的应力值从 psi 转换为 MPa
    sigma1 = sigma1 / 145.038;  % psi 转换为 MPa
    sigma2 = sigma2 / 145.038;  % psi 转换为 MPa
    tau12 = tau12 / 145.038;    % psi 转换为 MPa
    XT = 2500;
    XC = 1531;
    YT = 640.5;
    YC = 285.7;
    S = 137;

 % 根据应力的正负选择强度参数
    if sigma1 > 0
        F1 = 1 / XT - 1 / XC;  % 正应力使用拉伸强度
        F11 = 1 / (XT * XC);
    else
        F1 = 1 / XC - 1 / XT;  % 负应力使用压缩强度
        F11 = 1 / (XC * XT);
    end

    if sigma2 > 0
        F2 = 1 / YT - 1 / YC;  % 正应力使用拉伸强度
        F22 = 1 / (YT * YC);
    else
        F2 = 1 / YC - 1 / YT;  % 负应力使用压缩强度
        F22 = 1 / (YC * YT);
    end

    F66 = 1 / S^2;
    F12 = 0.5 * sqrt(F11 * F22);
    
    % 计算 Tsai-Wu 失效准则
    failure_index = F1 * sigma1 + F2 * sigma2 + ...
                    F11 * sigma1^2 + F22 * sigma2^2 + ...
                    F66 * tau12^2 + 2 * F12 * sigma1 * sigma2;
    
    % 判定失效
    failure = failure_index >= 1; % 返回 true 或 false

end