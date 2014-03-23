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
    "editor": {
        "fontName": "Ricty",
        "fontSize": 14,
        "padding": 10
    }
}
```

### Parsers

You can set scripts as the markdown parsers at `"parsers"`. Med processes texts by using these parsers in order. The scripts are required to receive user's input texts as standard input and to return the parsed result as standard output.