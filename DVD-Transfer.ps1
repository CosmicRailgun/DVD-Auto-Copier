#DVD complete sound
Function DVD-Done {
	[System.Console]::Beep(659, 100);
	[System.Console]::Beep(659, 105);
	[System.Threading.Thread]::Sleep(125);
	[System.Console]::Beep(659, 100);
	[System.Threading.Thread]::Sleep(167);
	[System.Console]::Beep(523, 100);
	[System.Console]::Beep(659, 110);
	[System.Threading.Thread]::Sleep(125);
	[System.Console]::Beep(784, 125);
	[System.Threading.Thread]::Sleep(375);
	[System.Console]::Beep(392, 125);
}

#Set Preset
$PresetID = "DVD"
$PresetFile = "DVD.json"


#Loop
while ($true){


#Check if DVD loaded
$dvdLoaded = (Get-WMIObject -Class Win32_CDROMDrive -Property *).MediaLoaded





if ($dvdLoaded)
{
    Write-Output "Beginning DVD transfer"

    #Set and Make Directory
    New-Item -Path "C:\Users\admin\Desktop\DVD-RIP\" -Name "$TitleName" -ItemType "directory"
    $Dir = "C:\Users\admin\Desktop\DVD-RIP\$TitleName\"

    #Set DVD drive letter
    $DVDDrive = (Get-WMIObject -Class Win32_CDROMDrive -Property *).Drive
    
    #Handbrake Preset Setup
    .\HandBrakeCLI --preset-import-file .\Presets\$PresetFile -Z "$PresetID"

    #Get DVD Name
    $TitleName = (Get-WMIObject -Class Win32_CDROMDrive -Property *).VolumeName

    for ($title = 1 ; $title -le 30 ; $title++){
        
        #Encode
        .\HandBrakeCLI --preset-import-file .\Presets\$PresetFile -Z "$PresetID" -t $title -scan -min-duration 60 -i $DVDDrive\ -o "$Dir$TitleName-$Title.mp4"
        
        #Checks to see if the file is large, if it is, the system will assume it's a movie and annihilate all files smaller than it
        $FileSize = ((Get-Item "$Dir$TitleName-$Title.mp4").length/1MB)
        if ( $FileSize -gt 1200 ){
            $Movie = $true
            }

        if ($Movie){
            $title = 31
            }
    }

    Write-Output "Transfer Complete"

    #Eject Disk
    start powershell .\eject.ps1
    DVD-Done
    #close other instance of powershell
    Get-Process Powershell  | Where-Object { $_.ID -ne $pid } | Stop-Process

    #Check if movie or not


    if ( $Movie ) {
        $SizeMin = 600 #MB
        Get-ChildItem -Path $Dir -Recurse | Where { $_.Length / 1MB -lt $SizeMin } | Remove-Item -Force

    }else{
        #Delete Tiny Titles/Transfers
        $SizeMin = 100 #MB
        Get-ChildItem -Path $Dir -Recurse | Where { $_.Length / 1MB -lt $SizeMin } | Remove-Item -Force
    }

    
    

}

Start-Sleep -s 2

#Write time/date
Get-Date | Out-File -FilePath .\log.txt


}
