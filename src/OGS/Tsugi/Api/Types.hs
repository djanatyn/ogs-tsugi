{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE GADTs #-}

module OGS.Tsugi.Api.Types
  ( -- * API Types
    PlayerId (..),
    Player (..),
  )
where

import Data.Aeson (FromJSON)
import Data.Text (Text)
import GHC.Generics (Generic)
import Servant.API (ToHttpApiData)

newtype PlayerId = PlayerId Int deriving (ToHttpApiData) via Int

data Player
  = Player
      { username :: Text,
        name :: Text,
        registration_date :: Text
      }
  deriving (Generic, Show)

instance FromJSON Player
