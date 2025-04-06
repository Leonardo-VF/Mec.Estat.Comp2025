import matplotlib.pyplot as plt

k = 4
l = 20

with open(f"real_k{k}_13862330.out", "r") as file:
    x1 = []
    y1 = []

    while True:
        try:
            temp1, temp2 = map(float, file.readline().split())
            x1.append(temp2)
            y1.append(temp1)
        except:
            break

with open(f"img_k{k}_13862330.out", "r") as file:
    x2 = []
    y2 = []

    while True:
        try:
            temp1, temp2 = map(float, file.readline().split())
            x2.append(temp2)
            y2.append(temp1)
        except:
            break
x = []

for i in range(len(x1)):
    x.append(x1[i]**2 + x2[i]**2)



plt.plot(y1, [i/max(x) for i in x])
plt.xlabel(f"$\omega$")
plt.ylabel(f"$P(\omega)$")
plt.xlim(-0.25, 1)
plt.title("Aspectro de Potência")
plt.savefig(f"potencias_k{k}_l{l}_13862330.png")
plt.grid()
plt.show