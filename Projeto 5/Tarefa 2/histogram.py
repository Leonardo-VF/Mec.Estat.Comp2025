import numpy as np
import matplotlib.pyplot as plt

# Funções de distribuição de Maxwell-Boltzmann
def maxwell_boltzmann_1d(v, T, m=1.0, kB=1.0):
    return (1.0 / np.sqrt(2 * np.pi * kB * T / m)) * np.exp(-m * v**2 / (2 * kB * T))

def maxwell_boltzmann_mod(v, T, m=1.0, kB=1.0):
    return (m * v / (kB * T)) * np.exp(-m * v**2 / (2 * kB * T))

# Leitura dos dados do arquivo para um instante de tempo
# Suponha que você salvou as velocidades num arquivo, por exemplo: 'vel_t200.dat'
# Cada linha do arquivo: vx vy v
data = np.loadtxt("velocities.out")  # troque para seu arquivo

vx = data[:, 0]
vy = data[:, 1]
v  = data[:, 2]

# Estimar a temperatura
T_est = np.mean(v**2) / 2.0  # se m = 1, kB = 1

# Configurar os plots
fig, axs = plt.subplots(1, 3, figsize=(15, 5))
titles = ['Distribuição de $v_x$', 'Distribuição de $v_y$', 'Distribuição de $|\mathbf{v}|$']
bins_xy = np.linspace(-2, 2, 30)
bins_v  = np.linspace(0, 3, 30)

# Histograma de vx
axs[0].hist(vx, bins=bins_xy, density=True, alpha=0.6, label='Simulação')
v_theory = np.linspace(-2, 2, 200)
axs[0].plot(v_theory, maxwell_boltzmann_1d(v_theory, T_est), 'r--', label='Maxwell')
axs[0].set_title(titles[0])
axs[0].legend()

# Histograma de vy
axs[1].hist(vy, bins=bins_xy, density=True, alpha=0.6, label='Simulação')
axs[1].plot(v_theory, maxwell_boltzmann_1d(v_theory, T_est), 'r--', label='Maxwell')
axs[1].set_title(titles[1])
axs[1].legend()

# Histograma de |v|
axs[2].hist(v, bins=bins_v, density=True, alpha=0.6, label='Simulação')
v_mod_theory = np.linspace(0, 3, 200)
axs[2].plot(v_mod_theory, maxwell_boltzmann_mod(v_mod_theory, T_est), 'r--', label='Maxwell')
axs[2].set_title(titles[2])
axs[2].legend()

# Legendas
for ax in axs:
    ax.set_xlabel('Velocidade')
    ax.set_ylabel('Densidade de probabilidade')

fig.suptitle(f"Comparação com Maxwell-Boltzmann — T estimada = {T_est:.3f}")
plt.tight_layout()
plt.savefig("histograma_comparacao.png", dpi=300)  # Salvar como imagem
plt.show()