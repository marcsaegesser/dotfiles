import System.IO
import System.Posix.Env

import Control.Monad                   (liftM2)

import Data.List                       (isPrefixOf, isInfixOf)
import Data.Map                        (fromList, union)

import XMonad
import XMonad.Core
import XMonad.Config
import XMonad.Operations

import qualified XMonad.Actions.CycleWS as CWS

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.FadeInactive

import XMonad.Layout
import XMonad.Layout.Grid
import XMonad.Layout.IM
import XMonad.Layout.NoBorders
import XMonad.Layout.LayoutHints
import XMonad.Layout.PerWorkspace
import XMonad.Layout.ResizableTile
import XMonad.Layout.StackTile
import XMonad.Layout.Mosaic

import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Util.Cursor
import XMonad.Util.NamedScratchpad
import XMonad.Util.Scratchpad

import XMonad.Actions.Warp
import XMonad.Actions.Volume
import XMonad.Actions.CopyWindow

import qualified XMonad.StackSet as W

import XMonad.Prompt
import XMonad.Prompt.RunOrRaise
import XMonad.Prompt.Shell

main = do
  myStatusBarPipe <- spawnPipe myStatusBar
  spawn "synclient PalmDetect=1 MinSpeed=0.3 MaxSpeed=0.3 AccelFactor=0"
  spawn "syndaemon -t -d"
  xmonad $ withUrgencyHook NoUrgencyHook $ defaultConfig
    { terminal          = myTerminal
    , workspaces        = myWorkspaces
    , modMask           = myModMask
    , layoutHook	= myLayoutHook
    , manageHook	= myManageHook
    , keys		= liftM2 union myKeys (keys defaultConfig)
    , startupHook	= myStartupHook
    , logHook           = myLogHook myStatusBarPipe
    , focusFollowsMouse = False
    }

myTerminal = "xterm"

myModMask = mod4Mask

myManageHook = composeAll
  [  className =? "stalonetray"	                     --> doIgnore
  ,  className =? "trayer"                           --> doIgnore
  ,  className =? "Pidgin" <&&> title=? "Buddy List" --> doFloat <+> doShift "float"  -- Pidgen Buddy List to the Float workspace
  ,  className =? "Pidgin"                           --> doFloat                      -- Pidgen Conversation windows float anywhere
  ,  className =? "Spotify"                          --> doFloat <+> doShift "float"
  ,  className =? "Gimp"                             --> doFloat <+> doShift "8"
  ,  className =? "Wicd-client.py"                   --> doFloat
--  ,  fmap ( "Emacs" `isInfixOf` ) className        --> doShift "emacs"
  ,  fmap ( "Skype" `isInfixOf` ) className          --> doFloat <+> doShift "float"
  ,  className =? "Eclipse"                          --> doShift "code"
  ,  className =? "XTerm" <&&> title =? "Emacs"      --> doShift "emacs"
  ,  fmap ( "LibreOffice" `isInfixOf` ) (stringProperty "WM_NAME")      --> doShift "office"
  ,  isDialog                                        --> doFloat
  ,  scratchpadManageHookDefault
  ,  namedScratchpadManageHook myScratchpads
  ]

myScratchpads = [
      NS "htop" "xterm -name htop -e htop" (title =? "htop") (customFloating $ W.RationalRect (1/4) (1/6) (1/2) (2/3))
    , NS "nautilus" "nautilus --no-desktop" (className =? "Nautilus") (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3))
    ] where role = stringProperty "WM_WINDOW_ROLE"

myWorkspaces = [ "web", "emacs", "code", "vm", "office", "float", "xterms", "8", "9", "0"]

-- NOTE:  .|. is bitwise OR
myKeys conf@(XConfig {XMonad.modMask = modm}) = fromList $
  [ ((modm                , xK_a          ), sendMessage MirrorShrink)
  , ((modm                , xK_z          ), sendMessage MirrorExpand)
  , ((modm                , xK_g          ), warpToWindow (1/2) (1/2))    -- Move pointer to focused window
  , ((modm                , xK_n          ), namedScratchpadAction myScratchpads "nautilus")
  , ((modm                , xK_o          ), namedScratchpadAction myScratchpads "htop")
  , ((modm                , xK_s          ), shellPrompt myXPConfig)
  , ((modm                , xK_F2         ), scratchpadSpawnAction conf)
  , ((modm                , xK_F5         ), lowerVolume 4 >> return ())
  , ((modm                , xK_F6         ), raiseVolume 4 >> return ())
  , ((modm                , xK_F10        ), spawn "bin/stop-xcompmgr.sh")  -- Stop xcompmgr because it gets confused often
  , ((modm                , xK_F11        ), spawn "bin/restart-xcompmgr.sh")  -- Restart xcompmgr because it gets confused often
  , ((modm                , xK_F12        ), spawn "xscreensaver-command -lock")
  , ((modm .|. controlMask, xK_j          ), CWS.nextWS)    -- Cycle through workspaces
  , ((modm .|. controlMask, xK_k          ), CWS.prevWS)
  , ((modm                , xK_BackSpace  ), focusUrgent)     -- Urgency hints
  , ((modm .|. shiftMask  , xK_BackSpace  ), clearUrgents)
  , ((0                   , xK_Print      ), spawn "scrot")
  , ((0                   , 0x1008ff11    ), lowerVolume 4 >> return ())  -- Keyboard volume down
  , ((0                   , 0x1008ff13    ), raiseVolume 4 >> return ())  -- Keyboard volume up
  , ((0                   , 0x1008ff12    ), toggleMute >> return ())     -- Keyboard volume mute
  , ((0                   , xK_Super_L    ), return())     -- Eat Windows key to (useful for Windows VMs)
  ]
  ++
  [ ((m .|. modm, k), windows $ f i)    -- Shift/Copy window
  | (i, k) <- zip myWorkspaces  $ [ xK_1..xK_9 ] ++ [ xK_0 ]
  , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask), (copy, shiftMask .|. controlMask)]
  ]
  ++
  [ ((modm .|. shiftMask, xK_c ), kill1)
  , ((modm              , xK_v ), windows copyToAll)
  , ((modm .|. shiftMask, xK_v ), killAllOtherCopies )
  ]

myStartupHook = setDefaultCursor xC_left_ptr

myFont = "Inconsolata"
myFgColor = "#DCDCCC"
myBgColor = "#3f3f3f"
myStatusBar = "Xmobar /home/msaegesser/.xmobarrc"

myLayoutHook = avoidStruts $ smartBorders $ standardLayouts
  where standardLayouts = tiled ||| mosaic 2 [3,2]  ||| Mirror tiled ||| Full
        tiled = ResizableTall nmaster delta ratio []
        nmaster = 1
        delta = 0.03
        ratio = 0.6

--myLogHook :: Handle -> X ()
myLogHook myStatusBarPipe =  do
  copies <- wsContainingCopies
  let check ws | ws == "NSP" = ""                                   -- Hide the scratchpad workspace
               | ws `elem` copies = xmobarColor "red" "black" $ ws  -- Workspaces with copied windows are red on black
               | otherwise = ws
  dynamicLogWithPP $ xmobarPP { ppHidden = check
                              , ppOutput = hPutStrLn myStatusBarPipe
                              , ppUrgent = xmobarColor "white" "red"
                              , ppTitle  = xmobarColor "green" "" . shorten 180
                              }
  fadeInactiveLogHook 0.6



myXPConfig = defaultXPConfig { position = Top
                             , searchPredicate = isInfixOf
                             }
