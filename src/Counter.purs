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

-- | This provider injects Pux context into the tree.  See `jsApp` below.
puxProvider :: forall a b s. Channel b -> State s -> Array (Html a) -> Html a
puxProvider chan state children =
  puxProviderImpl
    [ attr "store"
      { channel: chan
      , state
      }
    ]
    children

-- | This represents an arbitrarily large, existing React application.
-- | Pux store context is provided to it via the puxProvider.
-- | It'd be good to pull these two things into a single, simpler
-- | helper function (ideally one that accepts the pre-Pux.fromReact
-- | component).
foreign import jsApp :: forall a. ReactComponent a

view :: forall a s. Channel a -> State s -> Html a
view chan state =
  div
    []
    [ puxProvider chan state
      [ jsApp [] []
      ]
    ]
