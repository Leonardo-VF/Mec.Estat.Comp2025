import numpy as np
import matplotlib.pyplot as plt

dados = []

with open("rule_232_13862330.out") as arq:
    for linha in arq:
        # Limpa e separa os números
        linha_limpa = linha.strip().split()
        dados.append([int(x) for x in linha_limpa])

# Converte para numpy array diretamente
estagios = np.array(dados)

# Plot
plt.figure(figsize=(10, 6))
plt.imshow(estagios, cmap='Greys', interpolation='nearest', aspect='auto')
plt.title("Evolução do Jogo da Vida")
plt.xlabel("Células")
plt.ylabel("Tempo")
plt.colorbar(label='Estado da célula (0 = morta, 1 = viva)')
plt.tight_layout()
plt.show()
