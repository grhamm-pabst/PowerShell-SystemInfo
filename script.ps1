function Report {

    $computer_name = HOSTNAME.EXE

    $services = Get-Services-Limited 10

    $computer_specs = Get-Computer-Specs

    Write-Output-Report-Data $computer_name, $services, $computer_specs
    
}

function ConvertTo-Html-Report {

    $date = Get-Date -Format "dddd dd/MM/yyyy HH:mm"

    $computer_name = HOSTNAME.EXE

    $services = Get-Services-Limited 10

    $computer_specs = Get-Computer-Specs

    $name_html = "<h1>Computer name: ${computer_name}</h1>"

    $services_html = $services | ConvertTo-Html -Property Name, DisplayName, Status -Fragment

    $specs_html = @"
    <div>
    <p>OS: $($computer_specs.OS)</p>
    <p>Bios: $($computer_specs.Bios)</p>
    <p>Disk: $($computer_specs.Disk)</p>
    <p>Free Memory: $($computer_specs.FreeMemory)</p>
    </div>
"@

    @"
    <html>
    <body>
    ${name_html}
    <p>${date}</p>
    <h2>Services</h2>
    ${services_html}
    <h2>Specs</h2>
    ${specs_html}
    </body>
    </html>
"@ | Out-File ./report.html
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

function Write-Output-Specs-Data {
    $computer_specs = Get-Computer-Specs

    Write-Output $computer_specs | Format-List
    
}

function Get-Computer-Specs {

    $os_specs = Get-ComputerInfo

    $disk_info = Get-Disk

    $os_name = $os_specs.OsName
    $free_memory = $os_specs.OsFreePhysicalMemory
    $disk = $disk_info[0].Size
    $bios = $os_specs.BiosBIOSVersion

    $Row = "" | Select-Object OS, Disk, Bios, FreeMemory
    $Row.OS = $os_name
    $Row.Disk = "${disk} MB"
    $Row.Bios = $bios
    $Row.FreeMemory = "${free_memory} MB"

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
    "specs" {Write-Output-Specs-Data}
    "name" {HOSTNAME.EXE}
    "report" {Report}
    "build" {ConvertTo-Html-Report}
    Default {"No such command"}
}