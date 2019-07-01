$ScriptPath = "C:\Scripts\SynsHosts.acg.ps1"

function Schedule-SyncHosts ($ScriptPath)
{
    $Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 5) -RepetitionDuration ([System.TimeSpan]::MaxValue)
    $User = "NT AUTHORITY\SYSTEM"
    $Action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "$ScriptPath"
    Register-ScheduledTask -TaskName "MonitorGroupMembership" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest –Force
}

Schedule-SyncHosts $ScriptPath