import matplotlib.pyplot as plt
import numpy as np
import os

# Parâmetros
beta_inicial = 0.40
beta_final = 0.50
db = 0.01

# Gera a lista de valores de beta
betas = np.arange(beta_inicial, beta_final + db/2, db)

plt.figure(figsize=(10, 6))

for beta in betas:
    nome_arquivo = f"evolucao_beta_{beta:.2f}.out"
    if os.path.exists(nome_arquivo):
        dados = np.loadtxt(nome_arquivo)
        passos = dados[:, 0]
        energia = dados[:, 1]
        plt.plot(passos, energia, label=f"β = {beta:.2f}")
    else:
        print(f"Aviso: Arquivo {nome_arquivo} não encontrado.")

plt.xlabel("Passo de Monte Carlo")
plt.ylabel("Energia por spin")
plt.title("Evolução da energia por spin para diferentes valores de β")
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.savefig("evolucao_energia_beta.png", dpi=300)
plt.show()
