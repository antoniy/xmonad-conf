{-# LANGUAGE AllowAmbiguousTypes, DeriveDataTypeable,
  TypeSynonymInstances, MultiParamTypeClasses #-}

----------------------------------------------------------------------------
-- |
-- Module       : Conf.Bindings.Mouse
-- Copyright    : (c) maddy@na.ai
-- License      : MIT
--
-- Maintainer   : maddy@na.ai
-- Stability    : unstable
-- Portability  : unportable
--
----------------------------------------------------------------------------
module Conf.Bindings.Mouse
  ( mouse
  , clickJustFocuses
  , focusFollowsMouse
  ) where

import qualified Data.Map as Map

import qualified XMonad
import qualified XMonad.StackSet as StackSet

import qualified XMonad.Actions.FloatSnap as FloatSnap
import qualified XMonad.Actions.ConstrainedResize as ConstrainedResize

import qualified XMonad.Layout.WindowNavigation as WindowNavigation

import XMonad ((.|.))

clickJustFocuses  = True
focusFollowsMouse = False

-- TODO: Clean up this mess
mouse (XMonad.XConfig {XMonad.modMask = modMask}) =

  -- Mod + Click - Drag windows
  Map.fromList $
  [ ( (modMask, XMonad.button1)
    , (\w ->
         XMonad.focus w >> XMonad.mouseMoveWindow w >>
         FloatSnap.ifClick (FloatSnap.snapMagicMove (Just 50) (Just 50) w) >>
         XMonad.windows StackSet.shiftMaster))

  -- Mod + Right Click - Resize windows
  , ( (modMask, XMonad.button3)
    , (\w ->
         XMonad.focus w >> XMonad.mouseResizeWindow w >>
         FloatSnap.ifClick
           (FloatSnap.snapMagicResize [WindowNavigation.R, WindowNavigation.D] (Just 50) (Just 50) w) >>
         XMonad.windows StackSet.shiftMaster))

  -- Mod + Shift + Right Click - Resize windows, constain aspect ratio to 1:1
  , ( (modMask .|. XMonad.shiftMask, XMonad.button3)
    , (\w ->
         XMonad.focus w >> ConstrainedResize.mouseResizeWindow w True >>
         FloatSnap.ifClick
           (FloatSnap.snapMagicResize [WindowNavigation.R, WindowNavigation.D] (Just 50) (Just 50) w) >>
         XMonad.windows StackSet.shiftMaster))
  ]
