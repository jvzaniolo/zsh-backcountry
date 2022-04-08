# zsh-backcountry

A zsh plugin to manage Backcountry's projects

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

For Kraken css

```bash
bcs start kraken-css cc # will run npm run watch:cc inside bc-frontend/public folder
```

### Documentation

```bash
bcs {start|stop|update} {apache|apache-logs|atg|kraken|all|help}
```

To start the `kraken-css` and `next` commands you need to pass a third parameter for `<site>`

```bash
bcs start {kraken-css|next} {bcs|cc|moto|sac}
```

## Installing

### [zinit](https://github.com/zdharma-continuum/zinit) (Recommended)

```bash
zinit snippet https://gist.github.com/jvzaniolo/6036a235ea22995765091b04cf33ad25/raw/
```

### Manual

If you don't use a `zsh` plugin manager, follow these instructions.

- Download this file and rename it to `backcountry.plugin.zsh`
- Source it in your `.zshrc` file

```bash
source ~/backcountry.plugin.zsh
```