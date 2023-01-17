{-# language DeriveAnyClass #-}

module Application.Helper.View (
    -- To use the built in login:
    -- module IHP.LoginSupport.Helper.View
    trackWidget,
    Widget(..),
) where

-- Here you can add functions which are available in all your views
import IHP.ViewPrelude
import Generated.Types
import Data.Aeson as Aeson
import Web.JsonTypes
import qualified Generics.SOP as SOP
import GHC.Generics
import Language.Haskell.To.Elm

data Widget
  = TrackWidget TrackJSON
  deriving ( Generic
           , Aeson.ToJSON
           , SOP.Generic
           , SOP.HasDatatypeInfo
           )

-- haskell-to-elm instances for the Widget type

instance HasElmType Widget where
  elmDefinition =
    Just $ "Api.Generated.Widget"
              |> deriveElmTypeDefinition @Widget
                Language.Haskell.To.Elm.defaultOptions

instance HasElmDecoder Aeson.Value Widget where
  elmDecoderDefinition =
    Just $ "Api.Generated.widgetDecoder"
              |> deriveElmJSONDecoder @Widget
                Language.Haskell.To.Elm.defaultOptions Aeson.defaultOptions

instance HasElmEncoder Aeson.Value Widget where
  elmEncoderDefinition =
    Just $ "Api.Generated.widgetEncoder"
              |> deriveElmJSONEncoder @Widget
                Language.Haskell.To.Elm.defaultOptions Aeson.defaultOptions

-- Widgets

trackWidget :: Track -> Html
trackWidget track = [hsx|
    <div  data-flags={encode trackData} class="elm"></div>
|]
    where
        trackData :: Widget  = TrackWidget $ trackToJSON track