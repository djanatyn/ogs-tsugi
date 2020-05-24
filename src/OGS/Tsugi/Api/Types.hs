{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module OGS.Tsugi.Api.Types
  ( -- * API Types
    PlayerId (..),
    GameId (..),
    Player (..),
    Game (..),
  )
where

import Data.Aeson
import Data.Text (Text)
import GHC.Generics (Generic)
import Servant.API (ToHttpApiData)

newtype PlayerId = PlayerId Int deriving (ToHttpApiData, Show, FromJSON) via Int

newtype GameId = GameId Int deriving (ToHttpApiData, Show, FromJSON) via Int

data Game
  = Game
      { gameId :: GameId,
        name :: Text,
        handicap :: Int,
        black :: PlayerId,
        white :: PlayerId,
        rules :: Text,
        komi :: Double,
        winner :: PlayerId,
        endTime :: Int
      }
  deriving (Show)

instance FromJSON Game where
  parseJSON = withObject "game" $ \o -> do
    name <- o .: "name"
    handicap <- o .: "handicap"
    black <- o .: "black"
    white <- o .: "white"
    rules <- o .: "rules"
    gamedata <- o .: "gamedata"
    gameId <- gamedata .: "game_id"
    komi <- gamedata .: "komi"
    winner <- gamedata .: "winner"
    endTime <- gamedata .: "end_time"
    return Game {..}

data Player
  = Player
      { username :: Text,
        name :: Text,
        id :: PlayerId
      }
  deriving (Generic, Show)

instance FromJSON Player
