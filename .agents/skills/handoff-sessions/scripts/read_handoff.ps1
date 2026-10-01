[CmdletBinding(DefaultParameterSetName = 'List')]
param(
    [Parameter(Mandatory = $true, ParameterSetName = 'List')]
    [switch] $List,

    [Parameter(Mandatory = $true, ParameterSetName = 'Session')]
    [ValidatePattern('^[A-Za-z0-9_-]+$')]
    [string] $SessionId,

    [Parameter(Mandatory = $true, ParameterSetName = 'Path')]
    [string] $Path,

    [ValidateRange(1, 200)]
    [int] $Limit = 50
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-TranscriptRoots {
    $roots = [System.Collections.Generic.List[string]]::new()
    if ($env:CODEX_HOME) { $roots.Add((Join-Path $env:CODEX_HOME 'sessions')) }
    if ($env:USERPROFILE) { $roots.Add((Join-Path $env:USERPROFILE '.codex\\sessions')) }
    if ($env:APPDATA) {
        Get-ChildItem -LiteralPath (Join-Path $env:APPDATA 'orca\\codex-accounts') -Directory -ErrorAction SilentlyContinue |
            ForEach-Object { $roots.Add((Join-Path $_.FullName 'home\\sessions')) }
    }
    $roots | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -Unique
}

function Get-TranscriptFiles {
    Get-TranscriptRoots | ForEach-Object {
        Get-ChildItem -LiteralPath $_ -Recurse -File -Filter '*.jsonl' -ErrorAction SilentlyContinue
    } | Sort-Object FullName -Unique | Sort-Object LastWriteTimeUtc -Descending
}

function Get-SessionLabel([System.IO.FileInfo] $File) {
    $firstLine = Get-Content -LiteralPath $File.FullName -TotalCount 1 -ErrorAction SilentlyContinue
    try {
        $first = $firstLine | ConvertFrom-Json
        if ($first.payload.id) { return [string]$first.payload.id }
        if ($first.payload.session_id) { return [string]$first.payload.session_id }
    } catch { }
    return $File.BaseName
}

function Get-TextFromContent($Content) {
    if ($null -eq $Content) { return $null }
    if ($Content -is [string]) { return $Content }
    $parts = foreach ($item in @($Content)) {
        if ($item -is [string]) { $item; continue }
        if ($item.text) { [string]$item.text; continue }
        if ($item.content) { Get-TextFromContent $item.content; continue }
    }
    ($parts | Where-Object { $_ }) -join "`n"
}

function Convert-RecordToMessage($Record) {
    $payload = $Record.payload
    if ($null -eq $payload) { return $null }
    $role = [string]$payload.role
    $body = Get-TextFromContent $payload.content
    if (-not $body -and $payload.message) { $body = Get-TextFromContent $payload.message }
    if (-not $body -and $payload.text) { $body = [string]$payload.text }
    if (-not $body -and $payload.input) { $body = Get-TextFromContent $payload.input }
    if ($role -notin @('user', 'assistant')) {
        if ($payload.type -eq 'user_message') { $role = 'user' }
        elseif ($payload.type -in @('agent_message', 'assistant_message')) { $role = 'assistant' }
    }
    if ($role -notin @('user', 'assistant') -or [string]::IsNullOrWhiteSpace($body)) { return $null }
    [pscustomobject]@{ timestamp = $Record.timestamp; role = $role; text = $body.Trim() }
}

if ($List) {
    $items = foreach ($file in Get-TranscriptFiles) {
        [pscustomobject]@{
            session_id = Get-SessionLabel $file
            modified = $file.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss')
            size_kb = [math]::Round($file.Length / 1KB, 1)
            path = $file.FullName
        }
    }
    $items | Select-Object -First $Limit | Format-Table -AutoSize
    exit 0
}

if ($PSCmdlet.ParameterSetName -eq 'Path') {
    $file = Get-Item -LiteralPath $Path -ErrorAction Stop
    if ($file.Extension -ne '.jsonl') { throw 'Only an exported Codex .jsonl transcript may be imported.' }
} else {
    $matches = Get-TranscriptFiles | Where-Object { (Get-SessionLabel $_) -eq $SessionId -or $_.BaseName -eq $SessionId }
    if (@($matches).Count -eq 0) { throw "No local transcript found for session ID '$SessionId'." }
    if (@($matches).Count -gt 1) { throw "More than one local transcript matches '$SessionId'. Import by explicit -Path instead." }
    $file = @($matches)[0]
}

$messages = foreach ($line in Get-Content -LiteralPath $file.FullName) {
    try { Convert-RecordToMessage ($line | ConvertFrom-Json) } catch { }
}

if (-not $messages) { throw 'The selected transcript contains no readable user or assistant messages.' }

"# Local session handoff"
"Source: $($file.Name)"
"Messages shown: last $([math]::Min($Limit, @($messages).Count)) of $(@($messages).Count)"
""
$messages | Select-Object -Last $Limit | ForEach-Object {
    "## $($_.role) $($_.timestamp)"
    $_.text
    ""
}
