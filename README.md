# PowerShell-FFMPEG

This PowerShell module requires [FFMPEG](https://ffmpeg.org/) to be installed.

[FFMPEG](https://ffmpeg.org/)
is a cross-platform solution to record, convert and stream audio and video.
This tool is an open-source project [licensed under the GNU GPL and LGPL licenses](https://ffmpeg.org/legal.html) and is available for free on
[FFMPEG](https://ffmpeg.org/)

On MacOS, the FFMPEG binary can be installed using Homebrew with the
following command: 
    ```
    $ brew install ffmpeg
    ```

On Windows, the FFMPEG binary can be installed using Chocolatey with the
following command: 
    ```
    $ choco install ffmpeg
    ```

Users of all operating systems can [download](https://ffmpeg.org/download.html) the latest binary and source versions from the [FFMPEG project site](https://ffmpeg.org/).

When installing FFMPEG using Homebrew or Chocolatey the FFMPEG binary paths
will automatically be added to the operating system PATH environment variable.
If FFMPEG was installed manually you must add the path to the system
PATH environment variable for the module to work.

Please note that this module is only tested against FFMPEG release version 8.0.

For additional information see https://github.com/seabopo/PowerShell-FFMPEG

## Usage

See the files in the [sample-code](https://github.com/seabopo/PowerShell-FFMPEG/tree/main/sample-code) project directory for usage examples.
