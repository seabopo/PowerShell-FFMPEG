# Third-Party Notices

The po.FFMPEG PowerShell module (Copyright (c) 2025 seabopo, MIT License, see `LICENSE`) is a
wrapper around the FFmpeg command-line tools.

**This module does not include, bundle, or redistribute FFmpeg, its libraries, or any FFmpeg
source code.** You install FFmpeg separately (Homebrew, Chocolatey, a Linux package manager, or a
download linked from ffmpeg.org). The module runs the `ffmpeg` and `ffprobe` executables found on
your system PATH as separate processes. It does not link against any FFmpeg library.

The notices below give attribution and tell you which licenses apply to the software this module
depends on at runtime.

## FFmpeg

| | |
|-|-|
| Project | [FFmpeg](https://ffmpeg.org/) |
| Tools used by this module | `ffmpeg`, `ffprobe` |
| License | LGPL-2.1-or-later. Builds that enable optional GPL components are GPL-2.0-or-later, and builds that enable version 3 use LGPL-3.0-or-later or GPL-3.0-or-later. |
| License details | [`FFMPEG_LICENSE.md`](FFMPEG_LICENSE.md) (copied from the FFmpeg source tree) and https://ffmpeg.org/legal.html |
| Source code | https://ffmpeg.org/download.html#get-sources |

FFmpeg is a trademark of Fabrice Bellard, originator of the FFmpeg project.

This module and its author are not affiliated with the FFmpeg project and do not own FFmpeg.

### Which license applies to your FFmpeg

The license that applies to your copy of FFmpeg depends on how it was built. Most prebuilt
packages (Homebrew, Chocolatey, and Linux distributions) enable GPL components and are licensed
under the GPL. To see the license of the FFmpeg you have installed, run:

```
ffmpeg -hide_banner -L
```

Those license terms are between you and the FFmpeg project (or the provider of your FFmpeg build).
Because this module neither distributes nor links to FFmpeg, it does not change or add to them.

### If you redistribute FFmpeg with this module

If you package this module together with FFmpeg binaries (for example, in a container image or
installer), you are distributing FFmpeg and must comply with its license yourself. That includes
providing the license text and the corresponding source code. See FFmpeg's
[License Compliance Checklist](https://ffmpeg.org/legal.html).
