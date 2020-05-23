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

import Data.Aeson (Value)
import OGS.Tsugi.Api.Types (PlayerId (..))
import Servant.API
import Servant.API.Generic

data OGSApi r
  = OGSApi
      { getPlayer ::
          r :- "players" :> Capture "playerId" PlayerId
            :> Get '[JSON] Value
      }
  deriving (Generic)
