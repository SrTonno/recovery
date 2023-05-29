Import-Module PSSQLite

param
(
	[Parameter(Position = 0, Mandatory = $false, ValueFromRemainingArguments = $true)]
	[object[]] $argv
)
$patron = "^\d{4}-\d{2}-\d{2} \d{2}:\d{2}$"
$patron2 = "^\d{2}-\d{2}-\d{4} \d{2}:\d{2}$"

if ($argv.Count -eq 2)
{
	if ($argv[0] -match $patron) -and ($argv[1] -match $patron)
	{
		$fechaInicio = Get-Date $argv[0] -Format "yyyy-MM-dd HH:mm"
		$fechaFin = Get-Date $argv[1] -Format "yyyy-MM-dd HH:mm"
	}
	else
	{
		return
	}
}
else
{
	$fechaInicio = Get-Date "2023-01-01 00:00"
	$fechaFin = Get-Date "2023-02-28 23:59"
}

$fechaFormateada_Inicio = Get-Date $fechaInicio -Format "yyyyMMdd"
$fechaFormateada_Fin = Get-Date $fechaFin -Format "yyyyMMdd"

function Sleep() {
	Write-Host "Presiona Enter para continuar..."
	$null = Read-Host
}

#-Obtención de la hora local de un equipo https://learn.microsoft.com/es-es/powershell/scripting/samples/collecting-information-about-computers?view=powershell-7.3
Get-CimInstance -ClassName Win32_LocalTime
sleep
#Fechas de cambio de ramas de registro (CurrentVersionRun) http://www.hispasec.com/resources/soft/RegistryDate.zip
$rutaRegistro = "HKCU:\Software\Microsoft\Windows\CurrentVersion\*"
## Obtener la propiedad de fecha de modificación de la clave del Registro
$fechaModificacion = Get-ItemProperty -Path $rutaRegistro | Select-Object -ExpandProperty PSChildName
## Convertir la fecha de modificación a objeto DateTime
$fechaModificacion = [DateTime]::ParseExact($fechaModificacion, "yyyy-MM-dd:HH.mm", $null)

## Verificar si la fecha de modificación está dentro del rango especificado
if ($fechaModificacion -ge $fechaInicio -and $fechaModificacion -le $fechaFin)
{
	Write-Host "La fecha de modificación se encuentra dentro del rango especificado."
}
else
{
	Write-Host "La fecha de modificación está fuera del rango especificado."
}
Sleep
#Archivos recientes //funciona
$archivosRecientes = Get-ChildItem -File -Recurse -Path "C:\" | Where-Object { $_.LastWriteTime -ge $fechaInicio -and $_.LastWriteTime -le $fechaFin }
Sleep
## Mostrar los archivos recientes dentro del rango
foreach ($archivo in $archivosRecientes)
{
	Write-Host $archivo.FullName
}
Sleep
#Programas instalados //Funciona
(Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*) + (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* ) | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Where-Object { $_.InstallDate -ge $fechaFormateada_Inicio -and $_.InstallDate -le $fechaFormateada_Fin } | Format-Table –AutoSize
Sleep
#Programas abiertos // funciona
Get-Process
Sleep
#Historial de navegación
Get-History | Where-Object { $_.StartTime -ge $fechaInicio -and $_.StartTime -le $fechaFin }
Sleep
#Dispositivos conectados // funciona
Get-PnpDevice | Where-Object { $_.Status -eq 'OK' } | Select-Object Class, FriendlyName, InstanceId | Format-Table -AutoSize
Sleep
#Eventos de log //funciona
Get-WinEvent -LogName "Application" | Where-Object { $_.TimeCreated -ge $fechaInicio -and $_.TimeCreated -le $fechaFin }

