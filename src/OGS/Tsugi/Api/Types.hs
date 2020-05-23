{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE GADTs #-}

module OGS.Tsugi.Api.Types
  ( -- * API Types
    PlayerId (..),
    GameId (..),
    Player (..),
    Game (..),
  )
where

import Data.Aeson (FromJSON)
import Data.Text (Text)
import GHC.Generics (Generic)
import Servant.API (ToHttpApiData)

newtype PlayerId = PlayerId Int deriving (ToHttpApiData, Show, FromJSON) via Int

newtype GameId = GameId Int deriving (ToHttpApiData, Show, FromJSON) via Int

data Game
  = Game
      { id :: GameId,
        name :: Text,
        handicap :: Int,
        black :: PlayerId,
        white :: PlayerId,
        rules :: Text,
        gamedata :: GameRecord
      }
  deriving (Generic, Show)

data GameRecord
  = GameRecord
      { white_player_id :: PlayerId,
        black_player_id :: PlayerId,
        game_id :: GameId,
        komi :: Double,
        rules :: Text,
        winner :: PlayerId,
        outcome :: Text,
        end_time :: Int
      }
  deriving (Generic, Show)

data Player
  = Player
      { username :: Text,
        name :: Text,
        id :: PlayerId
      }
  deriving (Generic, Show)

instance FromJSON Player

instance FromJSON Game

instance FromJSON GameRecord
