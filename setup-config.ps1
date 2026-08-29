#Requires -Version 5.1
<#
.SYNOPSIS
  Configurador do Need for Speed: Most Wanted - Black Edition (mods + ajustes).
.DESCRIPTION
  Copia os arquivos dos mods (ASI Loader, WidescreenFix, Extra Options e servidor LAN)
  para a pasta do jogo e ajusta as configuracoes (.ini) conforme a sua GPU.
.EXAMPLE
  powershell -ExecutionPolicy Bypass -File setup-config.ps1
#>

[CmdletBinding()]
param(
    [string]$GamePath = '',
    [int]$GpuProfile = 0,
    [switch]$EnableCamera,
    [switch]$InstallLan,
    [switch]$SkipPrompts
)

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$DefaultGamePath = 'C:\Program Files (x86)\DODI-Repacks\Need For Speed Most Wanted Black Edition'

function Write-Step {
    param([string]$Message)
    Write-Host "`n==> $Message" -ForegroundColor Cyan
}

function Set-IniKey {
    param([string]$Path, [string]$Section, [string]$Key, [string]$Value)
    $lines = [System.Collections.Generic.List[string]]::new()
    $inSection = $false
    $found = $false
    foreach ($line in Get-Content -LiteralPath $Path) {
        $trim = $line.Trim()
        if ($trim -match '^\[') {
            $inSection = ($trim -eq "[$Section]")
            $lines.Add($line)
            continue
        }
        if ($inSection -and $trim -notmatch '^;' -and $trim -match "^\s*$Key\s*=") {
            $comment = ''
            $idx = $line.IndexOf(';')
            if ($idx -ge 0) { $comment = $line.Substring($idx) }
            $lines.Add("$Key = $Value$comment")
            $found = $true
            continue
        }
        $lines.Add($line)
    }
    if (-not $found) {
        Write-Warning "Chave '$Key' nao encontrada na secao [$Section] de '$Path'."
    }
    Set-Content -LiteralPath $Path -Value $lines -Encoding UTF8
}

function Copy-IfExists {
    param([string]$Source, [string]$DestPath)
    if (-not (Test-Path -LiteralPath $Source)) {
        Write-Warning "Fonte nao encontrada, pulando: $($Source.Replace($RepoRoot, '.'))"
        return
    }
    $destDir = Split-Path -Parent $DestPath
    if ($destDir) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
    Copy-Item -LiteralPath $Source -Destination $DestPath -Force
    Write-Host "  copiado  $(Split-Path -Leaf $Source) -> $($DestPath.Replace($GamePath, '<jogo>'))"
}

function Get-PnpProfile {
    param([string]$Name, [string]$PNP)
    $name = "$Name"
    $pnp = "$PNP"
    $desc = "$name $pnp"

    if ($desc -match 'VEN_10DE' -or $name -match 'NVIDIA|GeForce') { return 3 }
    if ($desc -match 'VEN_8086' -or $name -match 'Intel.*(HD|UHD|Iris)|HD Graphics|Intel.*Graphics') { return 4 }
    if ($desc -match 'VEN_1002' -or $name -match 'Radeon|ATI|AMD' -or $name -match '^AMD ') {
        if ($name -match 'Radeon.{0,10}Graphics|Radeon Vega|Radeon.{0,4}Vega|Vega 3|Vega 8|Vega 11|Ryzen|Integrated|Radeon.{0,4} 8|Radeon.{0,4} 7') { return 1 }
        return 2
    }
    return 1
}

