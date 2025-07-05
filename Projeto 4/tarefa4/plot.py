import numpy as np
import matplotlib.pyplot as plt

# Carregar os dados
data = np.loadtxt("resultados_d1.out")
L = data[:,0]
T_intervalo = data[:,1]

plt.plot(L, np.log(T_intervalo), 'o-', label='ln(<T_intervalo>) vs L')
plt.xlabel("Tamanho da Rede L")
plt.ylabel("ln(<T_intervalo>)")
plt.title("Crescimento de ln(<T_intervalo>) com L")
plt.grid(True)
plt.legend()
plt.savefig("resultado.png")
plt.show()
