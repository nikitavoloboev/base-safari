# Base Safari Extension

> Block distracting websites during focus times

It will block a list of websites that you specify during a period of time. In my case, it will open [Things](https://culturedcode.com/things/) app instead and black the page out when accessing a website during `focus times`. You can program it to do something else and/or change the schedule/websites.

Shown in action [here](https://x.com/nikitavoloboev/status/1780226797575065665).

## Run

Open project in Xcode.

Edit [content.js](base-safari%20Extension/Resources/content.js) file. The `urls` variable holds the websites to block. There is also schedule defined inside. Edit it for your own use.

Edit [manifest.json](base-safari%20Extension/Resources/manifest.json), `content_scripts`/`matches` to include the websites too.

Build extension in Xcode and activate it in Safari settings (give permissions to websites there too).

[![Discord](https://go.nikiv.dev/badge-discord)](https://go.nikiv.dev/discord) [![X](https://go.nikiv.dev/badge-x)](https://x.com/nikitavoloboev) [![nikiv.dev](https://go.nikiv.dev/badge-nikiv)](https://nikiv.dev)
