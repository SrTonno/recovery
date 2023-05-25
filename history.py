from browser_history import get_browserhistory

# Obtener el historial de búsqueda de todos los navegadores
history = get_browserhistory()

# Imprimir el historial de búsqueda
for browser, history_items in history.items():
	print(f"=== {browser} ===")
	for item in history_items:
		print(item)
	print()
