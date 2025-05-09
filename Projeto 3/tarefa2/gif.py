import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

# Parâmetros
N = 200  # Tamanho da malha
arquivo_saida = "saida_1_13862330.out"  # Nome do arquivo gerado no Fortran

# Ler o arquivo
with open(arquivo_saida, 'r') as f:
    linhas = f.readlines()

# Interpretar os frames
frames = []
frame = []

for linha in linhas:
    linha = linha.strip()
    if linha == "":
        continue  # Ignora linhas vazias (se tiver)

    numeros = [int(linha[i:i+4]) for i in range(0, len(linha), 4)]
    frame.append(numeros)

    if len(frame) == N:
        frames.append(np.array(frame))
        frame = []

# Configurar a figura
fig, ax = plt.subplots()
im = ax.imshow(frames[0], cmap='Greys', vmin=0, vmax=1)
ax.axis('off')

# Função de atualização
def update(frame):
    im.set_data(frame)
    return [im]

# Criar a animação
ani = animation.FuncAnimation(fig, update, frames=frames, interval=200, blit=True)

# Salvar o vídeo
ani.save('evolucao_DLA.mp4', writer='ffmpeg', fps=60)

print("Vídeo salvo como evolucao_DLA.mp4")
