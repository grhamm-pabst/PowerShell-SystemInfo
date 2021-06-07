function Get-Sys-Info {
    param (
        $arg
    )

    Write-Output "${arg}"

    $computer_name = HOSTNAME.EXE

    $services = Get-Services-Limited 10

    Write-Output $computer_name

    foreach($service in $services){
        Write-Output $service
    }

    Write-Output "`n"

    $computer_specs = Get-Computer-Specs

    foreach($spec in $computer_specs) {
        Write-Output $spec
    }
    
}

function Get-Services-Limited {
    param (
        $max_services
    )

    Get-Service | Select-Object -First $max_services

}

function Get-Computer-Specs {
    $OSInfo = Get-CimInstance -ClassName Win32_OperatingSystem
    $ProcessorInfo = Get-CimInstance -ClassName Win32_Processor
    $BiosInfo = Get-CimInstance -ClassName Win32_BIOS
    $MemoryInfo = Get-CimInstance -ClassName Win32_PhysicalMemory

    $Row = "" | Select-Object OS, Processor, Bios, Memory
    $Row.OS = $OSInfo
    $Row.Processor = $ProcessorInfo
    $Row.Bios = $BiosInfo
    $Row.Memory = $MemoryInfo

    $Row
}

$arg = $args[0]

switch ($arg) {
    "services" {Get-Services-Limited $args[1]}
    Default {"No"}
}

# Get-Sys-Info $arg
