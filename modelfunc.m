% 定义模型函数
function R = modelfunc(x, A, B, k)
    R = A * (B + exp(-x ./ k));
end