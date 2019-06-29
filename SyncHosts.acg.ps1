$HostFileName="hosts.acg"
$DestinationFolder="C:\Temp\DNSStuff"

function Sync-Hosts ($HostFileName, $DestinationFolder)
{
    if (!(Test-Path $DestinationFolder))
    {
        $DestinationFolder = "C:\Windows\System32\drivers\etc" 
    }

    $OriginalHostFileName="hosts"
    $CommitHistoryUrl="https://api.github.com/repos/amit-g/DNSStuff/commits?path=${HostFileName}"
    $HostFileUrl="https://raw.githubusercontent.com/amit-g/DNSStuff/master/${HostFileName}"

    $LastCommitSHAFileName="${HostFileName}.sha"
    $LastCommitSHAFilePath="$DestinationFolder\$LastCommitSHAFileName"

    $CommitHistory=(curl $CommitHistoryUrl).Content | ConvertFrom-Json
    $LatestCommitSHA=$CommitHistory[0].sha

    if (!(Test-Path "$LastCommitSHAFilePath"))
    {
        New-Item -path $DestinationFolder -name $LastCommitSHAFileName -type "file"

        Write-Verbose "$LastCommitSHAFilePath Created"
    }
    else
    {
        Write-Verbose "$LastCommitSHAFilePath Exists"
    }

    $CurrentCommitSHA = Get-Content "$LastCommitSHAFilePath"

    Write-Verbose "CurrentCommitSHA: $CurrentCommitSHA"
    Write-Verbose "LatestCommitSHA: $LatestCommitSHA"

    if ($CurrentCommitSHA -ne $LatestCommitSHA)
    {
        curl $HostFileUrl > "$DestinationFolder\$OriginalHostFileName"
        Write-Output $LatestCommitSHA > "$LastCommitSHAFilePath"

        Write-Verbose "Host file synced"
    }
    else {
        Write-Verbose "Host file is already current"
    }
}

Sync-Hosts $HostFileName $DestinationFolder