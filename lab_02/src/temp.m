function main()
    pkg load statistics
    X = [11.89, 9.60,  9.29,  10.06, 9.50,  8.93,  9.58,  6.81,  8.69,...
         9.62,  9.01,  10.59, 10.50, 11.53, 9.94,  8.84,  8.91,  6.90,...
         9.76,  7.09,  11.29, 11.25, 10.84, 10.76, 7.42,  8.49,  10.10,...
         8.79,  11.87, 8.77,  9.43,  12.41, 9.75,  8.53,  9.72,  9.45,...
         7.20,  9.23,  8.93,  9.15,  10.19, 9.57,  11.09, 9.97,  8.81,...
         10.73, 9.57,  8.53,  9.21,  10.08, 9.10,  11.03, 10.10, 9.47,...
         9.72,  9.60,  8.21,  7.78,  10.21, 8.99,  9.14,  8.60,  9.14,...
         10.95, 9.33,  9.98,  9.09,  10.35, 8.61,  9.35,  10.04, 7.85,...
         9.64,  9.99,  9.65,  10.89, 9.08,  8.60,  7.56,  9.27,  10.33,...
         10.09, 8.51,  9.86,  9.24,  9.63,  8.67,  8.85,  11.57, 9.85,...
         9.27,  9.69,  10.90, 8.84,  11.10, 8.19,  9.26,  9.93,  10.15,...
         8.42,  9.36,  9.93,  9.11,  9.07,  7.21,  8.22,  9.08,  8.88,...
         8.71,  9.93,  12.04, 10.41, 10.80, 7.17,  9.00,  9.46,  10.42,...
         10.43, 8.38,  9.01]

    % Уровень доверия
    gamma = 0.9;
    %gamma = input('Введите уровень доверия: ')
    % Объем выборки 
    N = length(X);
    % Точечная оценка мат. ожидания
    M = mean(X);
    % Точечная оценка дисперсии
    S2 = var(X);
    % Нижняя граница доверительного интервала для мат. ожидания
    M_low = find_m_low(N, M, S2, gamma);
    % Верхняя граница доверительного интервала для мат. ожидания
    M_high = find_m_high(N, M, S2, gamma);
    % Нижняя граница доверительного интервала для дисперсии
    S2_low = find_S2_low(N, S2, gamma);
    % Верхняя граница доверительного интервала для дисперсии
    S2_high = find_S2_high(N, S2, gamma);
    
    % Вывод полученных ранее значений
    fprintf('Точечная оценка математического ожидания = %.3f\n', M);
    fprintf('Точечная оценка дисперсии = %.3f\n', S2);
    fprintf('Нижняя граница доверительного интервала для математического ожидания = %.3f\n', M_low);
    fprintf('Верхняя граница доверительного интервала для математического ожидания = %.3f\n', M_high);
    fprintf('Нижняя граница доверительного интервала для дисперсии = %.3f\n', S2_low);
    fprintf('Верхняя граница доверительного интервала для дисперсии = %.3f\n', S2_high);
    
    % Массив точечных оценок для математического ожидания
    M_array = zeros(1, N)
    % Массив точечных оценок для дисперсии
    S2_array = zeros(1, N)
    % Массивы для нижних и верхних границ для математического ожидания
    M_low_array = zeros(1, N)
    M_high_array = zeros(1, N)
    % Массивы для нижних и верхних границ для дисперсии
    S2_low_array = zeros(1, N)
    S2_high_array = zeros(1, N)
    
    for i = 1 : N
        temp_m = mean(X(1:i));
        temp_s2 = var(X(1:i));
        M_array(i) = temp_m;
        S2_array(i) = temp_s2;
        M_low_array(i) = find_m_low(i, temp_m, temp_s2, gamma);
        M_high_array(i) = find_m_high(i, temp_m, temp_s2, gamma);
        S2_low_array(i) = find_S2_low(i, temp_s2, gamma);
        S2_high_array(i) = find_S2_high(i, temp_s2, gamma);
    end
    
    % Построение графиков
    plot(1 : N, [(zeros(1, N) + M)', M_array', M_low_array', M_high_array']);
    xlabel('n');
    ylabel('y');
    legend('f1', 'f2', 'f3', 'f4');
    print -djpg p1.jpg
    figure;

    plot(1 : N, [(zeros(1, N) + S2)', S2_array', S2_low_array', S2_high_array']);
    xlabel('n');
    ylabel('z');
    %ylim([0, 20]);
    legend('g1', 'g2', 'g3', 'g4');
    print -djpg p2.jpg
end

% Функция поиска нижней границы доверительного интервала для математического ожидания
function M_low = find_m_low(N, M, S2, gamma)
    M_low = M - sqrt(S2) * tinv((1 + gamma) / 2, N - 1) / sqrt(N);
end
% Функция поиска верхней границы доверительного интервала для математического ожидания
function M_high = find_m_high(N, M, S2, gamma)
    M_high = M + sqrt(S2) * tinv((1 + gamma) / 2, N - 1) / sqrt(N);
end
% Функция поиска нижней границы доверительного интервала для дисперсии
function S2_low = find_S2_low(N, S2, gamma)
    S2_low = ((N - 1) * S2) / chi2inv((1 + gamma) / 2, N - 1);
end
% Функция поиска верхней границы доверительного интервала для дисперсии
function S2_high = find_S2_high(N, S2, gamma)
    S2_high = ((N - 1) * S2) / chi2inv((1 - gamma) / 2, N - 1);
end