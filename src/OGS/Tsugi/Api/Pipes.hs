module OGS.Tsugi.Api.Pipes
  ( -- * Stream PlayerGames
    playerGamesP,
  )
where

import Control.Concurrent (threadDelay)
import Data.Coerce
import OGS.Tsugi.Api.Client
import OGS.Tsugi.Api.Routes
import Pipes

-- | Time to delay each subsequent request in a streaming Producer.
streamDelay :: Int
streamDelay = 1000000 * 3 -- 3 seconds

-- | Fetch a player game listing page. Throw an exception on any ClientError.
fetchPlayerGames ::
  PlayerId ->
  Page ->
  IO (APIResponse PlayerGames)
fetchPlayerGames playerId page = do
  response <-
    runOgs $
      getPlayerGames ogsClient playerId (Just page)
  either (error . show) return response

-- | Yield a page. If the next page exists, fetch it and loop.
playerGamesLoop ::
  PlayerId ->
  Page ->
  APIResponse PlayerGames ->
  Producer (APIResponse PlayerGames) IO ()
playerGamesLoop playerId page playerGames = do
  yield playerGames
  lift $ threadDelay streamDelay
  case nextPage . coerce $ playerGames of
    Nothing -> return ()
    Just _ -> do
      response <- lift $ fetchPlayerGames playerId (page + 1)
      playerGamesLoop playerId (page + 1) (coerce response)

-- | Pipe for streaming player game listings.
playerGamesP ::
  PlayerId ->
  Page ->
  Producer (APIResponse PlayerGames) IO ()
playerGamesP playerId page = do
  response <- lift $ fetchPlayerGames playerId page
  playerGamesLoop playerId page response
