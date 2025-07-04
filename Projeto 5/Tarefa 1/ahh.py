import numpy as np
import matplotlib.pyplot as plt

# ===== CONFIGURAÇÕES =====
arquivo = 'positions.out'
num_particulas = 20
frame_index = 0  # índice do primeiro frame (vai mostrar t, t+1, t+2)

# ===== LEITURA DOS DADOS =====
dados = np.loadtxt(arquivo)
num_frames = len(dados) // num_particulas

if frame_index + 2 >= num_frames:
    raise ValueError("Índice de frame muito alto para mostrar t, t+1 e t+2.")

# Separa os 3 frames
frame_t   = dados[frame_index * num_particulas : (frame_index + 1) * num_particulas]
frame_t1  = dados[(frame_index + 1) * num_particulas : (frame_index + 2) * num_particulas]
frame_t2  = dados[(frame_index + 2) * num_particulas : (frame_index + 3) * num_particulas]

# ===== PLOTAGEM =====
fig, ax = plt.subplots(figsize=(8, 8))

# Frame t (azul)
x0 = frame_t[:, 1]
y0 = frame_t[:, 2]
ids = frame_t[:, 0].astype(int)
ax.scatter(x0, y0, color='blue', s=20, label='Frame t')

# Frame t+1 (vermelho)
x1 = frame_t1[:, 1]
y1 = frame_t1[:, 2]
ax.scatter(x1, y1, color='red', s=20, label='Frame t+1')

# Frame t+2 (verde)
x2 = frame_t2[:, 1]
y2 = frame_t2[:, 2]
ax.scatter(x2, y2, color='green', s=20, label='Frame t+2')

# Linhas de deslocamento
for i in range(num_particulas):
    ax.plot([x0[i], x1[i]], [y0[i], y1[i]], color='gray', linestyle='--', linewidth=0.8)
    ax.plot([x1[i], x2[i]], [y1[i], y2[i]], color='gray', linestyle='--', linewidth=0.8)

# Rótulos das partículas acima da posição no frame t+1
for i in range(num_particulas):
    ax.text(x1[i], y1[i] + 0.2, str(ids[i]), fontsize=8, color='black', ha='center')

# Ajustes visuais
ax.set_xlim(0, 10)
ax.set_ylim(0, 10)
ax.set_aspect('equal')
ax.set_xlabel("x")
ax.set_ylabel("y")
ax.set_title("Frames t (azul), t+1 (vermelho), t+2 (verde)")
ax.grid(True)
ax.legend()

plt.tight_layout()
plt.show()
