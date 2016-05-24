module Main where

import App (Action(..))
import App.Layout (State, view, update)
import App.Routes (match)
import Control.Bind ((=<<))
import Control.Monad.Eff (Eff)
import DOM (DOM)
import Prelude (bind, pure)
import Pux (App, Config, CoreEffects, fromSimple, renderToDOM)
import Pux.Router (sampleUrl)
import Signal ((~>))
import Signal.Channel (subscribe)

type AppEffects = (dom :: DOM)

-- | App configuration
config :: forall eff. State -> Eff (dom :: DOM | eff) (Config State Action AppEffects)
config state = do
  -- | Create a signal of URL changes.
  urlSignal <- sampleUrl
  -- | Map a signal of URL changes to PageView actions.
  let routeSignal = urlSignal ~> \r -> PageView (match r)

  pure
    { initialState: state
    , update: fromSimple update
    , view: view
    , inputs:
      [ subscribe state.channel
      , routeSignal
      ]
    }

-- | Entry point for the browser.
main :: State -> Eff (CoreEffects AppEffects) (App State Action)
main state = do
  app <- Pux.start =<< config state
  renderToDOM "#app" app.html
  -- | Used by hot-reloading code in support/index.js
  pure app

-- | Entry point for the browser with pux-devtool injected.
debug :: State -> Eff (CoreEffects AppEffects) (App State (Pux.Devtool.Action Action))
debug state = do
  app <- Pux.Devtool.start =<< config state
  renderToDOM "#app" app.html
  -- | Used by hot-reloading code in support/index.js
  pure app
