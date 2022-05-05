function main()
    pkg load statistics
    % Выборка
    X = [11.89,9.60,9.29,10.06,9.50,8.93,9.58,6.81,8.69,9.62,9.01,10.59,10.50,11.53,9.94,8.84,8.91,6.90,9.76,7.09,11.29,11.25,10.84,10.76,7.42,8.49,10.10,8.79,11.87,8.77,9.43,12.41,9.75,8.53,9.72,9.45,7.20,9.23,8.93,9.15,10.19,9.57,11.09,9.97,8.81,10.73,9.57,8.53,9.21,10.08,9.10,11.03,10.10,9.47,9.72,9.60,8.21,7.78,10.21,8.99,9.14,8.60,9.14,10.95,9.33,9.98,9.09,10.35,8.61,9.35,10.04,7.85,9.64,9.99,9.65,10.89,9.08,8.60,7.56,9.27,10.33,10.09,8.51,9.86,9.24,9.63,8.67,8.85,11.57,9.85,9.27,9.69,10.90,8.84,11.10,8.19,9.26,9.93,10.15,8.42,9.36,9.93,9.11,9.07,7.21,8.22,9.08,8.88,8.71,9.93,12.04,10.41,10.80,7.17,9.00,9.46,10.42,10.43,8.38,9.01]
    

    % Объем выборки
    N = length(X)

    % Точечная оценка математического ожидания
    MX = sum(X) / N

    % Точечная оценка дисперсии
    S2 = sum(X - MX).^2 / (N - 1)

    % Пользовательский ввод уровня доверия
    %gamma = input('Введите уровень доверия: ');
    gamma = 0.9

    % Нижняя граница доверительного интервала для математического ожидания
    MX_low = find_mx_low(MX, S2, gamma, N)

    % Верхняя граница доверительного интервала для математического ожидания
    MX_high = find_mx_high(MX, S2, gamma, N)

    % Нижняя граница доверительного интервала для дисперсии
    DX_low = find_dx_low(N, S2, gamma)

    % Верхняя граница доверительного интервала для дисперсии
    DX_high = find_dx_high(N, S2, gamma)

    %Вывод вычисленных значений

    % Построение первого графика

    % Массив точечных оценок для математического ожидания
    MX_array = zeros(1, N)

    % Массив точечных оценок для дисперсии
    DX_array = zeros(1, N)

    % Массивы для нижних и верхних границ для математического ожидания
    MX_low_array = zeros(1, N)
    MX_high_array = zeros(1, N)

    % Массивы для нижних и верхних границ для дисперсии
    DX_low_array = zeros(1, N)
    DX_high_array = zeros(1, N)

    for i = 1 : N
        temp_m = sum(X(1:i)) / (i)
        MX_array(i) = temp_m
        temp_s2 = sum(X(1:i) - temp_m).^2 / (i - 1)
        DX_array(i) = temp_s2
        MX_low_array(i) = find_mx_low(temp_m, temp_s2, gamma, i);
        MX_high_array(i) = find_mx_high(temp_m, temp_s2, gamma, i);
        DX_low_array(i) = find_dx_low(i, temp_s2, gamma);
        DX_high_array(i) = find_dx_high(i, temp_s2, gamma);
    end

    plot(1:N, [zeros(1, N) + MX]);
    hold on;
    plot(1:N, MX_array);
    plot(1:N, MX_low_array);
    plot(1:N, MX_high_array);
    xlabel('n');
    ylabel('y');
    %legend('$\hat \mu(\vec X)$', 'dsd');
end

function MX_low = find_mx_low(MX, S2, gamma, N)
    MX_low = MX - sqrt(S2) * tinv((1 + gamma) / 2, N - 1) \ sqrt(N);
end

function MX_high = find_mx_high(MX, S2, gamma, N)
    MX_high = MX + sqrt(S2) * tinv((1 + gamma) / 2, N - 1) \ sqrt(N);
end

function DX_low = find_dx_low(N, S2, gamma)
    DX_low = (N - 1) * S2 / chi2inv((1 + gamma) / 2, N - 1)
end

function DX_high = find_dx_high(N, S2, gamma)
    DX_high = (N - 1) * S2 / chi2inv((1 - gamma) / 2, N - 1)
end