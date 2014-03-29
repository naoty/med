# med

Med is a hackable markdown editor for OSX. You can use any scripts for the markdown parser.

## Usage

You can set configurations such as markdown parsers and the appearance of editor at `~/.med.json` like following.

```json
{
    "path": "/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin",
    "parsers": [
        "markdown",
        "emoji"
    ],
    "publishers": {
        "markdown": [
            "hatenablog"
        ],
        "html": [
            "tumblr"
        ]
    },
    "editor": {
        "fontName": "Ricty",
        "fontSize": 14,
        "padding": 10,
        "tabWidth": 2
    }
}
```

### Parsers

You can set any scripts as the markdown parsers at `parsers`. Med processes texts by using these parsers in order. The scripts are required to receive user's input texts as standard input and to return the parsed result as standard output.

### Publishers

You can set any scripts to publish texts on somewhere such as your blog at `publishers`. These can be selected and run from menu. Publishers have two types:

- `markdown`: scripts to publish unprocessed markdown texts.
- `html`: scripts to publish parsed HTML.

These scripts receive texts as standard input and the the absolute path of an opend file as the first argument.

### Preview stylesheets

You can add custom styelsheets for preview. Stylesheets at `~/.med/stylesheets/*.css` are loaded and can be selected from menu `View > Preview stylesheets`.

## Quick start

I provide [med-scripts](https://github.com/naoty/med-scripts) for quick start. This repository includes scripts such as markdown parser and emoji parser written by node.js. For setup these scripts, clone this repository and run `npm install`.

```sh
$ git clone https://github.com/naoty/med-scripts.git && cd med-scripts
$ npm install
```

Then, edit your `~/.med.json` like below.

```json
{
    "path": "/path/to/node:/path/to/med-scripts/bin",
    "parsers": [
        "markdown"
    ]
}
```