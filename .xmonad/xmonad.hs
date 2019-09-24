import XMonad hiding ( (|||) )
import XMonad.Actions.CycleWS
import XMonad.Util.EZConfig(additionalKeys, additionalKeysP)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.TwoPane
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Spacing
import XMonad.Util.Run(spawnPipe)
import XMonad.Wallpaper
import System.IO
import Text.Numeral.Roman

browser = "firefox"
editor = "codium"
chat = "riot-desktop"

main = do
    setRandomWallpaper ["$HOME/.wallpapers"]
    xmproc <- spawnPipe "xmobar $HOME/.xmonad/xmobar"
    rshift <- spawnPipe "redshift -l 41.69:-73.89"
    xmonad $ defaultConfig
        { manageHook = manageDocks <+> (isFullscreen --> doFullFloat) <+> manageHook defaultConfig 
        , layoutHook = smartBorders myLayout 
        , handleEventHook  = handleEventHook defaultConfig <+> docksEventHook <+> fullscreenEventHook
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppCurrent = xmobarColor "yellow" "" . romanWorkspace
                        , ppHidden = romanWorkspace
                        , ppHiddenNoWindows = romanWorkspace
                        , ppUrgent = xmobarColor "red" "" . romanWorkspace
                        , ppLayout = \x -> []
                        , ppTitle = \x -> []
                        }
        , modMask = modKey
        , terminal = "alacritty"
        , normalBorderColor = "#dda0dd"
        , focusedBorderColor = "#9400D3"
        , borderWidth = 2
        } `additionalKeys` myKeys
          `additionalKeysP` myKeysP


modKey = mod4Mask

myKeys = [
    ((modKey, xK_p), spawn "mkdir -p $HOME/screenshots && scrot $HOME/screenshots/$(date +%Y%m%d%H%M%S).png")
  , ((modKey, xK_r), spawn "dmenu_run -fn terminus-9.5 -nb '#4c2462' -nf '#f4f4f4' -sf '#f4f4f4' -sb '#965eb5'")
  , ((modKey, xK_Return), spawn "alacritty")
  , ((modKey, xK_w), spawn browser)
  , ((modKey, xK_a), spawn editor)
  , ((modKey, xK_z), spawn chat)

  , ((modKey, xK_Right), nextWS)
  , ((modKey, xK_Left ), prevWS)
  , ((modKey, xK_f ), sendMessage $ JumpToLayout "Full" )
 ]

myKeysP = [
    ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +1.5%")
  , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@  -1.5%") 
  , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle") 

  , ("<XF86MonBrightnessDown>", spawn "light -U 10")
  , ("<XF86MonBrightnessUp>", spawn "light -A 10")
 ]

myLayout = (avoidStruts $
           twopane
           ||| tiled)
           ||| Full
           where
               nmaster = 1
               ratio = 1/2
               delta = 3/100
               space = 5
               tiled = spacing space $ ResizableTall nmaster delta ratio []
               twopane = spacing space $ TwoPane delta ratio

romanWorkspace w = toRoman (read w :: Int)

