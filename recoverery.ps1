param
(
	[Parameter(Position = 0, Mandatory = $false, ValueFromRemainingArguments = $true)]
	[object[]] $argv
)
$patron = '^\d{4}.+?\d{2}.+?\d{2}.+?( \d{2}:\d{2})?$'
$patron2 = '^\d{2}-\d{2}-\d{4}( \d{2}:\d{2})?$'

if ($argv.Count -eq 2)
{
	if (($argv[0] -match $patron2) -and ($argv[1] -match $patron2))
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
	Write-Host "Hola"
	$fechaInicio =  Get-Date -Format "yyyy-MM-dd HH:mm"
	$fechaFin = (Get-Date).AddDays(-1).ToString("yyyy-MM-dd HH:mm")
}
Write-Host "El filtrado de fecha es: $FechaInicio a $FechaFin"
$fechaFormateada_Inicio = Get-Date $fechaInicio -Format "yyyyMMdd"
$fechaFormateada_Fin = Get-Date $fechaFin -Format "yyyyMMdd"

$fechaFormateada_Inicio2 = Get-Date $fechaInicio -Format "yyyy-MM-dd"
$fechaFormateada_Fin2 = Get-Date $fechaFin -Format "yyyy-MM-dd"

function ft_Sleep() {
	Write-Host "Presiona Enter para continuar..."
	$null = Read-Host
}

#-Obtención de la hora local de un equipo https://learn.microsoft.com/es-es/powershell/scripting/samples/collecting-information-about-computers?view=powershell-7.3
Get-CimInstance -ClassName Win32_LocalTime
ft_Sleep
#Fechas de cambio de ramas de registro (CurrentVersionRun) http://www.hispasec.com/resources/soft/RegistryDate.zip
#$rutaRegistro = "HKCU:\Software\Microsoft\Windows\CurrentVersion\*"
## Obtener la propiedad de fecha de modificación de la clave del Registro
#$fechaModificacion = Get-ItemProperty -Path $rutaRegistro | Select-Object -ExpandProperty PSChildName
## Convertir la fecha de modificación a objeto DateTime
#$fechaModificacion = [DateTime]::ParseExact($fechaModificacion, "yyyy-MM-dd:HH.mm", $null)

## Verificar si la fecha de modificación está dentro del rango especificado
#if ($fechaModificacion -ge $fechaInicio -and $fechaModificacion -le $fechaFin)
#{
#	Write-Host "La fecha de modificación se encuentra dentro del rango especificado."
#}
#else
#{
#	Write-Host "La fecha de modificación está fuera del rango especificado."
#}
#ft_Sleep
#Archivos recientes //funciona
Write-Host "Archivos recientes"
$archivosRecientes = Get-ChildItem -File -Recurse -Path "C:\Users\" | Where-Object { $_.LastWriteTime -ge $fechaInicio -and $_.LastWriteTime -le $fechaFin }
## Mostrar los archivos recientes dentro del rango
foreach ($archivo in $archivosRecientes)
{
	Write-Host $archivo.FullName
}
ft_Sleep
#Programas instalados //Funciona
Write-Host "Programas instalados"
(Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*) + (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* ) | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Where-Object { $_.InstallDate -ge $fechaFormateada_Inicio -and $_.InstallDate -le $fechaFormateada_Fin } | Format-Table -AutoSize
ft_Sleep
#Historial de navegación
Write-Host "Historial de navegación"
python ./history.py $fechaFormateada_Inicio2 $fechaFormateada_Fin2
ft_Sleep
#Dispositivos conectados // funciona
Write-Host "Dispositivos conectados"
Get-PnpDevice | Where-Object { $_.Status -eq 'OK' } | Select-Object Class, FriendlyName, InstanceId | Format-Table -AutoSize
ft_Sleep
#Eventos de log //funciona
Write-Host "Eventos de log"
Get-WinEvent -LogName "Application" | Where-Object { $_.TimeCreated -ge $fechaInicio -and $_.TimeCreated -le $fechaFin }
ft_Sleep
#Archivos temporales
Write-Host "Archivos temporales"
$TempPath = [System.IO.Path]::GetTempPath()
Get-ChildItem -Path $TempPath | Where-Object { $_.LastWriteTime -ge $fechaInicio -and $_.LastWriteTime -le $fechaFin } | Format-Table -AutoSize
ft_Sleep
#Programas abiertos // funciona
Write-Host "Programas abiertos"
Get-Process

