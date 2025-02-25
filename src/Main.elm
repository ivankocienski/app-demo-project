module Main exposing (main)

import Api
import Browser
import Browser.Navigation as Nav
import Common exposing (Model, Msg(..), Page(..), PartnerIndex, PartnerShow(..))
import Html exposing (Html, a, article, br, div, footer, h1, h2, h4, li, p, text, ul)
import Html.Attributes exposing (class, href)
import Url
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)


navModeParser : Parser (Page -> a) a
navModeParser =
    oneOf
        [ Parser.map Root Parser.top
        , Parser.map ShowPartner (Parser.s "partners" </> Parser.int)

        --, Parser.map NotFound (Parser.s "*")
        ]


navParseUrlToMode : Url.Url -> Page
navParseUrlToMode url =
    Maybe.withDefault NotFound (Parser.parse navModeParser <| url)



{----

Elm core bits

----}


actionForPage : Page -> Cmd Msg
actionForPage page =
    case page of
        Root ->
            Api.readPostsIndex

        ShowPartner id ->
            Api.readPost id

        _ ->
            Cmd.none


init : flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        page =
            navParseUrlToMode url
    in
    ( Model navKey page (PartnerIndex [] 0) Empty
    , actionForPage page
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.navKey (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            let
                page =
                    navParseUrlToMode url
            in
            ( { model | page = navParseUrlToMode url }
            , actionForPage page
            )

        --( { model | page = navParseUrlToMode url }
        --, Cmd.none)
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

        GotPartnerForShow result ->
            case result of
                Ok showPartnerData ->
                    ( { model | showPartner = Loaded showPartnerData }
                    , Cmd.none
                    )

                Err error ->
                    ( { model | showPartner = Problem (Api.httpErrorDescription error) }
                    , Cmd.none
                    )


titleForPage : Model -> String
titleForPage model =
    (case model.page of
        Root ->
            "Home"

        NotFound ->
            "Not Found"

        ShowPartner id ->
            "Show partner (" ++ String.fromInt id ++ ")"
    )
        ++ " - API Demo"


viewForRoot : Model -> List (Html Msg)
viewForRoot model =
    let
        partnerRenderer partner =
            article [ class "content" ]
                [ h4 [] [ a [ href ("/partners/" ++ String.fromInt partner.id) ] [ text partner.name ] ]
                , p [ class "subtitle" ] [ text partner.summary ]
                , br [] []
                ]
    in
    [ h1 [ class "title" ] [ text "Partners" ]
    , h2 [ class "subtitle" ] [ text (String.fromInt model.partnerData.count ++ " found") ]
    , div [ class "box" ]
        (List.map partnerRenderer model.partnerData.partners)
    ]


viewShowPartner : Model -> List (Html Msg)
viewShowPartner model =
    case model.showPartner of
        Empty ->
            [ h1 [ class "title" ] [ text "showPartner is empty" ]
            ]

        Problem description ->
            [ h1 [ class "title" ] [ text "Problem loading partner" ]
            , p [ class "subtitle" ] [ text ("Description: " ++ description) ]
            ]

        Loaded partner ->
            [ h1 [ class "title" ] [ text partner.name ]
            , p [ class "subtitle" ]
                [ text ("Created " ++ partner.createdAt ++ " - Contact ") --  ++ partner.contactEmail)
                , a [ href ("mailto:" ++ partner.contactEmail) ] [ text partner.contactEmail ]
                ]
            , div [ class "content" ]
                [ p [] [ text partner.summary ]
                , h2 [ class "title" ] [ text "Description" ]
                , p [] [ text partner.description ]
                ]
            ]


viewForNotFound : Model -> List (Html Msg)
viewForNotFound _ =
    [ div [ class "content mb-6" ]
        [ h1 [ class "title is-1 mt-6" ] [ text "Page not found" ]
        , h2 [ class "title is-3 mt-6" ] [ text "The page you were looking for does not exist" ]
        ]
    ]


view : Model -> Browser.Document Msg
view model =
    { title = titleForPage model
    , body =
        [ div [ class "container mt-4" ]
            (case model.page of
                Root ->
                    viewForRoot model

                ShowPartner _ ->
                    viewShowPartner model

                NotFound ->
                    viewForNotFound model
            )
        , footer [ class "footer mt-4" ]
            [ div [ class "container" ] [ p [ class "content" ] [ text "Copyright (c) 2025 Me, INC." ] ]
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
