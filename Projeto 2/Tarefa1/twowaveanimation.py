import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

# Carregar todos os dados do arquivo
data = np.loadtxt('saida_1_13862330.out')
data2 = np.loadtxt('saida_3_13862330.out')

# Número de linhas por frame
lines_per_frame = 1001

# Calcular o número total de frames
total_lines = data.shape[0]
num_frames = total_lines // lines_per_frame

# Separar os dados em frames
frames = [data[i * lines_per_frame:(i + 1) * lines_per_frame, :] for i in range(num_frames)]

# Criar uma segunda onda (exemplo: deslocada no tempo ou modificada)
frames2 = [data2[i * lines_per_frame:(i + 1) * lines_per_frame, :] for i in range(num_frames)]

# Extrair as coordenadas x do primeiro frame
x = frames[0][:, 0]

# Configurar a figura e o eixo
fig, ax = plt.subplots()
ax.set_xlim(min(x), max(x))
ax.set_ylim(-1, 1)
ax.set_xlabel('Posição (x)')
ax.set_ylabel('Amplitude (Y)')
ax.set_title('Propagação de Duas Ondas')

# Criar as linhas para as duas ondas
line1, = ax.plot([], [], lw=2, label='r = 1')
line2, = ax.plot([], [], lw=2, label='r = 0.25')
ax.legend()

# Função de inicialização
def init():
    line1.set_data([], [])
    line2.set_data([], [])
    return line1, line2

# Função de atualização
def animate(i):
    y1 = frames[i][:, 1]
    y2 = frames2[i][:, 1]
    line1.set_data(x, y1)
    line2.set_data(x, y2)
    return line1, line2

# Criar a animação
ani = animation.FuncAnimation(fig, animate, frames=num_frames, 
                              init_func=init, blit=True)

# Salvar ou exibir
ani.save('onda_dupla_propagacao.mp4', fps=144, extra_args=['-vcodec', 'libx264'])
plt.show()
