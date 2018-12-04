{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import Graphics.X11.ExtraTypes.XF86
import System.IO
import XMonad
import XMonad.Layout.NoBorders (noBorders, smartBorders)
import XMonad.Prompt
import XMonad.Prompt.Pass
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Actions.WindowBringer (bringMenu, gotoMenu)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import qualified XMonad.StackSet as W
import qualified XMonad.Util.Brightness as Brightness
import qualified XMonad.Actions.CycleWS
import XMonad.Config.Desktop (desktopConfig)
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Actions.CycleWindows
import XMonad.Layout.IndependentScreens (countScreens)
import XMonad.Util.WorkspaceCompare

main :: IO ()
main = do
  xmprocs <- do
    numScreens :: Integer <- countScreens
    let
      xmobarWorkspaces :: [WorkspaceId]
      xmobarWorkspaces =
        map show [0..numScreens-1]
    mapM
      (\wId -> do
        process <- spawnPipe $ "xmobar -x " ++ wId
        pure (wId, process)) xmobarWorkspaces
  xmonad $
    let
      baseConf =
        desktopConfig
          { manageHook = manageDocks <+> manageHook def
          , layoutHook =
              avoidStruts $
                smartBorders $
                  Full |||
                    Tall 1 (3 / 100) (1 / 2) |||
                      Mirror (Tall 1 (3 / 100) (1 / 2))
          , terminal = "xterm"
          , handleEventHook = docksEventHook <+> handleEventHook def
          , borderWidth = 2
          , focusFollowsMouse = False
          , startupHook = docksStartupHook <+> startupHook def
          , logHook =
              mapM_ (\(_, xmproc) ->
                dynamicLogWithPP xmobarPP
                  { ppOutput = hPutStrLn xmproc
                  , ppSort = getSortByXineramaPhysicalRule
                  }
                ) xmprocs
          , modMask = mod4Mask
          }
    in
      withUrgencyHookC
        BorderUrgencyHook { urgencyBorderColor = "#ffa500" }
        urgencyConfig { suppressWhen = Never } $
          baseConf `additionalKeys` myAdditionalKeys baseConf

  where
  myAdditionalKeys conf =
    [
      -- Start a fresh emacsclient
      ((mod4Mask .|. shiftMask, xK_e),
      spawn "emacsclient --c")

    , ((mod4Mask .|. shiftMask, xK_z),
      spawn "xscreensaver-command -lock")

      -- Start a fresh firefox
    , ((mod4Mask .|. shiftMask, xK_f),
      spawn "firefox")

      -- Lock to greeter
    , ((mod4Mask .|. shiftMask, xK_l),
      spawn "dm-tool switch-to-greeter")

      -- Urgents
    , ((mod4Mask, xK_BackSpace), focusUrgent)
    , ((mod4Mask .|. shiftMask, xK_BackSpace), clearUrgents)

    , ((mod4Mask, xK_s), cycleRecentWindows [xK_Super_L] xK_s xK_w)
    , ((mod4Mask, xK_z), rotOpposite)
    , ((mod4Mask, xK_i), rotUnfocusedUp)
    , ((mod4Mask, xK_u), rotUnfocusedDown)
    , ((mod4Mask .|. controlMask, xK_i), rotFocusedUp)
    , ((mod4Mask .|. controlMask, xK_u), rotFocusedDown)

      -- Bring up dmenu to go to window
    , ((mod4Mask, xK_g), gotoMenu)

      -- Bring up dmenu to bring window here
    , ((mod4Mask, xK_b), bringMenu)

      -- Bring up dmenu to start apps
    , ((mod4Mask, xK_p),
      spawn "dmenu_run")

      -- Mute volume.
    , ((0, xF86XK_AudioMute),
      spawn "amixer -D pulse set Master 1+ toggle")

    -- Decrease volume.
    -- , ((0, xF86XK_AudioLowerVolume),
    , ((0, xK_F11),
      spawn "amixer -D pulse set Master 5%-")

    -- Increase volume.
    -- , ((0, xF86XK_AudioRaiseVolume),
    , ((0, xK_F12),
      spawn "amixer -D pulse set Master unmute && amixer -D pulse set Master 5%+")

    -- Increase/decrease brightness
    -- Note: Requires small manual set up on new systems (see docs)
    , ((0, xF86XK_MonBrightnessUp), () <$ (liftIO $ Brightness.change (+50)))
    , ((0, xF86XK_MonBrightnessDown), () <$ do
          liftIO $ Brightness.change $ \current ->
            if current > 100
              then current - 50
              else current
      )
    , ((mod4Mask, xK_grave), XMonad.Actions.CycleWS.toggleWS)

    -- 'pass' integration
    , ((mod4Mask .|. shiftMask, xK_p),
       passPrompt def
        { font = "xft:Deja Vu Sans Mono-10"
        , height = 48
        })
    ]
    ++
    -- mod-[1..9] %! Switch to workspace N (non-greedy)
    [((m .|. mod4Mask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <-
            [ (W.view, 0)
            , (W.shift, shiftMask)
            , (W.greedyView, controlMask)
            ]]
