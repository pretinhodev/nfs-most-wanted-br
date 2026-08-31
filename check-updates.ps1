#Requires -Version 5.1
<#
.SYNOPSIS
  Verificador de atualizações do Need for Speed: Most Wanted - Black Edition.
.DESCRIPTION
  Consulta as fontes oficiais (GitHub) e informa se há versão mais recente
  dos mods (Widescreen Fix, Extra Options, XtendedInput) em relação ao que
  está instalado. NÃO baixa nem substitui nada - apenas reporta com o
  manual/URL de onde obter a atualização.
.EXAMPLE
  powershell -ExecutionPolicy Bypass -File check-updates.ps1
#>

[CmdletBinding()]
param(
    [string]$GamePath = ''
)

$ErrorActionPreference = 'Continue'
$DefaultGamePath = 'C:\Program Files (x86)\DODI-Repacks\Need For Speed Most Wanted Black Edition'

function Write-Step {
    param([string]$Message)
    Write-Host "`n==> $Message" -ForegroundColor Cyan
}

function Get-Str {
    param($Val)
    if ($null -eq $Val) { return '' }
    return "$Val"
}

function Get-GithubJson {
    param([string]$Uri)
    try {
        return Invoke-RestMethod -Uri $Uri -Headers @{ 'User-Agent' = 'ps' } -ErrorAction Stop
    }
    catch {
        Write-Warning "  (erro ao consultar $Uri : $($_.Exception.Message))"
        return $null
    }
}

function Get-LatestAsset {
    param([string]$Repo, [string]$AssetName)
    $rels = Get-GithubJson "https://api.github.com/repos/$Repo/releases?per_page=100"
    if (-not $rels) { return $null }
    return $rels | ForEach-Object {
        $rel = $_
        $a = $rel.assets | Where-Object { $_.name -eq $AssetName }
        if ($a) {
            $d = $null; try { $d = [datetime]$rel.published_at } catch { $d = [datetime]::MinValue }
            [pscustomobject]@{ Tag = (Get-Str $rel.tag_name); Date = $d; Url = (Get-Str $a.browser_download_url) }
        }
    } | Sort-Object Date -Descending | Select-Object -First 1
}

function Get-LatestTag {
    param([string]$Repo)
    $tags = Get-GithubJson "https://api.github.com/repos/$Repo/tags?per_page=5"
    if (-not $tags -or $tags.Count -eq 0) { return $null }
    return [pscustomobject]@{ Tag = (Get-Str $tags[0].name); Url = "https://github.com/$Repo/releases" }
}

function Get-LatestRelease {
    param([string]$Repo)
    $rel = Get-GithubJson "https://api.github.com/repos/$Repo/releases?per_page=1"
    if (-not $rel -or $rel.Count -eq 0) { return $null }
    $d = $null; try { $d = [datetime]$rel[0].published_at } catch { $d = [datetime]::MinValue }
    return [pscustomobject]@{ Tag = (Get-Str $rel[0].tag_name); Date = $d; Url = "https://github.com/$Repo/releases" }
}

# ---------------------------------------------------------------------------
# 1) Pasta do jogo
# ---------------------------------------------------------------------------
Write-Step 'Pasta do jogo'
if (-not $GamePath) {
    if (Test-Path -LiteralPath $DefaultGamePath) { $GamePath = $DefaultGamePath }
    else { $GamePath = Read-Host 'Digite o caminho da instalação do jogo (onde fica o speed.exe)' }
}
if (-not (Test-Path -LiteralPath (Join-Path $GamePath 'speed.exe'))) {
    throw "Pasta do jogo inválida (speed.exe não encontrado): $GamePath"
}
Write-Host "  $GamePath"

$scriptsDir = Join-Path $GamePath 'scripts'

# ---------------------------------------------------------------------------
# 2) Widescreen Fix
# ---------------------------------------------------------------------------
Write-Step 'Widescreen Fix (ThirteenAG)'
$ws = Get-LatestAsset 'ThirteenAG/WidescreenFixesPack' 'NFSMostWanted.WidescreenFix.zip'
if ($ws) {
    Write-Host "  Fonte oficial: $($ws.Url)" -ForegroundColor DarkGray
    Write-Host "  (as builds estáveis/diárias ficam em: https://thirteenag.github.io/wfp - extraia o .zip na pasta do speed.exe)"
    $asi = Join-Path $scriptsDir 'NFSMostWanted.WidescreenFix.asi'
    if (Test-Path -LiteralPath $asi) {
        $d = (Get-Item -LiteralPath $asi).LastWriteTime
        Write-Host "  Instalado (asi): $($d.ToString('yyyy-MM-dd HH:mm'))"
        Write-Host "  Data da release oficial: $($ws.Date.ToString('yyyy-MM-dd'))" -ForegroundColor DarkGray
        if ($d -lt $ws.Date) {
            Write-Host "  DESATUALIZADO: avalie atualizar pelo site acima (manual, com backup)." -ForegroundColor Yellow
        }
        else {
            Write-Host "  atualizado." -ForegroundColor Green
        }
    }
    else {
        Write-Host "  .asi não encontrado." -ForegroundColor Yellow
    }
}

