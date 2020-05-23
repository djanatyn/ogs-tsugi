{-# LANGUAGE TypeApplications #-}

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
