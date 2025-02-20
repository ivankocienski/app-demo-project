module Main exposing (main)

import Browser
import Url
import Browser.Navigation as Nav
import Html exposing (Html, text, div)

type Msg
  = LinkClicked Browser.UrlRequest
  | UrlChanged Url.Url

type alias Model = 
  { navKey : Nav.Key
  }

init : flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
  ( Model navKey
  , Cmd.none)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    LinkClicked urlRequest ->
      case urlRequest of
        Browser.Internal url ->
          (model, Nav.pushUrl model.navKey (Url.toString url))

        Browser.External href ->
          (model, Nav.load href)

    UrlChanged _ ->
      ( model 
      , Cmd.none)

view : Model -> Browser.Document Msg
view model =
  { title = "Hello"
  , body =
    [ div []
      [ text "Hello" 
      ]
    ]
  }

main : Program () Model Msg
main =
  Browser.application
  { init = init
  , view = view
  , update = update
  , subscriptions = \_ -> Sub.none
  , onUrlChange = UrlChanged
  , onUrlRequest = LinkClicked
  }
