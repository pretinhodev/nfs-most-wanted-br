# NFS Most Wanted — Edição Brasileira (Repack + Tradução + Mods)

Repositório de apoio para montar sua instalação do **Need for Speed: Most Wanted Black Edition**
com a **tradução brasileira (GameVicio)** e os **mods de correção** mais usados.

> ⚠️ **Aviso legal**
> Este repositório **NÃO** contém os arquivos do jogo (executável, dados de mídia etc.),
> que são de propriedade da **EA Games / Criterion Games**.
> Ele contém apenas **tradução de fã**, **configurações de mods** e **links**.
> Use apenas com uma cópia do jogo que você possui legalmente.

---

> ⚙️ **IMPORTANTE — ajuste para o seu PC**
> As configurações deste repositório (`.ini` em `Mods/`) são um ponto de partida (feitas para
> GPU integrada AMD em 1080p).
> **Depois de instalar o jogo, rode o `setup-config.ps1`** (veja abaixo) — ele detecta a sua GPU,
> copia os mods e ajusta o gráfico **para o seu computador**. Não use os `.ini` direto como estão
> sem rodar o script.

---

## 📦 O que tem neste repositório

| Pasta | Conteúdo |
|-------|----------|
| `Traducao-GameVicio/` | Arquivos de língua da tradução brasileira (para aplicar sobre o jogo) |
| `Mods/ASI-Loader/` | `dinput8.dll` — Ultimate ASI Loader (ThirteenAG), carregador dos `.asi` |
| `Mods/ExtraOptions/` | `NFSMWExtraOptions.asi` + `NFSMWExtraOptionsSettings.ini` (NFSMW ExOpts) |
| `Mods/WidescreenFix/` | `NFSMostWanted.WidescreenFix.asi` + `.tpk` + `.ini` (Widescreen Fix) |
| `Mods/XtendedInput/` | `NFS_XtendedInput.asi` + `.ini` + `.default.ini` + `XtendedInputButtons.tpk` + `nfs_cursor.cur` (XtendedInput) |
| `Mods/Lan-Server/` | `server.dll` + `server.cfg` — emulador de servidor LAN |
| `Mods/HDReflections/` | `NFSMWHDReflections.asi` + `.ini` — reflexos HD (Aero) |
| `Mods/RainDroplets/` | `NFSMostWanted.XboxRainDroplets.asi` + `.ini` — gotas de chuva no "vidro" (Xbox) |
| `Mods/FEShadows/` | `NFSMWFEShadows.asi` + `.ini` — sombras no menu inicial (Front-End Shadows) |

---

## 🔗 Links úteis

### Repack / jogo
- **DODI Repacks** (distribuidor de repack): https://dodi-repacks.site
  - Busque por "Need For Speed Most Wanted Black Edition" no site / mirror.

### Tradução
- **GameVicio** (tradução brasileira PT-BR): https://www.gamevicio.com
  - Direto da página de downloads da GameVicio para NFS Most Wanted.

### Mods
- **NFSMW Extra Options** (ExOpts Team):
  - Repositório: https://github.com/ExOptsTeam/NFSMWExOpts
  - Issues / suporte: https://github.com/ExOptsTeam/NFSMWExOpts/issues
- **NFSMW Widescreen Fix** (ThirteenAG):
  - Repositório: https://github.com/ThirteenAG/WidescreenFixesPack
  - (O `NFSMostWanted.WidescreenFix.asi` é o arquivo do pack que instala no diretório `scripts/`.)
- **Ultimate ASI Loader** (ThirteenAG) — usado pelo `dinput8.dll`:
  - Repositório: https://github.com/ThirteenAG/Ultimate-ASI-Loader
- **NFS XtendedInput** (xan1242) — suporte a controle/gamepad moderno:
  - Repositório: https://github.com/xan1242/NFS-XtendedInput
  - Releases (baixe o `Release-MW-Pack.zip`, versão MW 32 bits): https://github.com/xan1242/NFS-XtendedInput/releases
- **NFS HD Reflections** (Aero_) — reflexos em alta resolução (UG2/MW/Carbon):
  - nfsmods: https://nfsmods.xyz/mod/3363 (sem release no GitHub — só o código)
- **Xbox Rain Droplets** (ThirteenAG):
  - Repositório: https://github.com/ThirteenAG/XboxRainDroplets
