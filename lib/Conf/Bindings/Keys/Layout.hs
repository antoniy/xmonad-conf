{-# LANGUAGE AllowAmbiguousTypes, DeriveDataTypeable,
  TypeSynonymInstances, MultiParamTypeClasses #-}

----------------------------------------------------------------------------
-- |
-- Module       : Conf.Bindings.Keys.Layout
-- Copyright    : (c) maddy@na.ai
-- License      : MIT
--
-- Maintainer   : maddy@na.ai
-- Stability    : unstable
-- Portability  : unportable
--
----------------------------------------------------------------------------
module Conf.Bindings.Keys.Layout
  ( layout
  ) where

import qualified Conf.Theme.Sizes as Sizes
import Conf.Layouts.DST as DST
import Conf.Layouts.Flex as Flex
import Conf.Layouts.Tabs as Tabs
import Conf.Layouts.Stacked as Stacked
import Conf.Layouts.CDT as CDT
import Conf.Layouts.Horizontal as Horizontal

import Conf.Bindings.Keys.Internal (subKeys)

import qualified Data.Map as Map

import qualified XMonad
import qualified XMonad.StackSet as StackSet

import qualified XMonad.Actions.WithAll as WithAll

import qualified XMonad.Layout.MultiToggle as MultiToggle
import qualified XMonad.Layout.MultiToggle.Instances as MultiToggle.Instances
import qualified XMonad.Layout.Gaps as Gaps
import qualified XMonad.Layout.Spacing as Spacing

import qualified XMonad.Util.Paste as Paste

import XMonad.Layout.LayoutCombinators (JumpToLayout(JumpToLayout))
import XMonad.Util.NamedActions (addName)

layout c = subKeys "Layout Management" c
  [ ( "M-S-F1", addName "Reset layout"            $ reset c)
  , ( "M-y",       addName "Float tiled w"           floatTiled)
  , ( "M-S-y",     addName "Tile all floating w"     tileFloating)
  , ( "M-C-,",     addName "Decrease master windows" decMaster)
  , ( "M-C-.",     addName "Increase master windows" incMaster)
  , ( "M-f",       addName "Fullscreen"              fullscreen)

  , ( "<F2>",    addName "Select Flex W BSP Layout" $ selectLayout Flex.nameW)
  , ( "C-<F2>",  addName "Select Flex S 1/2 Layout" $ selectLayout Flex.nameS)
  , ( "<F3>",    addName "Select Tabs Layout"       $ selectLayout Tabs.name)
  , ( "<F4>",    addName "Select DST Layout"        $ selectLayout DST.name)
  , ( "<F5>",    addName "Select Stacked Layout"    $ selectLayout Stacked.name)
  , ( "C-<F5>",  addName "Select Horizontal Layout" $ selectLayout Horizontal.name)
  , ( "<F6>",    addName "Select CDT Layout"        $ selectLayout CDT.name)

  , ( "M-C-0",   addName "No gaps"                   $ setGaps 0)
  , ( "M-C--",   addName "Reset gaps"                $ setGaps $ fromIntegral Sizes.gap)
  , ( "M-C-=",   addName "Big gaps"                  $ setGaps $ fromIntegral Sizes.gapBig)
  , ( "M--",     addName "Decrease gaps 5px"         $ decGaps 5)
  , ( "M-=",     addName "Increase gaps 5px"         $ incGaps 5)
  , ( "M-S--",   addName "Decrease gaps 10px"        $ decGaps 10)
  , ( "M-S-=",   addName "Increase gaps 10px"        $ incGaps 10)

  , ( "C-S-h",     addName "Ctrl-h passthrough"      hPass)
  , ( "C-S-j",     addName "Ctrl-j passthrough"      jPass)
  , ( "C-S-k",     addName "Ctrl-k passthrough"      kPass)
  , ( "C-S-l",     addName "Ctrl-l passthrough"      lPass)
  ]

reset c      = XMonad.setLayout   $ XMonad.layoutHook c

selectLayout l = do
  XMonad.sendMessage $ JumpToLayout l
  noGaps

floatTiled   = XMonad.withFocused toggleFloat
tileFloating = WithAll.sinkAll

decMaster    = XMonad.sendMessage (XMonad.IncMasterN (-1))
incMaster    = XMonad.sendMessage (XMonad.IncMasterN 1)

modGaps m n = do
  Spacing.incScreenWindowSpacing $ fromIntegral n
  mapM_
    (\d -> XMonad.sendMessage (m n d))
    [Gaps.L, Gaps.D, Gaps.U, Gaps.R]
  return ()

decGaps n = modGaps Gaps.IncGap (n * (-1))
incGaps = modGaps Gaps.IncGap

noGaps = decGaps 100 -- this is a hacky way to reset gaps, but Layout.Gaps has no 'setGaps' message

setGaps g = do
  noGaps
  incGaps g
  Spacing.setScreenWindowSpacing $ fromIntegral g
  return ()

fullscreen = sequence_
  [ (XMonad.withFocused $ XMonad.windows . StackSet.sink)
  , (XMonad.sendMessage $ MultiToggle.Toggle MultiToggle.Instances.FULL)
  ]

hPass = Paste.sendKey XMonad.controlMask XMonad.xK_h
jPass = Paste.sendKey XMonad.controlMask XMonad.xK_j
kPass = Paste.sendKey XMonad.controlMask XMonad.xK_k
lPass = Paste.sendKey XMonad.controlMask XMonad.xK_l

toggleFloat w =
  XMonad.windows
    (\s ->
       if Map.member w (StackSet.floating s)
         then StackSet.sink w s
         else (StackSet.float w (StackSet.RationalRect (1 / 3) (1 / 4) (1 / 2) (4 / 5)) s))
