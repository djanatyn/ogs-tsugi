{-# LANGUAGE DerivingVia #-}

module OGS.Tsugi.Api.Types
  ( -- * API Types
    PlayerId (..),
  )
where

import Servant.API

newtype PlayerId = PlayerId Int deriving (ToHttpApiData) via Int
