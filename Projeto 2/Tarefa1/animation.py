import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

# Carregar todos os dados do arquivo
data = np.loadtxt('saida_3_13862330.out')

# Número de linhas por frame
lines_per_frame = 1001

# Calcular o número total de frames
total_lines = data.shape[0]
num_frames = total_lines // lines_per_frame

# Separar os dados em frames
frames = [data[i * lines_per_frame:(i + 1) * lines_per_frame, :] for i in range(num_frames)]

# Extrair as coordenadas x do primeiro frame
x = frames[0][:, 0]

# Configurar a figura e o eixo
fig, ax = plt.subplots()
ax.set_xlim(min(x), max(x))  # Ajuste conforme os dados
ax.set_ylim(-1, 1)  # Ajuste conforme os dados
ax.set_xlabel('Posição (x)')
ax.set_ylabel('Amplitude (Y)')
ax.set_title('Propagação da Onda')
line, = ax.plot([], [], lw=2)

# Função de inicialização
def init():
    line.set_data([], [])
    return line,

# Função de atualização
def animate(i):
    y = frames[i][:, 1]
    line.set_data(x, y)
    return line,

# Criar a animação
ani = animation.FuncAnimation(fig, animate, frames=num_frames, 
                              init_func=init, blit=True)

# Salvar ou exibir
ani.save('onda_propagacao_r0.25.mp4', fps=60, extra_args=['-vcodec', 'libx264'])
