# history-window

Show command history "picture-in-picture" when teaching command line.
**Requires Bash.**

Motivation for this:
- This is nice for people using a tiling window manager
- Only two commands to run, I guess could be collapsed to one
- Only one terminal to deal with
- Less for me to do and prepare before the lesson starts


## Demo

![demo](demo.gif)


## Installation

```bash
wget https://raw.githubusercontent.com/bast/history-window/main/history-window.sh
source history-window.sh
```


## Status and roadmap

- There are rough edges. Improvements are welcome.
- Resizing kind of works, but requires a `clear` to redraw the window.
- Currently only Bash. Let's add support for [fish](https://fishshell.com/)?


## Similar projects

- https://github.com/rkdarst/prompt-log
