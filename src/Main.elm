module Main exposing (main)

import Browser
import Url
import Browser.Navigation as Nav
import Html exposing (Html, text, div, h1, h2, ul, li)

import Common exposing (Model, Msg(..), PartnerIndex)
import Api

init : flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
  ( Model navKey (PartnerIndex [] 0)
  --, Cmd.none)
  , Api.readPostsIndex)


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

    GotPartnersForIndex result ->
      case result of
        Ok partnerData ->
          ( { model | partnerData = partnerData }
          , Cmd.none
          )
        Err _ ->
          ( model
          , Cmd.none
          )


view : Model -> Browser.Document Msg
view model =
  let
      partnerRenderer partner =
        li [] [ text partner.name ]

  in
    { title = "Hello"
    , body =
      [ h1 [] [ text "Partners" ]
      , h2 [] [ text ("Found " ++ String.fromInt( model.partnerData.count )) ]
      , ul [] (List.map partnerRenderer model.partnerData.partners)
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
