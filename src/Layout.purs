module App.Layout where

import App.Counter as Counter
import App (Action(..))
import App.Routes (Route(Home, NotFound))
import Control.Monad.Eff (Eff)
import Prelude ((-), (+), pure, bind)
import Pux.Html (Html, div, h1, p, text)
import Signal.Channel (channel, CHANNEL, Channel)

type State =
  { route :: Route
  , channel :: Channel Action
  , count :: Int
  , text :: String
  }

init :: Eff (channel :: CHANNEL) State
init = do
  chan <- channel Reset
  pure
    { route: NotFound
    , channel: chan
    , count: 0
    , text: ""
    }

update :: Action -> State -> State
update (PageView route) state = state { route = route }
update Increment state = state { count = state.count + 1 }
update Decrement state = state { count = state.count - 1 }
update Reset state = state { count = 0, text = "" }
update (TextInput text) state = state { text = text }

view :: State -> Html Action
view state =
  div
    []
    [ h1 [] [ text "Pux Starter App" ]
    , p [] [ text "Change src/Layout.purs and watch me hot-reload." ]
    , case state.route of
        Home -> Counter.view state.channel state
        NotFound -> App.NotFound.view state
    ]
