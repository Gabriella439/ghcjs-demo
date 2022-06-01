{-# LANGUAGE BlockArguments    #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.JSString (JSString)
import GHCJS.Foreign.Callback (Callback)
import GHCJS.Types (JSVal)
import JavaScript.Array (JSArray)

import qualified Data.JSString as JSString
import qualified GHCJS.Foreign.Callback as Callback
import qualified JavaScript.Array as Array

foreign import javascript unsafe "document.getElementById($1)"
    getElementById :: JSString -> IO JSVal

foreign import javascript unsafe "$1.textContent = $2"
    setTextContent :: JSVal -> JSString -> IO ()

foreign import javascript unsafe "$1.addEventListener($2, $3)"
    addEventListener :: JSVal -> JSString -> Callback (IO ()) -> IO ()

foreign import javascript unsafe "document.createElement($1)"
    createElement :: JSString -> IO JSVal

foreign import javascript unsafe "$1.before($2)"
    before :: JSVal -> JSVal -> IO ()

foreign import javascript unsafe "$1.setAttribute($2, $3)"
    setAttribute :: JSVal -> JSString -> JSString -> IO ()

foreign import javascript unsafe "replaceChildrenWorkaround($1, $2)"
    replaceChildren_ :: JSVal -> JSArray -> IO ()

replaceChildren :: JSVal -> [JSVal] -> IO ()
replaceChildren a b = replaceChildren_ a (Array.fromList b)

foreign import javascript unsafe "$1.remove()"
    remove :: JSVal -> IO ()

main :: IO ()
main = do
    addButton <- getElementById "click me"

    addCallback <- Callback.asyncCallback do
        subtractButton <- createElement "button"

        setTextContent subtractButton "-"

        input <- createElement "input"

        setAttribute input "type" "text"

        div <- createElement "div"

        replaceChildren div [ subtractButton, input ]

        subtractCallback <- Callback.asyncCallback (remove div)

        addEventListener subtractButton "click" subtractCallback

        before addButton div
        
    addEventListener addButton "click" addCallback
