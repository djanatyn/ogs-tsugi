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

import OGS.Tsugi.Api.Types (Game (..), GameId (..), Player (..), PlayerId (..))
import Servant.API
import Servant.API.Generic

data OGSApi r
  = OGSApi
      { getPlayer ::
          r :- "players" :> Capture "playerId" PlayerId
            :> Get '[JSON] Player,
        getGame ::
          r :- "games" :> Capture "gameId" GameId
            :> Get '[JSON] Game
      }
  deriving (Generic)
