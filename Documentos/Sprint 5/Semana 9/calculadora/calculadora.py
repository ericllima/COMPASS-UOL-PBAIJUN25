class Calculadora:

    def soma(self, a, b):
        return a + b

    def sub(self, a, b):
        return a - b

    def mult(self, a, b):
        return a * b

    def div(self, a, b):
        if b == 0:
            raise ValueError("Não é possível dividir por zero")
        return a / b

    def potencia(self, a, b):
        return a ** b

    def resto(self, a, b):
        if b == 0:
            raise ValueError("Não é possível calcular resto por zero")
        return a % b
