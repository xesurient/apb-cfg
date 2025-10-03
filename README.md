# APB Reloaded Config (APB-CFG)
Everything within this config may or may not be kept up to date with what LO will allow/disallow when it comes to modifying files so when an update to the game is issued, it's always recommended to readd through any patch notes to ensure you're up to date with LO's rules and compliance. 

Older versions whilst still available shouldn't be used unless you know what you want out of them is allowed.

> [!IMPORTANT]
> If anything were to happen to your account due to use of modifed game files that is not my responsibility, you can contact Little Orbit support at **support@littleorbit.com**

# Installation

Go to releases in Github and download the .bat (batch) file listed (you are free to review this file with an AI tool, or yourself), the file is initially small, will ask to confirm that where you have placed it, is where you will keep the config indefinitely as more files from the GitHub repository will be downloaded, once ready, click the corresponding character on your keyboard.

The batch file (launcher) will exit after download has completed, relaunch it to gain options, you will first be asked to specify the drive letter of where APB is installed or optionally you can manual input this path if you have multiple instances of the game.

The launcher will also create a clean copy of the whole APB directory on the user's behalf, so that when there is a game update, the relevant files will be downloaded without forcing a full game recheck and copied by the launcher into the config game directory.

The launcher allows for multiple operations such as launching specific config variants of the game, creating desktop shortcuts for the specific variants of the game, customizing colors for killfeeds as well as other things in the future, most importantly the batch script on launch will fetch a changelog from this GitHub as a way to check if a new version has been released, when an update is issued, you can click 'U' to initate an update with the on-screen message being disaplyed during this update.

> [!CAUTION]
> Do not run the script as admin as it will store the files in the user's 'temp' directory, deleting all files on closing of the launcher.
> If you do not get the desired outcome then you haven't correctly pointed the launcher to your game and will likely have to retrace your inputted directories.

>[!NOTE]
> When the game has a new update, you will have to run in the 'Update Game' function.

# Launch Arguments
> The launcher creates relevant shortcuts with the following arguments unless specified otherwise.
- `-language=1031`                  - Sets game to load with custom localization
- `-nosteam`                        - Disables Steam integration so you'll have no overlay and no Steam login
- `-nomovies` / `-nomoviesstartup`  - Removes loading screens
- `-nosplash`                       - Removes initial splash screen upon boot

Target Field Example
`"..\APB Reloaded\Binaries\APB.exe" -language=1031 -nomovies -nosplash`

# GC On + Streaming Off
- All of the social kiosks e.g clothing, vehicle, character, theme and symbol work fine with these files
- Disables the texture streaming system forcing whichever graphics you start with to be the maximum you'll see without restarting (on most objects)
- Gained FPS varies per system
- If you want an easy way of re-enabling the kiosks you can drag these files in to overwrite the stutter fix, just remember to put stutter fix back in afterwards

# GC Off Stutter Fix
- Some of the social kiosks e.g clothing, vehicle and character will not load with these files, the remaining studios, theme and symbol do work however 
- Disables the texture streaming system forcing whichever graphics you start with to be the maximum you'll see without restarting (on most objects)
- Gained FPS varies per system
- You may experience large stutters on the respawn screen after a long time of being alive due to this now being when the garbage dump will happen

> [!IMPORTANT]
> If you find yourself frozen on the respawn screen for an extended period of time and either your team or the enemy progresses to the next stage of a mission you will not be able to see the new objective(s) when you respawn. This can also cause you to have ghost respawn circles appear on the map that when clicked do nothing. These bugs have no fixes without re-enabling garbage collection.

# Command Changes (If using localization)

- /abandonmission -> /a
- /pop -> /z
- /latencytest -> /ping
- /dance -> /e
- /shiver -> /q
- /dance variants -> /urban /michael /techno etc.
- /strikeapose1/2 -> /pose1 /pose2

# Graphics

> [!NOTE]
> All graphics options are labelled in the options menu in-game.
> Shadows do not work on all presets, if you want them just enable it under advanced graphics in-game after selecting the preset you like. If it doesn't work however, go into `APBMachineOptions` and remove the `DynamicShadows` and `LightEnvironmentShadows` lines, save, restart the game then re-enable shadows again.
> If you wish to remove bullet holes, in `APBCompat` set  `ParticleMaxWorldSpaceArea` to a value of `0.1` and so that the nade trails aren't almost invisible ensure that `TEXCAT_VFX Usage 0 and 1` have their `MaxLODSize` set to `16` and their `LODBias` set to `4`. **You cannot see vehicle fire with ParticleMaxWorldSpaceArea set this way**

# Keybinds
All of the binds listed below are there as additions to the original keybinds so you have the choice rather than being forced to use one or the other. This just means that you will have to go to the respective keybind category and set which options you prefer.

> [!IMPORTANT]
> By default your game will be using the binds you had previously or if you're on a fresh account some binds will now be completely blank, simply go into Options > Controls and set them manually.

*Category listed at beginning*

   - Interface | Social Designers - This will only work in social but lets you bind a key to open the Clothing, Character, Vehicle, Symbol and Theme studios
   - Movement  | Crouch (New Hold) - Alternative method for hold to crouch that doesn't get stuck as it implements a jump before crouching
   - Driving   | Vehicle Special Function (Hold) - This allows you to hold the siren on rather than have it toggle, if it gets stuck hold the button whilst getting out of the car to reset it, or have a bind for toggle aswell
   - Combat    | Lean (Hold) - Hold down the lean key rather than have it toggle
   - Combat    | Primary/Secondary weapon - Allows you to set keys to select which weapon you want rather than cycle between them which is the default behaviour
   - Music     | Music Player Volume - Controls the volume of the music player in steps of 20
   - Camera    | Camera look up/down - Extremely fast but there if you really need it

*Default Xbox controller related keybinds are removed with this file*

# Disabling UI Elements
Some elements are disabled by defualt in order to optimize overlay usage, as elements are drawn regardless of the game mode, e.g. mini-games overlay is always active.

As this is something that can be quite customised I'm not going to create presets for it however a quick rundown for how to do it can be found here: [Interface - iazer's cfg](https://github.com/lvzxr/apb-reloaded/blob/main/UI.md)

## Features
- GC On + Streaming Off  - All information above.
- GC Off Stutter Fix - All information above.
- Keybinds - All information above.
- Localization - Customized to my preferences.
- No Ragdolls - Removes player/pedestrian ragdolls.
- Graphics - Preset settings listed in-game.
- Emitter Fix - Set's priorties of emitters and npcs to 1 so they are only played when really close to you, this also has the effect of making them quieter, included as different variants with ragdolls and muzzle flash.

# Remove / Uninstall

> [!IMPORTANT]
> If you wish to uninstall the config it is recommended that you navigate to the main 'APB Reloaded' folder wherever that is, be it Gamersfirst or Steam and delete it completely, then find the 'APB Reloaded - Clean' folder in the same directory and rename it to the original folder name, this will delete the modified game and replace it with the clean files that are used for faster updating.
