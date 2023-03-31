# TextTextureNative

![Unity](https://img.shields.io/badge/unity-2022-green.svg)
![Xode](https://img.shields.io/badge/xcode-xcode14-green.svg)

This Unity plugin renders text into Texture2D using UIKit.  
It is possible to display special characters and emoji.

<img src="docs/example.gif">

# Usage

```c#
var uuid = "hoge"

var texture = TextTextureNativeManager.MakeTexture(uuid, 512, 512, 2);

TextTextureNativeManager.Render(uuid, "𝕳𝖊𝖑𝖑𝖔𝖂𝖔𝖗𝖑𝖉\n𝓗𝓮𝓵𝓵𝓸𝓦𝓸𝓻𝓵𝓭\n🐙🪼🫚", 24, Color.white);
```