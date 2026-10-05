## 📖 Скрипт устанавливает и настраивает мой пресет терминала для удобной базовой работы.
```
❗ Скрипт изначально написан для OS Ubuntu 24.04+
```
### ✏️ Команда для установки:
```
curl -sS https://raw.githubusercontent.com/Paladin4ick/setup-terminal-preset/refs/heads/main/install.sh | sh
```
### 📥 Устанавливает:
- zsh
- git
- curl
- lsd
- neovim
- starship
- fastfetch
- fast syntax highlighting
- zsh completions
- zsh-autosuggestions
### ⚙️ Настраивает:
- Стандартный конфиг `ZSH`
- Добавляет алиас для замены команды `ls` на `lsd -a`
- Ставит пресет `bracketed-segments` для `starship`
- Создает файл `.hushlogin` для отключения `login MOTD` от `ubuntu`
- Ставит `ZSH` как `Shell` по умолчанию
