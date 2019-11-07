import Browser
import Html exposing (Html, div, button, text, p)
import Html.Events exposing (onClick)

-- Model

type Page
    = Loading
    | NotFound
    | Index
    | About

type alias Model =
    { data: { name: String }
    , page: Page
    }

init = { data = { name = "Kaito" }, page = About }

-- Update

type Msg
    = GoIndex
    | GoAbout

update: Msg -> Model -> Model
update msg model =
    case msg of
        GoIndex ->
            { model | page = Index }
        GoAbout ->
            { model | page = About }

-- View

view: Model -> Html Msg
view model =
    case model.page of
        Index ->
            div []
                [ div [] viewNav
                , p [] [ text "Index Page" ]
                , p [] [ text ("Hello " ++ model.data.name ++ "!") ]
                ]
        About ->
            div []
                [ div [] viewNav
                , p [] [ text "About Page" ]
                , p [] [ text ("Hello " ++ model.data.name ++ "!") ]
                ]
        Loading ->
            div []
                [ p [] [ text "Loading Now ..." ]
                ]
        NotFound ->
            div []
                [ div [] viewNav
                , p [] [ text "404 Not Found" ]
                ]

viewNav =
    [ button [ onClick GoIndex ] [ text "Index" ]
    , button [ onClick GoAbout ] [ text "About" ]
    ]
-- main

main = Browser.sandbox
    { init = init
    , update = update
    , view = view
    }
