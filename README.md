# med

Med is a markdown stream editor for OSX. This editor applies any defined filters to input texts. So, you can use favorite markdown parsers for this editor.

## Usage

Med applies filters to texts through UNIX pipes. The filters are required that they can input texts from standard-input and output the result to standard-output. You can define filters at `~/.med.json` like below.

```json
{
    "path": "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin",
    "scripts": [
        "marked"
    ],
    "editor": {
        "fontName": "Monaco",
        "fontSize": 12
    }
}
```

Your config overrides a default config `med.app/Contents/Resources/med.json`.

### med-scripts

I provide [med-scripts](https://github.com/naoty/med-scripts) for easy start. This repository includes markdown parser, emoji parser and so on.

### Stylesheet for preview

You can change a stylesheet for preview from menu. Stylesheets at `~/.med/stylesheets/` can be selected from `View > Preview Stylesheets` menu. Also, a default stylesheet, `github.css`, can be selected from the menu.
