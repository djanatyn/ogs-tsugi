{-# LANGUAGE TypeApplications #-}

-- |
-- Module : OGS.Tsugi.Api.Client
-- Description : online-go.com client
--
-- >>> runOgs $ (getGame ogsClient $ GameId 16945653)
-- Right
--   ( Game
--       { id = 16945653,
--         name = "VincentL vs. djanatyn",
--         handicap = 0,
--         black = 437141,
--         white = 435842,
--         rules = "chinese",
--         gamedata =
--           GameRecord
--             { white_player_id = 435842,
--               black_player_id = 437141,
--               game_id = 16945653,
--               komi = 5.5,
--               rules = "chinese",
--               winner = 435842,
--               outcome = "Resignation",
--               end_time = 1552319896
--             }
--       }
--   )
--
-- >>> runOgs $ (getPlayer ogsClient $ PlayerId 435842)
-- Right
--   ( Player
--       { username = "djanatyn",
--         name = "Jonathan Strickland",
--         id = 435842
--       }
--   )
module OGS.Tsugi.Api.Client
  ( -- * OGS API Client
    ogsClient,
    runOgs,

    -- * OGS API Types
    module OGS.Tsugi.Api.Types,
    module OGS.Tsugi.Api.Routes,
  )
where

import Network.HTTP.Client.TLS
import OGS.Tsugi.Api.Routes
import OGS.Tsugi.Api.Types
import Servant.Client
import Servant.Client.Core (RunClient)
import Servant.Client.Generic

ogsClient :: RunClient m => OGSApi (AsClientT m)
ogsClient = genericClient @OGSApi

ogsApi :: String -> BaseUrl
ogsApi = BaseUrl Https "online-go.com" 443

ogsEnv :: IO ClientEnv
ogsEnv = do
  m <- newTlsManager
  return $ mkClientEnv m $ ogsApi "api/v1"

runOgs :: ClientM a -> IO (Either ClientError a)
runOgs action = do
  env <- ogsEnv
  runClientM action env
