using Plots

# Решение уравнения Лапласа
function solve_field(field; max_iter=10000, tol=1e-6)
    rows, cols = size(field)
    new_field = copy(field)
    # Основной цикл итераций
    for _ in 1:max_iter
        # Проходимся по всем узлам сетки
        for i in 2:rows-1, j in 2:cols-1
            new_field[i, j] = 0.25 * (field[i-1, j] + field[i+1, j] + field[i, j-1] + field[i, j+1])
        end
        if maximum(abs.(new_field - field)) < tol
            break
        end
        field, new_field = new_field, field
    end

    return field
end

# Модель роста стримера
function grow_streamer(field, growth_factor=2.0, max_steps=10_000)
    rows, cols = size(field)
    path = [(rand(1:rows), 1)]
    # задаем максимальное количество шагов
    for _ in 1:max_steps
        curr = path[end]
        # Находим возможные направления роста
        neighbors = [(curr[1]+di, curr[2]+dj) for di in -1:1, dj in -1:1
                     if (di != 0 || dj != 0) &&
                        1 ≤ curr[1]+di ≤ rows &&
                        1 ≤ curr[2]+dj ≤ cols &&
                        !((curr[1]+di, curr[2]+dj) in path)]

        if isempty(neighbors)
            break
        end
        # Считаем сумму вероятностей и умножаем на случайное число 
        probs = [abs(field[i, j])^growth_factor for (i, j) in neighbors]
        total_prob = sum(probs)
        r = rand() * total_prob

        acc = 0.0
        # Находим узел, в котором накопленная сумма превышает порог r
        for ((i, j), p) in zip(neighbors, probs)
            acc += p
            if acc > r
                push!(path, (i, j))
                break
            end
        end
        # Проверяем, не достигли ли мы противоположного электрода
        if path[end][2] == cols
            break
        end
    end

    return path
end

# Параметры и начальные условия
rows, cols = 50, 50
field = fill(0.0, rows, cols)
field[:, 1] .= 0.0     # левый электрод
field[:, end] .= 100.0 # правый электрод

field = solve_field(field)
path = grow_streamer(field, 3.0)

# Визуализация
heatmap(field, aspect_ratio=1, title="Электрическое поле и стример", xlabel="x", ylabel="y", color=:viridis)
x, y = [i for (i, _) in path], [j for (_, j) in path]
plot!(y, x, color=:red, lw=2, label="Стример", legend=:topright)