# ---------------------------------------------------------------------------
# 3) Extra Options
# ---------------------------------------------------------------------------
Write-Step 'Extra Options (ExOptsTeam)'
$ex = Get-LatestRelease 'ExOptsTeam/NFSMWExOpts'
if ($ex) {
    Write-Host "  Versão mais recente: $($ex.Tag) ($($ex.Date.ToString('yyyy-MM-dd')))"
    Write-Host "  Baixe em: $($ex.Url)" -ForegroundColor DarkGray
    $asi = Join-Path $scriptsDir 'NFSMWExtraOptions.asi'
    if (Test-Path -LiteralPath $asi) {
        $d = (Get-Item -LiteralPath $asi).LastWriteTime
        Write-Host "  Instalado (asi): $($d.ToString('yyyy-MM-dd HH:mm'))"
        if ($d -lt $ex.Date) {
            Write-Host "  DESATUALIZADO: a partir do site acima (o .zip traz NFSMWExtraOptions.asi e o Settings.ini)." -ForegroundColor Yellow
        }
        else {
            Write-Host "  atualizado." -ForegroundColor Green
        }
    }
    else {
        Write-Host "  NFSMWExtraOptions.asi não encontrado." -ForegroundColor Yellow
    }
}

# ---------------------------------------------------------------------------
# 4) XtendedInput (controle)
# ---------------------------------------------------------------------------
Write-Step 'XtendedInput (controle)'
$xi = Get-LatestAsset 'xan1242/NFS-XtendedInput' 'Release-MW-Pack.zip'
$xiAsi = Join-Path $scriptsDir 'NFS_XtendedInput.asi'
if (-not (Test-Path -LiteralPath $xiAsi)) {
    Write-Host "  NAO INSTALADO." -ForegroundColor Yellow
}
elseif ($xi) {
    $d = (Get-Item -LiteralPath $xiAsi).LastWriteTime
    Write-Host "  Instalado: $($d.ToString('yyyy-MM-dd HH:mm'))"
    Write-Host "  Mais recente: $($xi.Tag) ($($xi.Date.ToString('yyyy-MM-dd'))). Zip: $($xi.Url)" -ForegroundColor DarkGray
    if ($d -lt $xi.Date) {
        Write-Host "  DESATUALIZADO: baixe o zip acima e substitua NFS_XtendedInput.asi (mantenha seu .ini/perfil)." -ForegroundColor Yellow
    }
    else {
        Write-Host "  atualizado." -ForegroundColor Green
    }
}

# ---------------------------------------------------------------------------
# 5) HD Reflections
# ---------------------------------------------------------------------------
Write-Step 'HD Reflections (Aero_)'
$hdAsi = Join-Path $scriptsDir 'NFSMWHDReflections.asi'
if (Test-Path -LiteralPath $hdAsi) {
    $d = (Get-Item -LiteralPath $hdAsi).LastWriteTime
    Write-Host "  Instalado (asi): $($d.ToString('yyyy-MM-dd HH:mm'))"
    Write-Host "  Sem release no GitHub (EOL) - checagem manual." -ForegroundColor DarkGray
}
else {
    Write-Host "  NAO INSTALADO." -ForegroundColor Yellow
}
Write-Host "  Pagina/Download: https://nfsmods.xyz/mod/3363 (extraia NFSMWHDReflections.asi + .ini em scripts\)" -ForegroundColor DarkGray

# ---------------------------------------------------------------------------
# 6) Xbox Rain Droplets
# ---------------------------------------------------------------------------
Write-Step 'Xbox Rain Droplets (ThirteenAG)'
$rain = Get-LatestAsset 'ThirteenAG/XboxRainDroplets' 'NFSMostWanted.XboxRainDroplets.zip'
$rainAsi = Join-Path $scriptsDir 'NFSMostWanted.XboxRainDroplets.asi'
if (-not (Test-Path -LiteralPath $rainAsi)) {
    Write-Host "  NAO INSTALADO." -ForegroundColor Yellow
}
elseif ($rain) {
    $d = (Get-Item -LiteralPath $rainAsi).LastWriteTime
    Write-Host "  Instalado: $($d.ToString('yyyy-MM-dd HH:mm'))"
    Write-Host "  Mais recente: $($rain.Tag) ($($rain.Date.ToString('yyyy-MM-dd'))). Zip: $($rain.Url)" -ForegroundColor DarkGray
    if ($d -lt $rain.Date) {
        Write-Host "  DESATUALIZADO: baixe o zip acima e substitua NFSMostWanted.XboxRainDroplets.asi/.ini." -ForegroundColor Yellow
    }
    else {
        Write-Host "  atualizado." -ForegroundColor Green
    }
}

# ---------------------------------------------------------------------------
# 7) Front-End Shadows
# ---------------------------------------------------------------------------
Write-Step 'Front-End Shadows (Aero_)'
$feAsi = Join-Path $scriptsDir 'NFSMWFEShadows.asi'
if (Test-Path -LiteralPath $feAsi) {
    $d = (Get-Item -LiteralPath $feAsi).LastWriteTime
    Write-Host "  Instalado (asi): $($d.ToString('yyyy-MM-dd HH:mm'))"
    Write-Host "  No GitHub so o codigo (sem release) - checagem manual." -ForegroundColor DarkGray
}
else {
    Write-Host "  NAO INSTALADO." -ForegroundColor Yellow
}
Write-Host "  Pagina/Download: https://nfsmods.xyz/mod/3005 (extraia NFSMWFEShadows.asi + .ini em scripts\; NAO sobrescreva o dinput8.dll se ja existir mais novo)" -ForegroundColor DarkGray

# ---------------------------------------------------------------------------
# 8) Resumo
# ---------------------------------------------------------------------------
Write-Step 'Pronto!'
Write-Host '  Este script apenas VERIFICA. Nada foi baixado ou alterado.'
Write-Host '  Para atualizar: baixe, faça BACKUP do arquivo atual e substitua.'