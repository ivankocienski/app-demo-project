module Main exposing (main)

import Browser
import Url
import Browser.Navigation as Nav
import Html exposing (Html, text, div, h1, h2, ul, li, a, p)
import Html.Attributes exposing (href)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)

import Common exposing (Model, Msg(..), PartnerIndex, Page(..))
import Api


navModeParser : Parser (Page -> a) a
navModeParser =
    oneOf
        [ Parser.map Root Parser.top
        --, Parser.map ShowPost (Parser.s "blog" </> Parser.string)
        --, Parser.map NotFound (Parser.s "*")
        ]

navParseUrlToMode : Url.Url -> Page
navParseUrlToMode url = 
  Maybe.withDefault NotFound (Parser.parse navModeParser <| url)

{----

Elm core bits

----}

init : flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
  ( Model navKey (navParseUrlToMode url) (PartnerIndex [] 0)
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

    UrlChanged url ->
      ( { model | page = navParseUrlToMode url }
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

titleForPage : Model -> String
titleForPage model =
  (case model.page of
    Root -> "Home"
    NotFound -> "Not Found"
  ) ++ " - API Demo"

viewForRoot : Model -> List (Html Msg)
viewForRoot model =
  let
      partnerRenderer partner =
        li [] [ a [ href ( "/partners/" ++ String.fromInt( partner.id )) ] [ text partner.name ] ]

  in
    [ h1 [] [ text "Partners" ]
    , h2 [] [ text ("Found " ++ String.fromInt( model.partnerData.count )) ]
    , ul [] (List.map partnerRenderer model.partnerData.partners)
    ]
  
viewForNotFound: Model -> List (Html Msg)
viewForNotFound _ =
  [ h1 [] [ text "Page not found" ]
  , p [] [ text "The page you were looking for does not exist" ]
  ]

view : Model -> Browser.Document Msg
view model =
  { title = (titleForPage model)
  , body =
    (case model.page of
      Root -> viewForRoot model
      NotFound -> viewForNotFound model
    )
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
