{-# LANGUAGE AllowAmbiguousTypes, DeriveDataTypeable,
  TypeSynonymInstances, MultiParamTypeClasses #-}

----------------------------------------------------------------------------
-- |
-- Module       : Conf.Theme
-- Copyright    : (c) maddy@na.ai
-- License      : MIT
--
-- Maintainer   : maddy@na.ai
-- Stability    : unstable
-- Portability  : unportable
--
----------------------------------------------------------------------------
module Conf.Theme where

import qualified Conf.Theme.Colors as Colors
import qualified Conf.Theme.Fonts as Fonts
import qualified Conf.Theme.Sizes as Sizes

import qualified XMonad.Layout.ShowWName as ShowWName
import qualified XMonad.Layout.Tabbed as Tabbed

import qualified XMonad.Prompt as Prompt

clickJustFocuses  = True
focusFollowsMouse = False

-- Window titles hidden
topBar =
  Prompt.def
  { Tabbed.fontName            = Fonts.titleFont

  , Tabbed.inactiveBorderColor = Colors.inactive
  , Tabbed.inactiveColor       = Colors.inactive
  , Tabbed.inactiveTextColor   = Colors.inactive

  , Tabbed.activeBorderColor   = Colors.active
  , Tabbed.activeColor         = Colors.active
  , Tabbed.activeTextColor     = Colors.active

  , Tabbed.urgentBorderColor   = Colors.red
  , Tabbed.urgentTextColor     = Colors.yellow

  , Tabbed.decoHeight          = Sizes.topbar
  }

tabbed =
  Prompt.def
  { Tabbed.fontName            = Fonts.titleFont

  , Tabbed.inactiveColor       = Colors.inactive
  , Tabbed.inactiveBorderColor = Colors.inactive
  , Tabbed.inactiveTextColor   = Colors.active

  , Tabbed.activeColor         = Colors.active
  , Tabbed.activeBorderColor   = Colors.active
  , Tabbed.activeTextColor     = Colors.inactive

  , Tabbed.decoHeight          = Sizes.tabbar
  }

prompt =
  Prompt.def
  { Prompt.font              = Fonts.font

  , Prompt.bgColor           = Colors.base03
  , Prompt.bgHLight          = Colors.active

  , Prompt.fgColor           = Colors.active
  , Prompt.fgHLight          = Colors.base03

  , Prompt.borderColor       = Colors.base03
  , Prompt.promptBorderWidth = 0

  , Prompt.height            = Sizes.prompt
  , Prompt.position          = Prompt.Top
  }

warmPrompt =
  prompt
  { Prompt.font     = Fonts.font

  , Prompt.bgColor  = Colors.yellow
  , Prompt.fgColor  = Colors.base03

  , Prompt.position = Prompt.Top
  }

hotPrompt =
  prompt
  { Prompt.font     = Fonts.font

  , Prompt.bgColor  = Colors.red
  , Prompt.fgColor  = Colors.base01

  , Prompt.position = Prompt.Top
  }

showWName =
  Prompt.def
  { ShowWName.swn_font    = Fonts.wideFont
  , ShowWName.swn_fade    = 0.5

  , ShowWName.swn_bgcolor = Colors.base02
  , ShowWName.swn_color   = Colors.blue
  }