function Get-GpuProfile {
    <#
    Detecta o perfil de ajuste a partir da(s) GPU(s) instalada(s).
    Retorna:
      1 = AMD integrada/Radeon (performance)
      2 = AMD dedicada (qualidade)
      3 = NVIDIA (qualidade)
      4 = Intel (integrada, performance)
    Com multiplas GPUs, prefire a placa dedicada (NVIDIA/AMD), que e a usada p/ jogos.
    #>
    $controllers = $null
    if (Get-Command Get-CimInstance -ErrorAction SilentlyContinue) {
        $controllers = Get-CimInstance Win32_VideoController -ErrorAction SilentlyContinue
    }
    if (-not $controllers) {
        try { $controllers = Get-WmiObject Win32_VideoController -ErrorAction SilentlyContinue } catch { }
    }
    if (-not $controllers) { return 1 }

    $gpus = @($controllers | Where-Object { $_.Name -and $_.Name -notmatch 'Microsoft Basic|Basic Display|Virtual' })
    if ($gpus.Count -eq 0) { $gpus = @($controllers) }

    if ($gpus.Count -eq 1) {
        return Get-PnpProfile $gpus[0].Name $gpus[0].PNPDeviceID
    }

    $profiles = $gpus | ForEach-Object {
        [pscustomobject]@{ Name = "$($_.Name)"; Profile = (Get-PnpProfile "$($_.Name)" "$($_.PNPDeviceID)") }
    }
    Write-Host '  Multiplas GPUs detectadas:'
    $profiles | ForEach-Object { Write-Host "    - $($_.Name)  (perfil $($_.Profile))" }

    $discrete = $profiles | Where-Object { $_.Profile -eq 3 -or $_.Profile -eq 2 } | Select-Object -First 1
    if ($discrete) {
        Write-Host "  Preferindo a placa dedicada: $($discrete.Name)"
        return [int]$discrete.Profile
    }
    Write-Host '  Nenhuma placa dedicada; usando a primeira GPU.'
    return [int]($profiles | Select-Object -First 1).Profile
}

# ---------------------------------------------------------------------------
# 1) Pasta do jogo
# ---------------------------------------------------------------------------
if (-not $GamePath) {
    if (Test-Path -LiteralPath $DefaultGamePath) {
        $GamePath = $DefaultGamePath
        Write-Host "Usando pasta padrao do jogo: $GamePath"
    }
    else {
        $GamePath = Read-Host 'Digite o caminho da instalacao do jogo (onde fica o speed.exe)'
    }
}
if (-not (Test-Path -LiteralPath (Join-Path $GamePath 'speed.exe'))) {
    throw "Pasta do jogo invalida (speed.exe nao encontrado): $GamePath"
}
Write-Step "Pasta do jogo: $GamePath"

# ---------------------------------------------------------------------------
# 2) Copiar mods
# ---------------------------------------------------------------------------
Write-Step 'Copiando mods...'

Copy-IfExists (Join-Path $RepoRoot 'Mods\ASI-Loader\dinput8.dll') (Join-Path $GamePath 'dinput8.dll')

$scriptsDir = Join-Path $GamePath 'scripts'
New-Item -ItemType Directory -Path $scriptsDir -Force | Out-Null

foreach ($f in 'NFSMostWanted.WidescreenFix.asi', 'NFSMostWanted.WidescreenFix.tpk', 'NFSMostWanted.WidescreenFix.ini') {
    Copy-IfExists (Join-Path $RepoRoot "Mods\WidescreenFix\$f") (Join-Path $scriptsDir $f)
}
foreach ($f in 'NFSMWExtraOptions.asi', 'NFSMWExtraOptionsSettings.ini') {
    Copy-IfExists (Join-Path $RepoRoot "Mods\ExtraOptions\$f") (Join-Path $scriptsDir $f)
}

if ($InstallLan) {
    Copy-IfExists (Join-Path $RepoRoot 'Mods\Lan-Server\server.dll') (Join-Path $GamePath 'server.dll')
    Copy-IfExists (Join-Path $RepoRoot 'Mods\Lan-Server\server.cfg') (Join-Path $GamePath 'server.cfg')
}
elseif ($SkipPrompts) {
    Write-Host '  (SkipPrompts: servidor LAN nao instalado)'
}
else {
    $ans = Read-Host 'Instalar servidor LAN (server.dll/cfg)? (s/N)'
    if ($ans -match '^(s|sim|y|yes)$') {
        Copy-IfExists (Join-Path $RepoRoot 'Mods\Lan-Server\server.dll') (Join-Path $GamePath 'server.dll')
        Copy-IfExists (Join-Path $RepoRoot 'Mods\Lan-Server\server.cfg') (Join-Path $GamePath 'server.cfg')
    }
}

