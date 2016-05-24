module App.Counter where

import Pux.Html (Html, Attribute, div)
import Pux.Html.Attributes (attr)
import Signal.Channel (Channel)

type State a =
  { count :: Int
  , text :: String
  | a
  }

type ReactComponent a =
  Array (Attribute a)
  -> Array (Html a)
  -> Html a

foreign import puxProviderImpl :: forall a. ReactComponent a

puxProvider :: forall a b s. Channel b -> State s -> Array (Html a) -> Html a
puxProvider chan state children =
  puxProviderImpl
    [ attr "store"
      { channel: chan
      , state
      }
    ]
    children

foreign import jsApp :: forall a. ReactComponent a

view :: forall a s. Channel a -> State s -> Html a
view chan state =
  div
    []
    [ puxProvider chan state
      [ jsApp [] []
      ]
    ]
