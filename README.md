# NFS Most Wanted — Edição Brasileira (Repack DODI + Tradução + Mods)

Repositório de apoio para montar sua instalação do **Need for Speed: Most Wanted Black Edition**
com a **tradução brasileira (GameVicio)** e os **mods de correção** mais usados.

> ⚠️ **Aviso legal**
> Este repositório **NÃO** contém os arquivos do jogo (executável, dados de mídia etc.),
> que são de propriedade da **EA Games / Criterion Games**.
> Ele contém apenas **tradução de fã**, **configurações de mods** e **links**.
> Use apenas com uma cópia do jogo que você possui legalmente.

---

## 📦 O que tem neste repositório

| Pasta | Conteúdo |
|-------|----------|
| `Traducao-GameVicio/` | Arquivos de língua da tradução brasileira (para aplicar sobre o jogo) |
| `Mods/ASI-Loader/` | `dinput8.dll` — Ultimate ASI Loader (ThirteenAG), carregador dos `.asi` |
| `Mods/ExtraOptions/` | `NFSMWExtraOptions.asi` + `NFSMWExtraOptionsSettings.ini` (NFSMW ExOpts) |
| `Mods/WidescreenFix/` | `NFSMostWanted.WidescreenFix.asi` + `.tpk` + `.ini` (Widescreen Fix) |
| `Mods/Lan-Server/` | `server.dll` + `server.cfg` — emulador de servidor LAN |

---

## 🔗 Links úteis

### Repack / jogo
- **DODI Repacks** (distribuidor do repack): https://dodi-repacks.site
  - Busque por "Need For Speed Most Wanted Black Edition" no site / rarbg mirror.

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

---

## 🛠️ Como instalar

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
2. Escolha a pasta de instalação do jogo e confirme. Ele aplica os arquivos na pasta `LANGUAGES\`.
   ```
   C:\Program Files (x86)\DODI-Repacks\Need For Speed Most Wanted Black Edition\LANGUAGES\
   ```
3. No jogo, selecione o idioma **Spanish** (Espanhol) — a tradução brasileira usa esse slot.

> Alternativa manual: os arquivos de tradução também estão disponíveis neste repo
> em `Traducao-GameVicio/` — copie-os para a pasta `LANGUAGES\`, sobrescrevendo quando pedir.

### 3. Instale o ASI Loader + mods
O `dinput8.dll` (ASI Loader) é o que carrega os `.asi`. Coloque na pasta da instalação:
   ```
   C:\Program Files (x86)\DODI-Repacks\Need For Speed Most Wanted Black Edition\
   ```
   - Copie `Mods/ASI-Loader/dinput8.dll` → pasta raiz da instalação.
   - Copie `Mods/WidescreenFix/NFSMostWanted.WidescreenFix.asi` e `.tpk` → pasta `scripts/`.
   - Copie `Mods/ExtraOptions/NFSMWExtraOptions.asi` → pasta `scripts/`.
   - (Opcional) Ajuste os `.ini` (configs) na pasta `scripts/`.

### 4. Emulador de servidor LAN (opcional)
Para jogar online/LAN:
   ```
   C:\Program Files (x86)\DODI-Repacks\Need For Speed Most Wanted Black Edition\
   ```
   - Copie `Mods/Lan-Server/server.dll` e `server.cfg` → pasta raiz da instalação.

### 5. Rode o jogo
   Rode `speed.exe` (v1.3).

> ⚠️ O Extra Options exige o **speed.exe v1.3**. Se o seu repack vier com outra versão,
> use o "NFS Most Wanted NO DVD Crack RELOADED".

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
- Detectar a pasta do jogo (usa o caminho do DODI Repacks se existir, senão pergunta)
- Copiar `dinput8.dll` (ASI Loader) e os mods (`WidescreenFix`, `ExtraOptions`) para `scripts/`
- Perguntar o **perfil de GPU** (AMD integrada / AMD dedicada / NVIDIA)
- Perguntar se quer o **servidor LAN** e a **câmera com stick/mouse**
- Aplicar os ajustes no `NFSMostWanted.WidescreenFix.ini`

### Opções avançadas

| Opção | Efeito |
|-------|--------|
| `-GamePath "C:\...\Need For Speed Most Wanted Black Edition"` | Define a pasta do jogo direto |
| `-EnableCamera` | Liga a câmera com stick/mouse (`[CAMERA] Enable = 1`) |
| `-InstallLan` | Instala o servidor LAN sem perguntar |
| `-SkipPrompts` | Execução silenciosa (perfil AMD integrada, câmera off, sem LAN) |

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

Configurações otimizadas para **GPU integrada AMD (Radeon, Ryzen 5 4600G)** em 1080p:

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
- **Tradução GameVicio**: uso autorizado para fins de jogo; créditos à GameVicio.
- **NFS Most Wanted**: © EA Games / Criterion Games. Distribuído aqui apenas como *link*.

---

Feito para facilitar a instalação da versão brasileira do NFS Most Wanted.
Divirta-se em Rockport! 🏎️💨
