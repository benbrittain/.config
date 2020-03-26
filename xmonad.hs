import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import System.IO
import XMonad.Actions.CycleWS
import XMonad.Config.Gnome
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Combo
import XMonad.Layout.Grid
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Named
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect
import XMonad.Layout.TwoPane
import XMonad.Layout.WindowNavigation
import XMonad.Util.WindowProperties
import Control.Monad
import Data.Ratio
import qualified Data.Map as M
import qualified XMonad.StackSet as S
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Gaps
myBorderWidth = 2
myNormalBorderColor = "#202030"
myFocusedBorderColor = "#A0A0D0"

myWorkspaces = ["main","web","programming","chat","media","minimize"]

myModMask = mod4Mask
altMask = mod1Mask

myKeys conf = M.fromList $
    [ ((myModMask              , xK_Return), spawn $ XMonad.terminal conf)
    , ((myModMask              , xK_r     ), spawn "dmenu_run -b")
    , ((myModMask              , xK_f     ), spawn "firefox")
    , ((myModMask              , xK_g     ), spawn "google-chrome")
    , ((myModMask              , xK_c     ), kill)
    , ((myModMask              , xK_space ), sendMessage NextLayout)
    , ((myModMask              , xK_n     ), refresh)
    , ((myModMask              , xK_m     ), windows S.swapMaster)
    , ((altMask                , xK_Tab   ), windows S.focusDown)
    , ((altMask .|. shiftMask  , xK_Tab   ), windows S.focusUp)
    , ((myModMask              , xK_Down  ), windows S.swapDown)
    , ((myModMask              , xK_Up    ), windows S.swapUp)
    , ((myModMask              , xK_Left  ), sendMessage Shrink)
    , ((myModMask              , xK_Right ), sendMessage Expand)
    , ((myModMask              , xK_t     ), withFocused $ windows . S.sink)
    , ((myModMask              , xK_w     ), sendMessage (IncMasterN 1))
    , ((myModMask              , xK_v     ), sendMessage (IncMasterN (-1)))
    , ((myModMask              , xK_q     ), broadcastMessage ReleaseResources >> restart "xmonad" True)
    , ((myModMask .|. shiftMask, xK_q     ), spawn "sudo shutdown -h now")
    , ((myModMask .|. shiftMask, xK_z     ), spawn "xscreensaver-command --lock")
    , ((altMask .|. controlMask, xK_Left  ), prevWS)
    , ((altMask .|. controlMask, xK_Right ), nextWS)
    ] ++
    [ ((altMask, k), windows $ S.greedyView i)
        | (i, k) <- zip myWorkspaces workspaceKeys
    ] ++
    [ ((myModMask, k), (windows $ S.shift i) >> (windows $ S.greedyView i))
        | (i, k) <- zip myWorkspaces workspaceKeys
    ]
    where workspaceKeys = [xK_F1 .. xK_F10]

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ defaultConfig
        { manageHook = ( isFullscreen --> doFullFloat ) <+> manageDocks <+> manageHook defaultConfig
        -- manageHook = manageDocks <+> manageHook defaultConfig
        , layoutHook = avoidStruts $ layoutHook defaultConfig
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 75
                        , ppLayout = const ""
                        }
        , terminal = "alacritty"
        , workspaces = myWorkspaces
        , keys = myKeys
        }
