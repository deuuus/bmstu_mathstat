function main()
    pkg load statistics

    function myhist()

        centers = zeros(1, m);
        heights = zeros(1, m);

        for i = 1:m
            heights(i) = counts(i) / (n * delta);
        endfor

        for i = 1:m
            centers(i) = bins(i + 1) - (delta / 2);
        endfor

        fprintf("Высоты столбцов гистограммы:\n");
        for i = 1:m
            fprintf("%d-ый столбец : %f\n", i, heights(i));
        endfor

        set(gca, "xtick", bins);
        set(gca, "ytick", heights);
        set(gca, "xlim", [min(bins) - 1, max(bins) + 1]);
        bar(centers, heights, 1);

        nodes = 0:(S / 250):(m_max + 5);
        X_pdf = normpdf(nodes, mu, sqrt(S));
        plot(nodes, X_pdf, "r");
    end

    function mycdf()

        heights = zeros(1, m + 2);
        bins = [(min(bins) - 0.5) bins];
        counts = [0 counts 0];

        acc = 0;
        m = m + 2
        for i = 2:m
            acc = acc + counts(i);
            heights(i) = acc / n;
        end

        nodes = (m_min):(S / 250):(m_max);
        X_cdf = normcdf(nodes, mu, sqrt(S));
        plot(nodes, X_cdf, "r");

        for i = 2:m
            fprintf("x = %f : F(x) = %f\n", bins(i), heights(i));
        end

        set(gca, "xtick", bins);
        set(gca, "ylim", [0, 1.1]);
        set(gca, "ytick", heights);
        stairs(bins, heights);
    end

    X  = [105, 108, 108, 109, 109, 111, 111, 111, 112, 113, 114, 114, 115, 115, 115, 115, 115, 115, 115, 115, 116, 116, 116, 117, 117, 117, 117, 118, 118, 118, 118, 118, 118, 118, 118, 119, 119, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 121, 121, 121, 122, 122, 122, 122, 122, 122, 123, 123, 123, 123, 123, 123, 123, 124, 124, 124, 124, 124, 124, 124, 124, 125, 125, 125, 125, 125, 125, 125, 125, 125, 125, 126, 126, 126, 126, 126, 126, 126, 126, 127, 127, 127, 127, 127, 127, 127, 127, 127, 127, 127, 127, 128, 128, 128, 128, 128, 128, 129, 129, 129, 129, 129, 129, 129, 129, 129, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 134, 134, 134, 134, 134, 134, 134, 135, 135, 135, 135, 135, 135, 135, 136, 136, 137, 137, 137, 137, 137, 138, 138, 139, 140, 140, 143, 144, 147, 147, 152]

    %X = [11.89,9.60,9.29,10.06,9.50,8.93,9.58,6.81,8.69,9.62,...
    %    9.01,10.59,10.50,11.53,9.94,8.84,8.91,6.90,9.76,7.09,...
    %     11.29,11.25,10.84,10.76,7.42,8.49,10.10,8.79,11.87,8.77,...
    %     9.43,12.41,9.75,8.53,9.72,9.45,7.20,9.23,8.93,9.15,10.19,...
    %     9.57,11.09,9.97,8.81,10.73,9.57,8.53,9.21,10.08,9.10,11.03,...
    %     10.10,9.47,9.72,9.60,8.21,7.78,10.21,8.99,9.14,8.60,9.14,10.95,...
    %     9.33,9.98,9.09,10.35,8.61,9.35,10.04,7.85,9.64,9.99,9.65,10.89,...
    %     9.08,8.60,7.56,9.27,10.33,10.09,8.51,9.86,9.24,9.63,8.67,8.85,...
    %     11.57,9.85,9.27,9.69,10.90,8.84,11.10,8.19,9.26,9.93,10.15,8.42,...
    %     9.36,9.93,9.11,9.07,7.21,8.22,9.08,8.88,8.71,9.93,12.04,10.41,...
    %     10.80,7.17,9.00,9.46,10.42,10.43,8.38,9.01]

    X = sort(X);

    % вычисление максимального и минимального значения
    
    m_max = max(X);
    m_min = min(X);
    fprintf("----------------------------------------\n");
    fprintf("1. Максимальное значение выборки: M_max = %f.\n", m_max);
    fprintf("   Минимальное значение выборки:  M_min = %f.\n", m_min);
    fprintf("----------------------------------------\n");

    % Вычисление размаха выборки
    
    r = m_max - m_min;
    fprintf("2. Размах выборки: R = %f.\n", r);
    fprintf("----------------------------------------\n");

    % Вычисление оценок математического ожидания и дисперсии
    
    n = length(X);
    mu = sum(X) / n;
    S = sum((X - mu).^2) / (n - 1);
    fprintf("3. Оценка математического ожидания: m = %f.\n", mu);
    fprintf("   Оценка дисперсии: S^2 = %f.\n", S);
    fprintf("----------------------------------------\n");

    % Группировка значений выборки в m = [log_2 n] + 2 интервала
    
    m = floor(log2(n)) + 2;
    bins = [];
    cur = m_min;
    delta = r / m 

    for i = 1:(m + 1)
        bins(i) = cur;
        cur = cur + delta;
    end

    eps = 1e-6;
    counts = [];

    for i = 1:(m - 1)
        cur = 0;

        for j = 1:n
            if ((X(j) - eps) > bins(i) || abs(bins(i) - X(j)) < eps) && X(j) < (bins(i + 1) - eps)
                cur = cur + 1;
            endif
        endfor

        counts(i) = cur;
    endfor

    cur = 0;
    for i = 1:n
        if (bins(m) < X(i) || abs(bins(m) - X(i)) < eps) && (X(i) < bins(m + 1) || abs(bins(m + 1) - X(i)) < eps)
            cur = cur + 1;
        endif
    endfor

    counts(m) = cur;

    fprintf("4. Группировка значений выборки в %d интервалов:\n", m);
    for i = 1:(m)
        fprintf("Интервал №%d [%f : %f) - %d значений из выборки.\n", i, bins(i), bins(i + 1), counts(i));
    end
    fprintf("----------------------------------------\n");

    % Построение гистограммы и функции плотности распределения нормальной СВ.

    fprintf("5. Построение гистограммы и графика функции плотности распределения нормальной СВ.\n");
    figure;
    hold on;
    grid on;
    myhist();
    xlabel('X')
    ylabel('P')
    print -djpg hist.jpg
    hold off;
    fprintf("----------------------------------------\n");

    % Построение графика эмпирической функции распределения и функции распределения нормальной СВ.
    fprintf("6. Построение графика эмпирической функции распределения и функции распределения нормальной СВ.\n");
    figure;
    hold on;
    grid on;
    mycdf(X, bins, counts);
    xlabel('X')
    ylabel('F')
    print -djpg cdf.jpg
    hold off;
end
