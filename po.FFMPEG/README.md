# PowerShell-FFMPEG

This PowerShell module requires [FFmpeg](https://ffmpeg.org/) to be installed.

[FFmpeg](https://ffmpeg.org/) is a cross-platform solution to record, convert and stream audio and video.

## Licensing

This module's own code is licensed under the [MIT License](LICENSE).

FFmpeg is open-source software licensed under the
[GNU LGPL v2.1 or later, or the GNU GPL for builds that enable its GPL components](https://ffmpeg.org/legal.html),
and is available for free from [ffmpeg.org](https://ffmpeg.org/download.html). This module does
**not** bundle, redistribute, or link to FFmpeg. You install it separately, and the module runs the
`ffmpeg` and `ffprobe` executables on your PATH. For attribution, the following files are included with
this module:

- [FFMPEG_LICENSE.md](FFMPEG_LICENSE.md): FFmpeg's license summary, copied from the FFmpeg source tree.
- [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md): how FFmpeg's license relates to this module, and what applies if you redistribute FFmpeg yourself.

FFmpeg is a trademark of Fabrice Bellard, originator of the FFmpeg project. This module is not
affiliated with the FFmpeg project.

## Installing the PowerShell Module
The po.FFMPEG PowerShell Module has only been tested with PowerShell 7.4 and above.

Install the po.FFMPEG PowerShell Module with PSResourceGet, which comes with PowerShell 7.4 and later:
```
Install-PSResource -Name po.FFMPEG -Repository PSGallery -Scope CurrentUser
```

Install the [PowerShell-Toolkit](https://github.com/seabopo/PowerShell-Toolkit) PowerShell Module, a dependency for po.FFMPEG.
```
Install-PSResource -Name po.Toolkit -Repository PSGallery -Scope CurrentUser
```

"Untrusted repository" prompt: PSGallery is untrusted by default. Add -TrustRepository to Install-PSResource to skip it.

Updating later: use Update-PSResource -Name po.FFMPEG.

## Installing FFmpeg

On MacOS, the FFmpeg binaries can be installed using Homebrew with the
following command:  
```
    $ brew install ffmpeg
```

On Windows, the FFmpeg binaries can be installed using Chocolatey with the
following command:  
```
    $ choco install ffmpeg
```

Users of all operating systems can [download](https://ffmpeg.org/download.html) the latest binary and source versions from the [FFmpeg project site](https://ffmpeg.org/).

When installing FFmpeg using Homebrew or Chocolatey the FFmpeg binary paths
will automatically be added to the operating system PATH environment variable.
If FFmpeg was installed manually you must add the path to the system
PATH environment variable for the module to work.

Please note that this module is only tested against FFmpeg version 8.0.

For additional information see https://github.com/seabopo/PowerShell-FFMPEG

## Usage

See the files in the [sample-code](https://github.com/seabopo/PowerShell-FFMPEG/tree/main/sample-code) project directory for usage examples.
