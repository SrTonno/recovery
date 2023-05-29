from browser_history import get_history
import sys
from datetime import date
from datetime import datetime


# Obtener el historial de búsqueda de todos los navegadores
history = get_history()

inicio = datetime.strptime(sys.argv[1], "%Y-%m-%d").date()  # Conversión a objeto de fecha
fin = datetime.strptime(sys.argv[2], "%Y-%m-%d").date()  # Conversión a objeto de fecha

# Imprimir el historial de búsqueda
for date, url in history.histories:
	if (inicio < date.date() < fin):
		print(f"{date} -> {url}")
