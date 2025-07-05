import numpy as np
import matplotlib.pyplot as plt

def load_temperature_data(filename):
    data = np.loadtxt(filename)
    if data.ndim == 1:
        data = data[np.newaxis, :]
    return data[:, 0], data[:, 1]

def moving_average(y, window=20):
    return np.convolve(y, np.ones(window)/window, mode='valid')

# Arquivos de temperatura
file1 = "temperature.out"
#file2 = "temperatureC.out"

# Carrega os dados
t1, T1 = load_temperature_data(file1)
#t2, T2 = load_temperature_data(file2)

# Aplica média móvel
window = 20  # ajuste conforme necessário
T1_smooth = moving_average(T1, window)
#T2_smooth = moving_average(T2, window)
t1_smooth = t1[window - 1:]
#t2_smooth = t2[window - 1:]


# Plot
plt.figure(figsize=(10, 5))
#plt.plot(t1, T1, alpha=0.3, label='Tarefa B (bruto)', color='tab:blue')
plt.plot(t1_smooth, T1_smooth, label='Tarefa B (média móvel)', color='tab:blue')

#plt.plot(t2, T2, alpha=0.3, label='Tarefa C (bruto)', color='tab:orange')
#plt.plot(t2_smooth, T2_smooth, label='Tarefa C (média móvel)', color='tab:orange')

# Rótulos e título
plt.xlabel("Tempo")
plt.ylabel("Temperatura")
plt.title("Temperatura vs Tempo")
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.savefig("temperatura_suavizada.png", dpi=300)
plt.show()
