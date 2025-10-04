#==================================================================================================================
#==================================================================================================================
# Sample Code :: Get FF PROBE Encoding Summary
#==================================================================================================================
#==================================================================================================================

#==================================================================================================================
# Initialize Test Environment
#==================================================================================================================

# Load the standard test initialization file.
. $(Join-Path -Path $PSScriptRoot -ChildPath '_init-test-environment.ps1')

# Override the Default Debug Logging Setting
  $env:PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES = $true

#==================================================================================================================
# Run Tests
#==================================================================================================================

#---------------------------------------
# Repo TV Show Test
#---------------------------------------

    $testFileName = 'TVEpisodes/Breaking In - s01e06 - Breaking Out [1080p WS iTunes HD DD].m4v'
    $testFilePath = Join-Path -Path $mediaPath -ChildPath $testFileName
    $properties = Get-FFprobeEncodingSummary -File $testFilePath
    $properties
    $properties.value
    # exit

#-----------------------------------------
# Repo Movie Test
#-----------------------------------------

    $testFileName = 'Movies/Abominable (2019) [1080p WS iTunes HD DD].m4v'
    $testFilePath = Join-Path -Path $mediaPath -ChildPath $testFileName
    $properties = Get-FFprobeEncodingSummary -File $testFilePath
    $properties
    $properties.value
    exit
