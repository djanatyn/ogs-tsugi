{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}

module OGS.Tsugi.Api.Routes
  ( -- * OGS API
    OGSApi (..),
  )
where

import OGS.Tsugi.Api.Types
  ( APIResponse (..),
    Game (..),
    GameId (..),
    Page (..),
    Player (..),
    PlayerGames (..),
    PlayerId (..),
  )
import Servant.API
import Servant.API.Generic

data OGSApi r
  = OGSApi
      { getPlayer ::
          r :- "players" :> Capture "playerId" PlayerId
            :> Get '[JSON] Player,
        getGame ::
          r :- "games" :> Capture "gameId" GameId
            :> Get '[JSON] (APIResponse Game),
        getPlayerGames ::
          r :- "players" :> Capture "playerId" PlayerId :> "games"
            :> QueryParam "page" Page
            :> Get '[JSON] (APIResponse PlayerGames)
      }
  deriving (Generic)