# ---------------------------------------------------------------------------
# 3) Perfil de GPU
# ---------------------------------------------------------------------------
Write-Step 'Perfil de GPU'
if ($GpuProfile -ge 1 -and $GpuProfile -le 4) {
    $gpu = $GpuProfile
    Write-Host "  Perfil forcado via -GpuProfile: $gpu"
}
else {
    $gpu = Get-GpuProfile
}
$perfilNome = @{ 1 = 'AMD integrada (performance)'; 2 = 'AMD dedicada (qualidade)'; 3 = 'NVIDIA (qualidade)'; 4 = 'Intel integrada (performance)' }[$gpu]
Write-Host "  GPU detectada: $gpu - $perfilNome"

$ini = Join-Path $scriptsDir 'NFSMostWanted.WidescreenFix.ini'
if (-not (Test-Path -LiteralPath $ini)) {
    throw "WidescreenFix.ini nao encontrado em: $ini"
}

switch ($gpu) {
    1 {
        Set-IniKey $ini 'GRAPHICS' 'ForcedGPUVendor' '0x1002'
        Set-IniKey $ini 'GRAPHICS' 'ShadowsRes' '1024'
        Set-IniKey $ini 'GRAPHICS' 'ImproveShadowLOD' '0'
        Set-IniKey $ini 'GRAPHICS' 'AutoScaleShadowsRes' '0'
        Set-IniKey $ini 'GRAPHICS' 'RainDropletsScale' '0.3'
        Set-IniKey $ini 'GRAPHICS' 'DisableMotionBlur' '1'
    }
    2 {
        Set-IniKey $ini 'GRAPHICS' 'ForcedGPUVendor' '0x1002'
        Set-IniKey $ini 'GRAPHICS' 'ShadowsRes' '2048'
        Set-IniKey $ini 'GRAPHICS' 'ImproveShadowLOD' '1'
        Set-IniKey $ini 'GRAPHICS' 'AutoScaleShadowsRes' '1'
        Set-IniKey $ini 'GRAPHICS' 'DisableMotionBlur' '0'
    }
    3 {
        Set-IniKey $ini 'GRAPHICS' 'ForcedGPUVendor' '0x10DE'
        Set-IniKey $ini 'GRAPHICS' 'ShadowsRes' '2048'
        Set-IniKey $ini 'GRAPHICS' 'ImproveShadowLOD' '1'
        Set-IniKey $ini 'GRAPHICS' 'AutoScaleShadowsRes' '1'
        Set-IniKey $ini 'GRAPHICS' 'DisableMotionBlur' '0'
    }
    4 {
        Set-IniKey $ini 'GRAPHICS' 'ForcedGPUVendor' '0x8086'
        Set-IniKey $ini 'GRAPHICS' 'ShadowsRes' '1024'
        Set-IniKey $ini 'GRAPHICS' 'ImproveShadowLOD' '0'
        Set-IniKey $ini 'GRAPHICS' 'AutoScaleShadowsRes' '0'
        Set-IniKey $ini 'GRAPHICS' 'DisableMotionBlur' '1'
    }
    default { throw 'Perfil de GPU invalido.' }
}

# ---------------------------------------------------------------------------
# 4) Camera (controle)
# ---------------------------------------------------------------------------
Write-Step 'Camera / controle'
$camera = 0
if ($EnableCamera) { $camera = 1 }
elseif (-not $SkipPrompts) {
    $ans = Read-Host '  Habilitar camera com stick/mouse? (s/N)'
    if (-not $ans) { $ans = 'n' }
    if ($ans -match '^(s|sim|y|yes)$') { $camera = 1 }
}
Set-IniKey $ini 'CAMERA' 'Enable' "$camera"

# ---------------------------------------------------------------------------
# 5) Resumo
# ---------------------------------------------------------------------------
Write-Step 'Pronto!'
Write-Host "  - Mods copiados para: $GamePath"
Write-Host "  - Configuracao aplicada em: $ini"
Write-Host ''
Write-Host '  Para jogar, execute speed.exe. Os mods carregam via dinput8.dll.'
Write-Host '  No jogo, selecione o idioma "Spanish" para usar a traducao PT-BR (GameVicio).'