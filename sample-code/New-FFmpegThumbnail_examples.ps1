#==================================================================================================================
#==================================================================================================================
# Sample Code :: Create Thumbnail Image Using FFMPEG
#==================================================================================================================
#==================================================================================================================

#==================================================================================================================
# Initialize Test Environment
#==================================================================================================================

# Load the standard test initialization file.
. $(Join-Path -Path $PSScriptRoot -ChildPath '_init-test-environment.ps1')

# Override the Default Debug Logging Setting
#   $env:PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES = $true

#==================================================================================================================
# Run Tests
#==================================================================================================================

# ffmpeg -loglevel error -y -i "/sample-media/Art/Poster/Furiosa - A Mad Max Saga (2024).jpg" -vf "scale='min(1000,iw)':'min(1000,ih)':force_original_aspect_ratio=decrease" -update 1 "/sample-media/Art/Thumbnail/Furiosa - A Mad Max Saga (2024).jpg"

#---------------------------------------
# Common
#---------------------------------------

    $maxRes           = 300
    $quality          = 10
    $inputFolderPath  = Join-Path -Path $mediaPath        -ChildPath '/Art/Poster/'
    $outputFolderPath = Join-Path -Path $mediaPath        -ChildPath '/Art/Thumbnail/'

#---------------------------------------
# JPEG Image
#---------------------------------------

    $fileName         = 'Furiosa - A Mad Max Saga (2024).jpg'
    $inputFilePath    = Join-Path -Path $inputFolderPath  -ChildPath $fileName
    $outputFilePath   = Join-Path -Path $outputFolderPath -ChildPath $fileName
    
    $r = New-FFmpegThumbnail -i $inputFilePath -o $outputFilePath -d $maxRes -q $quality
    if ( $r.success ) {
        Write-Msg -s -ps -m 'Thumbnail generated.'
    }
    else {
        Write-Msg -e -ps -m $r.message
    }

#---------------------------------------
# PNG Image
#---------------------------------------

    $fileName         = '10 Cloverfield Lane (2016).png'
    $inputFilePath    = Join-Path -Path $inputFolderPath  -ChildPath $fileName
    $outputFilePath   = Join-Path -Path $outputFolderPath -ChildPath '10 Cloverfield Lane (2016).jpg'
    
    $r = New-FFmpegThumbnail -i $inputFilePath -o $outputFilePath -d $maxRes -q $quality
    if ( $r.success ) {
        Write-Msg -s -ps -m 'Thumbnail generated.'
    }
    else {
        Write-Msg -e -ps -m $r.message
    }

    exit
