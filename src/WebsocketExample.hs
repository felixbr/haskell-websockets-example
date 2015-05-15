{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}

module WebsocketExample where

import Control.Monad (forM_, forever)
import Control.Monad.IO.Class (liftIO)
import Control.Concurrent (MVar, newMVar, modifyMVar, modifyMVar_, putMVar, readMVar)
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.IO as T
import Network.Wai
import Network.Wai.Handler.WebSockets
import qualified Network.WebSockets as WS

type Client = (Text, WS.Connection)
type ServerState = [Client]

newServerState :: ServerState
newServerState = []

addClient :: Client -> ServerState -> ServerState
addClient client clients = client : clients

broadcast :: Text -> ServerState -> IO ()
broadcast msg clients = do
    T.putStrLn msg
    forM_ clients $ \(_, conn) -> WS.sendTextData conn msg

application :: MVar ServerState -> WS.PendingConnection -> IO ()
application state pending = do
    conn <- WS.acceptRequest pending
    WS.forkPingThread conn 30
    username <- WS.receiveData conn

    -- join chat
    let newClient = (username, conn)
    liftIO $ modifyMVar_ state $  \s -> do
        return $ addClient newClient s

    -- continue broadcasting subsequent messages
    talk conn username state

talk :: WS.Connection -> Text -> MVar ServerState -> IO ()
talk conn username state = forever $ do
    msg <- WS.receiveData conn
    liftIO $ readMVar state >>= broadcast msg

main :: IO ()
main = do
    state <- newMVar newServerState
    WS.runServer "0.0.0.0" 9160 $ application state