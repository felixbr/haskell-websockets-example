{-# LANGUAGE OverloadedStrings #-}

module WebsocksetsWai where

import Network.Wai
import Network.HTTP.Types (status200)
import Network.Wai.Handler.Warp (run)
import Network.Wai.Handler.WebSockets

application :: Request -> (Response -> IO ResponseReceived) -> IO ResponseReceived
application _ respond = respond $
  responseLBS status200 [("Content-Type", "text/plain")] "Hello World"

-- app2 :: Request -> (Response -> IO ResponseReceived) -> IO ResponseReceived
-- app2 req res = if isWebSocketsReq req then
--
-- main = runServer "localhost" 8000 app2