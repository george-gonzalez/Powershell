#Script used to add the File Version attribute to the Get-Item Commandlet.
#It can then be used to query the version of a file.
#George Gonzalez
#Version 2018.11.30.1


#Adds the File Info to Get-Item

Update-TypeData -TypeName System.Io.FileInfo -MemberType ScriptProperty -MemberName FileVersionUpdated -Value {

    New-Object System.Version -ArgumentList @(

        $this.VersionInfo.FileMajorPart

        $this.VersionInfo.FileMinorPart

        $this.VersionInfo.FileBuildPart

        $this.VersionInfo.FilePrivatePart

    )

}

# Sets Variables - in this case for Zoom Version

$okZoom = "4.1.34814.1119"

$installedZoom = (Get-Item C:\Users\*\AppData\Roaming\Zoom\bin\Zoom.exe).FileVersionUpdated 

#Compares the variables above and writes out based on the comparison.

if ($installedZoom -like $okZoom) {

Write-Host "0"
} else {Write-Host "1"
}

