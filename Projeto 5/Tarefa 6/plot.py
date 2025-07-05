import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

# ===== CONFIGURAÇÕES =====
arquivo = 'positions.out'
num_particulas = 1600
L = 40
nome_video = 'animacao_particulas.mp4'
intervalo_ms = 25  # tempo entre quadros (ms)
dpi = 300  # resolução do vídeo

# ===== LEITURA E PROCESSAMENTO DOS DADOS =====
dados = np.loadtxt(arquivo)
num_frames = len(dados) // num_particulas

# Cria lista de frames (cada um com num_particulas linhas: [t, x, y])
frames = [
    dados[i * num_particulas:(i + 1) * num_particulas, :]
    for i in range(num_frames)
]

# ===== PLOTAGEM =====
fig, ax = plt.subplots()
scat = ax.scatter([], [], s=10, edgecolor='k')

# Texto do tempo no topo
tempo_text = ax.text(0.02, 1.02, '', transform=ax.transAxes, fontsize=12, color='black')

ax.set_title("Animação das Partículas")
ax.set_xlabel("x")
ax.set_ylabel("y")
ax.set_xlim(0, L)
ax.set_ylim(0, L)

# Função de atualização para cada quadro da animação
def update(i):
    frame = frames[i]
    x = frame[:, 1]
    y = frame[:, 2]
    scat.set_offsets(np.column_stack((x, y)))

    tempo_atual = frame[0, 0]  # Tempo está na primeira coluna
    tempo_text.set_text(f"Tempo = {tempo_atual:.2f}")

    return [scat, tempo_text]

# Criação da animação
ani = animation.FuncAnimation(
    fig, update, frames=len(frames), interval=intervalo_ms, blit=True
)

# ===== SALVAR VÍDEO =====
ani.save(nome_video, writer='ffmpeg', dpi=dpi)
print(f"Vídeo salvo como: {nome_video}")
