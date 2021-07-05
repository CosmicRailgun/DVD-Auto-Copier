#Check if DVD loaded
$dvdLoaded = (Get-WMIObject -Class Win32_CDROMDrive -Property *).MediaLoaded



if ($dvdLoaded)
{
    Write-Output "Beginning DVD transfer"

    #Set DVD drive letter
    $DVDDrive = (Get-WMIObject -Class Win32_CDROMDrive -Property *).Drive
    
    #Handbrake Preset Setup
    .\HandBrakeCLI --preset-import-file C:\Users\admin\Desktop\HandBrakeCLI-1.3.3-win-x86_64\presets\DVD.json -Z "DVD"

    #Get DVD Name
    $TitleName = (Get-WMIObject -Class Win32_CDROMDrive -Property *).VolumeName

    #Set Directory
    $Dir = "G:\.shortcut-targets-by-id\1o3N6eDlaq5JiH_0lXKtbXLfv5ASNqXms\DVD-CD-Archive\RAW-RIPS\$TitleName\"

    for ($title = 1 ; $title -le 30 ; $title++){
        
        #Encode
        .\HandBrakeCLI --preset-import-file C:\Users\admin\Desktop\HandBrakeCLI-1.3.3-win-x86_64\presets\DVD.json -Z "DVD" -t $title -scan -min-duration 60 -i $DVDDrive\ -o "G:\.shortcut-targets-by-id\1o3N6eDlaq5JiH_0lXKtbXLfv5ASNqXms\DVD-CD-Archive\RAW-RIPS\$TitleName\$TitleName-$Title.mp4"
        
        #Checks to see if the file is large, if it is, the system will assume it's a movie and annihilate all files smaller than it
        $FileSize = ((Get-Item "G:\.shortcut-targets-by-id\1o3N6eDlaq5JiH_0lXKtbXLfv5ASNqXms\DVD-CD-Archive\RAW-RIPS\$TitleName\$TitleName-$Title.mp4").length/1MB)
        if ( $FileSize > 600 ){
        $Movie = $true
        }
    }

    Write-Output "Transfer Complete"

    #Eject Disk
    start powershell .\eject.ps1

    #Check if movie or not


    if ( $Movie ) {
        $SizeMin = 500 #MB
        Get-ChildItem -Path $Dir -Recurse | Where { $_.Length / 1MB -lt $SizeMin } | Remove-Item -Force

    }else{
        #Delete Tiny Titles/Transfers
        $SizeMin = 40 #MB
        Get-ChildItem -Path $Dir -Recurse | Where { $_.Length / 1MB -lt $SizeMin } | Remove-Item -Force
    }

    
    

}

Start-Sleep -s 10

#close other instance of powershell
Get-Process Powershell  | Where-Object { $_.ID -ne $pid } | Stop-Process
.\restart.ps1