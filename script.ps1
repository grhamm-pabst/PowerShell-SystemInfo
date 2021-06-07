function Report {

    $computer_name = HOSTNAME.EXE

    $services = Get-Services-Limited 10

    $computer_specs = Get-Computer-Specs

    Write-Output-Report-Data $computer_name, $services, $computer_specs
    
}

function Write-Output-Report-Data {
    param (
        $computer_name,
        $services,
        $computer_specs
    )
    
    Write-Output "Computer name: " $computer_name

    foreach($service in $services){
        Write-Output $service
    }

    foreach($spec in $computer_specs) {
        Write-Output $spec
    }
}

function Get-Services-Limited {
    param (
        $max_services = 10
    )

    Get-Service | Select-Object -First $max_services

}

function Get-Computer-Specs {

    $os_specs = Get-ComputerInfo

    $os_name = $os_specs.OsName
    $memory = $os_specs.OsFreePhysicalMemory
    $processor = $os_specs.CsProcessors
    $bios = $os_specs.BiosBIOSVersion

    $Row = "" | Select-Object OS, Processor, Bios, FreeMemory
    $Row.OS = $os_name
    $Row.Processor = $processor
    $Row.Bios = $bios
    $Row.FreeMemory = "${memory} MB"

    $Row
}

$arg = $args[0]

switch ($arg) {
    "services" {if($null -eq $args[1]){
        Get-Services-Limited
    }
    else {
        Get-Services-Limited $args[1]
    }}
    "specs" {Get-Computer-Specs}
    "name" {HOSTNAME.EXE}
    "report" {Report}
    Default {"No such command"}
}