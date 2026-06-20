import numpy as np
import matplotlib.pyplot as plt

# Параметры прямоугольных пластин
a, b = 6, 3  # размеры пластин (см)
d = 1  # расстояние между пластинами (см)
V_plate = 10  # напряжение между пластинами (В)

# Параметры области моделирования
Lx, Ly = 15, 15  # размеры области (см)
dx, dy = 0.1, 0.1  # шаг сетки (см)
nx, ny = int(Lx / dx), int(Ly / dy)  # количество точек на сетке

# Создаем координатную сетку
x = np.linspace(0, Lx, nx)
y = np.linspace(0, Ly, ny)
X, Y = np.meshgrid(x, y)

# Потенциал между пластинами с учетом краевых эффектов
V = np.zeros((ny, nx))

# Размещение зарядов на пластинах
plate1_x = np.linspace(0, a, 100)
plate1_y = np.linspace(0, b, 100)
plate2_x = np.linspace(0, a, 100)
plate2_y = np.linspace(0, b, 100)

# Моделируем заряд на пластинах
for i in range(100):
    for j in range(100):
        # Пластина 1
        r1 = np.sqrt((X - plate1_x[i]) ** 2 + (Y - plate1_y[j]) ** 2)
        V += V_plate / (r1 + 1e-9)  # добавляем вклад от пластин

        # Пластина 2
        r2 = np.sqrt((X - plate2_x[i]) ** 2 + (Y - plate2_y[j]) ** 2)
        V -= V_plate / (r2 + 1e-9)  # вклад от второго электрода

# Визуализация эквипотенциальных поверхностей
plt.figure(figsize=(8, 6))
plt.contourf(X, Y, V, 50, cmap="viridis")
plt.colorbar(label="Potential (V)")
plt.title("Equipotential Surfaces for a Rectangular Plate Capacitor")
plt.xlabel("x (cm)")
plt.ylabel("y (cm)")
plt.grid()

# Визуализация силовых линий
Ex, Ey = np.gradient(-V, dx, dy)
plt.streamplot(x, y, Ex, Ey, color="white", linewidth=0.5, density=1.5)
plt.show()
