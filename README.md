# med

markdown stream editor for OSX.

This editor applies any defined filters to input texts. So, you can use favorite markdown parsers for this editor.

## Usage

This editor applies defined filters to input texts with UNIX pipes. You can define filter scripts at `~/.med.json` like below.

```json
{
    "path": "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin",
    "scripts": [
        "hoedown"
    ],
    "editor": {
        "fontName": "Monaco",
        "fontSize": 12.0
    }
}
```

Your config overrides a default config `med.app/Contents/Resources/med.json`.

