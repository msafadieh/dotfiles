import Control.Monad(join, when)
import Data.Maybe(maybeToList)
import Data.Ratio
import System.IO
import Text.Numeral.Roman
import XMonad hiding ( (|||) )
import XMonad.Actions.CycleWS
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.TwoPane
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Spacing
import XMonad.StackSet
import XMonad.Util.EZConfig(additionalKeys, additionalKeysP)
import XMonad.Util.Run(spawnPipe)
import XMonad.Wallpaper

browser = "firefox"
editor = "codium"
chat = "riot-desktop"
modKey = mod4Mask

main = do
        nextcloud <- spawnPipe "nextcloud"
        nmapplet <- spawnPipe "nm-applet"
        bmapplet <- spawnPipe "blueman-applet"
        picom <- spawnPipe "picom"
        stalonetray <- spawnPipe "stalonetray"
        xinput <- spawnPipe "xinput set-button-map 'ELAN1300:00 04F3:3087 Touchpad' 1 1 3 4 5 6 7 8 9 10"
        xflux <- spawnPipe "pidof xflux || xflux -z 12604"
        xautolock <- spawnPipe "xautolock -time 15 -locker 'systemctl suspend' -detectsleep -corners '0-00'"
        xmproc <- spawnPipe "xmobar $HOME/.xmonad/xmobar"
        setRandomWallpaper ["$HOME/.wallpapers"]
        xmonad $ ewmh $ def
          { manageHook = myManageHook
          , layoutHook = smartBorders myLayout 
          , handleEventHook  = handleEventHook def 
                                <+> docksEventHook 
                                <+> fullscreenEventHook
          , logHook = myLogHook xmproc
          , modMask = modKey
          , terminal = "alacritty"
          , normalBorderColor = "#dda0dd"
          , focusedBorderColor = "#9400D3"
          , borderWidth = 5
          , startupHook = addEWMHFullscreen
          } `additionalKeys` myKeys
            `additionalKeysP` myKeysP 


myLogHook xmproc = dynamicLogWithPP xmobarPP
                    { ppOutput = hPutStrLn xmproc
                    , ppCurrent = xmobarColor "yellow" "#8851a5" . workspaceFormat
                    , ppHidden = workspaceFormat
                    , ppHiddenNoWindows = workspaceFormat
                    , ppUrgent = xmobarColor "red" "" . workspaceFormat
                    , ppLayout = \x -> []
                    , ppTitle = \x -> []
                    , ppWsSep = []
                    }

myManageHook = composeAll
  [ manageDocks,
    isFullscreen --> doFullFloat,
    className=? "Tor Browser" --> doCenterFloat,
    resource=? "ncmpcpp" --> doRectFloat (RationalRect (1 % 3) (1 % 4) (1 % 3) (1 % 2)),
    manageHook defaultConfig
  ] 

myKeys = 
  [ ((0, xK_Print), spawn "(mkdir $HOME/screenshots || true) && scrot $HOME/screenshots/$(date +%Y%m%d%H%M%S).png")
  , ((modKey, xK_p), spawn "(mkdir $HOME/screenshots || true) && scrot $HOME/screenshots/$(date +%Y%m%d%H%M%S).png")
  , ((modKey, xK_r), spawn "dmenu_run -fn 'Fira Code-11' -nb '#4c2462' -nf '#f4f4f4' -sf '#f4f4f4' -sb '#965eb5'")
  , ((modKey, xK_Return), spawn "alacritty")
  , ((modKey, xK_w), spawn browser)
  , ((modKey, xK_z), spawn chat)
  , ((modKey, xK_a), spawn editor)
  , ((modKey, xK_d), spawn "xautolock -toggle")
  , ((modKey, xK_Right), nextWS)
  , ((modKey, xK_Left ), prevWS)
  , ((modKey, xK_f ), sendMessage $ JumpToLayout "Full" )
  ]

myKeysP = [
    ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
  , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@  -5%") 
  , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle") 
  , ("M-S-<Return>", spawn "alacritty --class ncmpcpp -e ncmpcpp")
  , ("<XF86MonBrightnessDown>", spawn "light -U 10")
  , ("<XF86MonBrightnessUp>", spawn "light -A 10")
 ]

myLayout = avoidStruts
           (twopane
           ||| tiled)
           ||| Full
           where
            nmaster = 1
            ratio = 1/2
            delta = 3/100
            space = 5
            tiled = spacing space $ ResizableTall nmaster delta ratio []
            twopane = spacing space $ TwoPane delta ratio

workspaceFormat = spacePadding . romanWorkspace

spacePadding :: String -> String
spacePadding w = " " ++ w ++ " "
--- Roman numerals for workspace tags
romanWorkspace :: WorkspaceId -> String
romanWorkspace w = toRoman (read w :: Int)

--- Adds full screen support to firefox
addNETSupported :: Atom -> X ()
addNETSupported x = withDisplay $ \dpy -> do
  r               <- asks theRoot
  a_NET_SUPPORTED <- getAtom "_NET_SUPPORTED"
  a               <- getAtom "ATOM"
  liftIO $ do
    sup <- join . maybeToList <$> getWindowProperty32 dpy a_NET_SUPPORTED r
    when (fromIntegral x `notElem` sup) $ changeProperty32 dpy
                                                           r
                                                           a_NET_SUPPORTED
                                                           a
                                                           propModeAppend
                                                           [fromIntegral x]

addEWMHFullscreen :: X ()
addEWMHFullscreen = do
  wms <- getAtom "_NET_WM_STATE"
  wfs <- getAtom "_NET_WM_STATE_FULLSCREEN"
  mapM_ addNETSupported [wms, wfs]
