# Definir las fechas de inicio y fin del rango
$fechaInicio = Get-Date "2023-01-01 00:00"
$fechaFormateada_Inicio = Get-Date $fechaInicio -Format "yyyyMMdd"
$fechaFin = Get-Date "2023-02-28 23:59"
$fechaFormateada_Fin = Get-Date $fechaFin -Format "yyyyMMdd"

#-Obtención de la hora local de un equipo https://learn.microsoft.com/es-es/powershell/scripting/samples/collecting-information-about-computers?view=powershell-7.3
Get-CimInstance -ClassName Win32_LocalTime
#Fechas de cambio de ramas de registro (CurrentVersionRun) http://www.hispasec.com/resources/soft/RegistryDate.zip
$rutaRegistro = "HKCU:\Software\Microsoft\Windows\CurrentVersion"
## Obtener la propiedad de fecha de modificación de la clave del Registro
$fechaModificacion = Get-ItemProperty -Path $rutaRegistro | Select-Object -ExpandProperty PSChildName
## Convertir la fecha de modificación a objeto DateTime
$fechaModificacion = [DateTime]::ParseExact($fechaModificacion, "yyyy-MM-dd:HH.mm", $null)

## Verificar si la fecha de modificación está dentro del rango especificado
if ($fechaModificacion -ge $fechaInicio -and $fechaModificacion -le $fechaFin) {
	Write-Host "La fecha de modificación se encuentra dentro del rango especificado."
} else {
	Write-Host "La fecha de modificación está fuera del rango especificado."
}
#Archivos recientes //funciona
## Obtener archivos recientes dentro del rango de fechas en todo el sistema
$archivosRecientes = Get-ChildItem -File -Recurse -Path "C:\" | Where-Object { $_.LastWriteTime -ge $fechaInicio -and $_.LastWriteTime -le $fechaFin }

## Mostrar los archivos recientes dentro del rango
foreach ($archivo in $archivosRecientes) {
	Write-Host $archivo.FullName
}
#Programas instalados //Funciona
##32bits
Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Where-Object { $_.InstallDate -ge $fechaFormateada_Inicio -and $_.InstallDate -le $fechaFormateada_Fin }| Format-Table –AutoSize
##64bist
Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Where-Object { $_.InstallDate -ge $fechaFormateada_Inicio -and $_.InstallDate -le $fechaFormateada_Fin } | Format-Table –AutoSize
#Programas abiertos // funciona
Get-Process

#Historial de navegación
Get-History | Where-Object { $_.StartTime -ge $fechaInicio -and $_.StartTime -le $fechaFin }

#Dispositivos conectados // funciona
Get-PnpDevice | Where-Object { $_.Status -eq 'OK' } | Select-Object Class, FriendlyName, InstanceId | Format-Table –AutoSize
#Eventos de log
Show-EventLog


