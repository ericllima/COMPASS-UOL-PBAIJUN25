import pytest
from calculadora import Calculadora

calc = Calculadora()

def test_identidades():
    assert calc.soma(7, 0) == 7
    assert calc.mult(7, 1) == 7
    assert calc.mult(7, 0) == 0

def test_div_com_negativos():
    assert calc.div(-8, 2) == -4
    assert calc.div(8, -2) == -4
    assert calc.div(-9, -3) == 3

def test_float_precision_div():
    assert calc.mult(1.5, 2) == 3.0
    assert calc.div(1, 3) == pytest.approx(1/3, rel=1e-9, abs=1e-12)

def test_resto_com_negativos_documenta_python():
    assert calc.resto(-10, 3) == 2
    assert calc.resto(10, -3) == -2

def test_comutatividade_soma_mult():
    a, b = 7, 3
    assert calc.soma(a, b) == calc.soma(b, a)
    assert calc.mult(a, b) == calc.mult(b, a)

def test_nao_comutativas_sub_div():
    a, b = 10, 4
    assert calc.sub(a, b) != calc.sub(b, a)
    assert calc.div(a, b) != calc.div(b, a)

def test_potencia_negativa_e_zero_zero():
    assert calc.potencia(2, -1) == 0.5
    assert calc.potencia(0, 0) == 1

def test_grandes_numeros():
    assert calc.mult(10**6, 10**6) == 10**12
