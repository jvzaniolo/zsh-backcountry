# zsh-backcountry

A zsh plugin to manage Backcountry's projects.

## What it does

- Checks to see if your GlobalProtect VPN is connected
- Runs `nvm use` inside projects that need it
- Offers several commands to help you be more productive

## Usage

Define `$BCS_DIR` variable to the path where you cloned the Backcountry repositories.
For example, if you cloned them inside the `~/Documents` folder:

```bash
echo "export BCS_DIR=$HOME/Documents" >> ~/.zshrc
```

### Commands

```bash
bcs start all # will start Apache, ATG, and Kraken respectively
```

For Kraken css:

```bash
bcs start kraken-css cc # will run 'npm run watch:cc' in the '$BCS_DIR/bc-frontend/public' folder
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
