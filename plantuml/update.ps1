import-module au

$releases = 'http://plantuml.com/changes.html'

function global:au_SearchReplace {
   @{

        ".\legal\VERIFICATION.txt" = @{
          "(?i)(\s+x32:).*"            = "`${1} $($Latest.URL32)"
          "(?i)(checksum32:).*"        = "`${1} $($Latest.Checksum32)"
          "(?i)(Get-RemoteChecksum).*" = "`${1} $($Latest.URL32)"
        }
    }
}

function global:au_BeforeUpdate {
    Get-RemoteFiles -Purge -FileNameBase plantuml -NoSuffix
    Write-Host 'Downloading manual'
    iwr $Latest.Manual -OutFile "tools\$(Split-Path -Leaf $Latest.Manual)"    
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases
    if ($download_page.Content -match 'V\d\.\d{4,4}\.\d+')
    {
        $version = $Matches[0].Substring(1)
        $url = "https://sourceforge.net/projects/plantuml/files/plantuml." + $version + '.jar/download'
    }
    else { throw "Can't match version 'V\d{4,4}'" }

    @{
        URL32    = $url
        Manual   = "http://plantuml.com/PlantUML_Language_Reference_Guide.pdf"
        Version  = $version
        FileType = 'jar'        
    }
}

update -NoCheckUrl -ChecksumFor none
