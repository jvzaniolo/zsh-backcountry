# zsh-backcountry

A zsh plugin to manage Backcountry's projects.

- [What it does](#what-it-does)
- [Usage](#usage)
  - [Commands](#commands)
  - [Documentation](#documentation)
- [Installing](#installing)
  - [zinit](#zinit-recommended)
  - [Manual](#manual)
- [Updating](#updating)
  - [zinit](#zinit)
  - [Manual](#manual-1)

## What it does

- Adds all the [environment variables](https://github.com/Backcountry/atg-atg-backcountry-ca#environment-variables) for you (you can override `$JAVA_HOME` if you like)
- Offers several commands to help you be more productive
  - Checks to see if your GlobalProtect VPN is connected
  - Runs `nvm use` when necessary

## Usage

Define `$BCS_DIR` variable to the path where you cloned the Backcountry repositories.
For example, if you cloned them inside the `~/Documents` folder:

```bash
echo "export BCS_DIR=$HOME/Documents" >> ~/.zshrc
```

### Commands

```bash
bcs start all # start Apache, ATG, and Kraken respectively

bcs stop all # stop Apache and ATG (gracefully)

bcs update all # update all the repositories
```

For Kraken css:

```bash
bcs start kraken-css cc # run 'npm run watch:cc' in the '$BCS_DIR/bc-frontend/public' folder
```

### Documentation

```bash
bcs {start|stop|update} {apache|apache-logs|atg|kraken|all|help}
```

To start the `kraken-css` and `next` commands you need to pass a third parameter for `<site>`:

```bash
bcs start {kraken-css|next} {bcs|cc|moto|sac}
```

## Installing

### [zinit](https://github.com/zdharma-continuum/zinit) (Recommended)

```bash
zinit ice wait lucid
zinit light jvzaniolo/zsh-backcountry
```

### Manual

If you don't use a `zsh` plugin manager, follow these instructions.

- Clone this repo

```bash
git clone https://github.com/jvzaniolo/zsh-backcountry.git ~
```

- Source it in your `.zshrc` file

```bash
source ~/zsh-backcountry/backcountry.plugin.zsh
```

## Updating

### zinit

```bash
zinit update jvzaniolo/zsh-backcountry
```

### Manual

```
cd ~/zsh-backcountry
git pull
source ~/.zshrc
```
