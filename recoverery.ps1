# Definir las fechas de inicio y fin del rango
$fechaInicio = Get-Date "2023-01-01"
$fechaFin = Get-Date "2023-02-28"

#-Obtención de la hora local de un equipo https://learn.microsoft.com/es-es/powershell/scripting/samples/collecting-information-about-computers?view=powershell-7.3
Get-CimInstance -ClassName Win32_LocalTime
#Fechas de cambio de ramas de registro (CurrentVersionRun)
RegistryDate.exe HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion 27-11-2012:12.00 27-11-2012:12.14
#Archivos recientes
## Obtener archivos recientes dentro del rango de fechas en todo el sistema
$archivosRecientes = Get-ChildItem -File -Recurse -Path "C:\" | Where-Object { $_.LastWriteTime -ge $fechaInicio -and $_.LastWriteTime -le $fechaFin }

## Mostrar los archivos recientes dentro del rango
foreach ($archivo in $archivosRecientes) {
	Write-Host $archivo.FullName
}
#Programas instalados
gwmi  Win32_Product
#Programas abiertos
Get-Process

#Historial de navegación
Get-History | Where-Object { $_.StartTime -ge $fechaInicio -and $_.StartTime -le $fechaFin }

#Dispositivos conectados
$dispositivos = Get-PnpDevice | Where-Object { $_.Status -eq 'OK' }
foreach ($dispositivo in $dispositivos) {
	Write-Host "Dispositivo: $($dispositivo.DeviceName)"
	Write-Host "ID de instancia: $($dispositivo.InstanceId)"
	Write-Host "Clase: $($dispositivo.ClassName)"
	Write-Host "Fabricante: $($dispositivo.Manufacturer)"
	Write-Host "Estado: $($dispositivo.Status)"
	Write-Host "-----"
}
#Eventos de log
Show-EventLog

