{-# LANGUAGE UnicodeSyntax #-}
{-# LANGUAGE OverloadedStrings #-}

module SSEWai where

import Network.Wai.EventSource
import Network.Wai.Handler.Warp
import Network.Wai.Middleware.Cors
import Control.Concurrent.Chan
import Control.Concurrent
import Control.Monad
import Data.ByteString.Builder

main :: IO ()
main = do
    channel <- newChan
    _ <- forkIO $ simulateEvents channel
    putStrLn "serving..."
    run 8080 $ simpleCors $ eventSourceAppChan channel

simulateEvents :: Chan ServerEvent -> IO ()
simulateEvents chan = forever $ do
    threadDelay (10^6 * 2)
    let event = ServerEvent
                    (Just $ stringUtf8 "message")
                    (Just $ stringUtf8 "id")
                    [stringUtf8 "bla"]
    putStrLn "sending event"
    writeChan chan $ event