- **Front-End Shadows** (Aero_) — sombras no menu inicial do MW:
  - nfsmods: https://nfsmods.xyz/mod/3005 (sem release no GitHub)

---

## 🛠️ Como instalar

> ⚡ **Recomendado:** rode o `setup-config.ps1` (seção **Configurador automático** abaixo).
> Ele copia os mods **e** ajusta o gráfico para a **sua** GPU. Os passos manuais abaixo
> são só para referência.

### 1. Instale o jogo
1. Baixe o repack DODI do "Need for Speed Most Wanted Black Edition".
2. Instale normalmente (o repack já vem com o jogo funcional e o crack).

### 2. Aplique a tradução (GameVicio) — ANTES dos mods
> ⚠️ **Ordem importa:** a tradução deve ser instalada **antes** dos mods, pois ambos mexem
> nos arquivos de idioma/`scripts` e a instalação da tradução pode sobrescrever os do jogo.

A tradução brasileira da GameVicio (**v2.03**) tem um **instalador próprio**:

```
Tradução PT-BR Need for Speed Most Wanted.exe   (NSIS ~347 KB, © GameVicio)
```

1. Baixe o instalador na página da GameVicio (link acima) e **execute** o `.exe`.
2. Escolha a pasta de instalação do jogo e confirme. Ele aplica os arquivos na pasta `LANGUAGES\`
   da raiz do jogo.
3. No jogo, selecione o idioma **Spanish** (Espanhol) — a tradução brasileira usa esse slot.

> Alternativa manual: os arquivos de tradução também estão disponíveis neste repo
> em `Traducao-GameVicio/` — copie-os para a pasta `LANGUAGES\`, sobrescrevendo quando pedir.

### 3. Instale o ASI Loader + mods
O `dinput8.dll` (ASI Loader) é o que carrega os `.asi`. Coloque na pasta raiz da instalação:
   - Copie `Mods/ASI-Loader/dinput8.dll` → pasta raiz da instalação.
   - Copie `Mods/WidescreenFix/NFSMostWanted.WidescreenFix.asi` e `.tpk` → pasta `scripts/`.
   - Copie `Mods/ExtraOptions/NFSMWExtraOptions.asi` → pasta `scripts/`.
   - (Opcional) Ajuste os `.ini` (configs) na pasta `scripts/`.

> ⚙️ Rodando o `setup-config.ps1` o gráfico é ajustado para a GPU da **sua máquina** (AMD integrada,
> AMD dedicada, NVIDIA ou Intel).

### 4. Emulador de servidor LAN (opcional)
Para jogar online/LAN:
   - Copie `Mods/Lan-Server/server.dll` e `server.cfg` → pasta raiz da instalação.

### 5. Mod do controle (gamepad) — NFS XtendedInput

O NFSMW 2005 só entende controles **DirectInput** e não enxerga controles
Xbox/XInput (nem a maioria dos controles modernos). O **NFS XtendedInput**
adiciona suporte **XInput nativo** + ícones de botão + tudo rebindável.
Ele usa o mesmo **Ultimate ASI Loader** já instalado (`dinput8.dll`), então a
instalação é só copiar os arquivos de `Mods/XtendedInput/`:
   - Copie `NFS_XtendedInput.asi`, `NFS_XtendedInput.ini`, `NFS_XtendedInput.default.ini`
     e `nfs_cursor.cur` → pasta `scripts/`.
   - Copie `XtendedInputButtons.tpk` → pasta `GLOBAL/`.
   - Copie `EventReference.txt` → pasta raiz da instalação.

> ⚠️ No menu `Controls` do jogo o mod **desabilita a tela (crasha)** — **NÃO entre nele**.
> A configuração é feita pelos `.ini`:
> - Opções gerais: `scripts\NFS_XtendedInput.ini` (deadzone, ícones, etc.)
> - Mapeamento de botões (por save): `scripts\XtendedInputMaps\<nome do save>\NFS_XtendedInput.usermap.ini`
> - Referência de eventos: `EventReference.txt`
>
> 🔧 O mapeamento de botões é **por save (perfil)**, então cada jogador rebinda o seu.
> O `setup-config.ps1` instala o mod mas **não** copia o mapeamento de ninguém.

Se os botões não responderem, rode o jogo **como Administrador** ou mova a pasta
do jogo para fora de `Program Files` (virtualização UAC). Alternativas: **x360ce**
ou **reWASD** (mapeador pago).

### 6. Rode o jogo
   Rode `speed.exe` (v1.3).

> ⚠️ O Extra Options exige o **speed.exe v1.3**. Se o seu repack vier com outra versão,
> use o "NFS Most Wanted No-DVD Crack" correspondente.

---

## 🤖 Configurador automático (setup-config.ps1)

O **`setup-config.ps1`** copia os mods para a pasta do jogo e ajusta as configurações
conforme a sua GPU — sem precisar copiar arquivos na mão.

### Como usar

1. Baixe/clone este repositório.
2. Abra o **PowerShell** na pasta do repositório.
3. Execute:

   ```powershell
   powershell -ExecutionPolicy Bypass -File setup-config.ps1
   ```

O script vai:
- Detectar a pasta do jogo (usa o caminho padrão do repack DODI se existir, senão pergunta)
- Copiar `dinput8.dll` (ASI Loader) e os mods (`WidescreenFix`, `ExtraOptions`, `HDReflections`, `RainDroplets`, `FEShadows`, `XtendedInput`) para `scripts/`
- **Detectar a GPU automaticamente** (AMD integrada / AMD dedicada / NVIDIA / Intel) e ajustar o `NFSMostWanted.WidescreenFix.ini`
- Perguntar se quer o **servidor LAN** e a **câmera com stick/mouse**

> 💡 **Múltiplas GPUs** (ex.: notebook com Intel/AMD integrada + NVIDIA dedicada):
> o script lista todas as GPUs encontradas e **prefere a placa dedicada** (a usada em jogos).
> Se precisar forçar outra, use `-GpuProfile 1-4`.

### Opções avançadas

| Opção | Efeito |
|-------|--------|
| `-GamePath "C:\...\Need For Speed Most Wanted Black Edition"` | Define a pasta do jogo direto |
| `-GpuProfile 1-4` | Força o perfil (1 = AMD integrada, 2 = AMD dedicada, 3 = NVIDIA, 4 = Intel) |
| `-EnableCamera` | Liga a câmera com stick/mouse (`[CAMERA] Enable = 1`) |
| `-InstallLan` | Instala o servidor LAN sem perguntar |
| `-SkipPrompts` | Execução silenciosa (câmera off, sem LAN) |

Exemplo:

```powershell
powershell -ExecutionPolicy Bypass -File setup-config.ps1 -GamePath "C:\Jogos\NFSMW" -InstallLan
```

---

## 🎮 Requisitos dos mods

- **Extra Options v10.0.1.1337** — exige `speed.exe` v1.3 (5,75 MB / 6.029.312 bytes).
- **Widescreen Fix** — recomendado para monitores 16:9 / 21:9 / ultrawide.

---

## ⚙️ Configurações atuais do WidescreenFix

Configurações otimizadas para **GPU integrada AMD** em 1080p:

- **`ForcedGPUVendor = 0x1002`** — força o vendor **ATI/AMD** (corrige opções de vídeo/renderer para a GPU certa)
- **`Enable = 0`** (seção `[CAMERA]`) — **câmera com stick/mouse desativada** (o controle usa os binds padrão sem conflito no analógico direito)
- **`ShadowsRes = 1024`** — sombras otimizadas para GPU integrada
- **`DisableMotionBlur = 1`** — desativado para performance
- **`SimRate = -1`** — FPS destravado (match da taxa de atualização do monitor)

Para habilitar a câmera de novo, mude `Enable = 1` na seção `[CAMERA]` do
`Mods/WidescreenFix/NFSMostWanted.WidescreenFix.ini`.

---

## 📄 Licenças

- **Extra Options**: GNU GPLv3 (© ExOpts Team).
- **Widescreen Fix**: repositório de ThirteenAG (consulte a licença do pack).
- **NFS XtendedInput**: MIT (© xan1242).
- **Tradução GameVicio**: uso autorizado para fins de jogo; créditos à GameVicio.
- **NFS Most Wanted**: © EA Games / Criterion Games. Distribuído aqui apenas como *link*.

---

Feito para facilitar a instalação da versão brasileira do NFS Most Wanted.
Divirta-se em Rockport! 🏎️💨