param(
    [Parameter(Mandatory=$true,HelpMessage='The name of the program')][string]$ProgramName,
    [Parameter(Mandatory=$true,HelpMessage='The setting (2 = show icon and notifications 1 = hide icon and notifications, 0 = only show notifications')]
        [ValidateScript({if ($_ -lt 0 -or $_ -gt 2) { throw 'Invalid setting' } return $true})]
        [Int16]$Setting
    )

$encText = New-Object System.Text.UTF8Encoding
[byte[]] $bytRegKey = @()
$strRegKey = ""
$bytRegKey = $(Get-ItemProperty $(Get-Item 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify').PSPath).IconStreams
for($x=0; $x -le $bytRegKey.Count; $x++)
{
    $tempString = [Convert]::ToString($bytRegKey[$x], 16)
    switch($tempString.Length)
    {
        0 {$strRegKey += "00"}
        1 {$strRegKey += "0" + $tempString}
        2 {$strRegKey += $tempString}
    }
}
[byte[]] $bytTempAppPath = @()
$bytTempAppPath = $encText.GetBytes($ProgramName)
[byte[]] $bytAppPath = @()
$strAppPath = ""

Function Rot13($byteToRot)
{
    if($byteToRot -gt 64 -and $byteToRot -lt 91)
    {
        $bytRot = $($($byteToRot - 64 + 13) % 26 + 64)
        return $bytRot
    }
    elseif($byteToRot -gt 96 -and $byteToRot -lt 123)
    {
        $bytRot = $($($byteToRot - 96 + 13) % 26 + 96)
        return $bytRot
    }
    else
    {
        return $byteToRot
    }
}

for($x = 0; $x -lt $bytTempAppPath.Count * 2; $x++)
{
    If($x % 2 -eq 0)
    {
        $curbyte = $bytTempAppPath[$([Int]($x / 2))]
            $bytAppPath += Rot13($curbyte)

    }
    Else
    {
        $bytAppPath += 0
    }
}

for($x=0; $x -lt $bytAppPath.Count; $x++)
{
    $tempString = [Convert]::ToString($bytAppPath[$x], 16)
    switch($tempString.Length)
    {
        0 {$strAppPath += "00"}
        1 {$strAppPath += "0" + $tempString}
        2 {$strAppPath += $tempString}
    }
}
if(-not $strRegKey.Contains($strAppPath))
{
    Write-Host Program not found. Programs are case sensitive.
    break
}

[byte[]] $header = @()
$items = @{}
for($x=0; $x -lt 20; $x++)
{
    $header += $bytRegKey[$x]
}

for($x=0; $x -lt $(($bytRegKey.Count-20)/1640); $x++)
{
    [byte[]] $item=@()
    $startingByte = 20 + ($x*1640)
    $item += $bytRegKey[$($startingByte)..$($startingByte+1639)]
    $items.Add($startingByte.ToString(), $item)
}

foreach($key in $items.Keys)
{
$item = $items[$key]
    $strItem = ""
    $tempString = ""

    for($x=0; $x -le $item.Count; $x++)
    {
        $tempString = [Convert]::ToString($item[$x], 16)
        switch($tempString.Length)
        {
            0 {$strItem += "00"}
            1 {$strItem += "0" + $tempString}
            2 {$strItem += $tempString}
        }
    }
    if($strItem.Contains($strAppPath))
    {
        Write-Host Item Found with $ProgramName in item starting with byte $key
            $bytRegKey[$([Convert]::ToInt32($key)+528)] = $setting
            Set-ItemProperty $($(Get-Item 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify').PSPath) -name IconStreams -value $bytRegKey
    }
}