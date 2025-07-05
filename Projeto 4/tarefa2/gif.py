import numpy as np
import matplotlib.pyplot as plt

def load_single_mesh(filename, L):
    with open(filename, 'r') as file:
        lines = file.readlines()
    if len(lines) != L:
        raise ValueError(f"Esperado {L} linhas no arquivo, mas encontrei {len(lines)}.")

    mesh = [list(map(int, line.split())) for line in lines]
    return np.array(mesh)

def plot_mesh(mesh, title, filename):
    plt.figure(figsize=(6, 6))
    plt.imshow(mesh, cmap='bwr', vmin=-1, vmax=1)
    plt.colorbar(label='Spin')
    plt.title(title)
    plt.axis('off')
    plt.savefig(filename)
    plt.close()

# === Tamanho da malha ===
L = 60

# === Carrega a malha única a partir do arquivo ===
mesh = load_single_mesh('configuracao_final_iterations.out', L)

# === Plota o estado dos spins ===
plot_mesh(mesh, 'Estado dos Spins', 'mesh.png')

print("Plotagem salva como 'mesh.png'")
