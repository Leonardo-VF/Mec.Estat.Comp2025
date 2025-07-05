import matplotlib.pyplot as plt
import numpy as np

# Função para ler os dados dos arquivos
def ler_dados(caminho_arquivo):
    dados = np.loadtxt(caminho_arquivo)
    iteracoes = dados[:, 0]
    energias = dados[:, 1]
    return iteracoes, energias

# Arquivos gerados pelo Fortran (ajuste os nomes se forem diferentes)
arquivo_annealing = "db.out"  # Recozimento (b = 0 -> 3)
arquivo_quenching = "db_001.out"  # Têmpera (b = 3 fixo)

# Lê os dados
it_annealing, E_annealing = ler_dados(arquivo_annealing)
it_quenching, E_quenching = ler_dados(arquivo_quenching)

# Cria o gráfico
plt.figure(figsize=(10, 6))
plt.plot(it_annealing, E_annealing, label=r'$\Delta\beta = 0.0001$')
plt.plot(it_quenching, E_quenching, label=r'$\Delta\beta = 0.001$')
plt.xlabel('Iterações de Monte Carlo')
plt.ylabel('Energia por spin')
plt.title('Comparação: Recozimento vs. Têmpera')
plt.legend()
plt.tight_layout()
plt.savefig("comparacao_energias.png", dpi=300)
plt.show()
