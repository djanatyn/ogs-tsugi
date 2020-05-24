{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module OGS.Tsugi.Api.Types
  ( -- * API Types
    PlayerId (..),
    GameId (..),
    Page (..),
    Player (..),
    Game (..),
    APIResponse (..),
    PlayerGames (..),
  )
where

import Control.Monad (forM)
import Data.Aeson
import Data.Text (Text)
import GHC.Generics (Generic)
import Servant.API (ToHttpApiData)

newtype PlayerId = PlayerId Int deriving (ToHttpApiData, Show, FromJSON) via Int

newtype GameId = GameId Int deriving (ToHttpApiData, Show, FromJSON) via Int

newtype Page = Page Int deriving (ToHttpApiData, Show, FromJSON) via Int

newtype APIResponse a = APIResponse a deriving (Show)

data Game
  = Game
      { gameId :: GameId,
        name :: Text,
        handicap :: Int,
        black :: PlayerId,
        white :: PlayerId,
        blackLost :: Bool,
        whiteLost :: Bool,
        rules :: Text,
        komi :: Text
      }
  deriving (Show)

instance FromJSON (APIResponse Game) where
  parseJSON = withObject "game" $ \o -> do
    name <- o .: "name"
    handicap <- o .: "handicap"
    black <- o .: "black"
    white <- o .: "white"
    rules <- o .: "rules"
    blackLost <- o .: "black_lost"
    whiteLost <- o .: "white_lost"
    gamedata <- o .: "gamedata"
    gameId <- gamedata .: "game_id"
    komi <- gamedata .: "komi"
    return $ APIResponse $ Game {..}

data Player
  = Player
      { username :: Text,
        name :: Text,
        id :: PlayerId
      }
  deriving (Generic, Show)

instance FromJSON Player

data PlayerGames
  = PlayerGames
      { games :: [Game],
        nextPage :: Maybe Text
      }
  deriving (Show)

instance FromJSON (APIResponse PlayerGames) where
  parseJSON = withObject "response" $ \o -> do
    nextPage <- o .:? "next"
    results <- o .: "results"
    games <- forM results $ \r -> do
      name <- r .: "name"
      handicap <- r .: "handicap"
      black <- r .: "black"
      white <- r .: "white"
      rules <- r .: "rules"
      gameId <- r .: "id"
      komi <- r .: "komi"
      blackLost <- r .: "black_lost"
      whiteLost <- r .: "white_lost"
      return Game {..}
    return $ APIResponse $ PlayerGames {..}
