import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

# ===== CONFIGURAÇÕES =====
arquivo = 'positions.out'
num_particulas = 20
nome_video = 'animacao_particulas.mp4'
intervalo_ms = 100  # intervalo entre quadros em milissegundos
dpi = 200  # resolução do vídeo

# ===== LEITURA E PROCESSAMENTO DOS DADOS =====
dados = np.loadtxt(arquivo)
num_frames = len(dados) // num_particulas

# Cria lista de frames (cada um com n partículas)
frames = [
    dados[i * num_particulas:(i + 1) * num_particulas]
    for i in range(num_frames)
]

# ===== PLOTAGEM =====
fig, ax = plt.subplots()
scat = ax.scatter([], [], s=20, edgecolor='k')
texts = []  # lista de textos

ax.set_title("Animação das Partículas")
ax.set_xlabel("x")
ax.set_ylabel("y")

ax.set_xlim(0, 10)
ax.set_ylim(0, 10)

# Inicializa os textos com posição arbitrária
for _ in range(num_particulas):
    text = ax.text(0, 0, '', fontsize=8, color='red',
                   ha='left', va='center')  # alinhamento horizontal à esquerda do texto
    texts.append(text)

# Atualização da animação
def update(frame):
    ids = frame[:, 0].astype(int)
    x = frame[:, 1]
    y = frame[:, 2]
    scat.set_offsets(np.column_stack((x, y)))

    # Atualiza os textos
    for i, text in enumerate(texts):
        text.set_position((x[i], y[i]))
        text.set_position((x[i] + 0.2, y[i] + 0.2))  # -0.2 no x, +0.2 no y
        text.set_text(str(ids[i]))

    return [scat, *texts]


# Criação da animação
ani = animation.FuncAnimation(
    fig, update, frames=frames, interval=intervalo_ms, blit=True
)

# ===== SALVAR VÍDEO =====
ani.save(nome_video, writer='ffmpeg', dpi=dpi)
print(f"Vídeo salvo como: {nome_video}")
