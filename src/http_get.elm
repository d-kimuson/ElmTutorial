import Browser
import Html exposing (Html, div, input, button, text, p)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (..)
import Http

-- Model

type Status
    = Init
    | Loading
    | Failed
    | Success

type alias Model =
    { mess: String
    , url: String
    , status: Status
    }

init: () -> (Model, Cmd Msg)
init _ =
    ( { mess = "", url = "", status = Init }
    , Cmd.none
    )

-- Update

type Msg
  = GET
  | URL String
  | GotText (Result Http.Error String)

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        GET ->
            ({model | status = Loading }, Http.get
                { url = model.url
                , expect = Http.expectString GotText
                }
            )
        URL url ->
            ({model | url = url, status = Init}, Cmd.none)
        GotText result ->
            case result of
                Ok fullText ->
                    ({ model | mess = fullText, status = Success }, Cmd.none)
                Err _ ->
                    ({ model | mess = "", status = Failed }, Cmd.none)



subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- View

view: Model -> Html Msg
view model =
    case model.status of
        Init ->
            div [] [ viewMain model ]
        Success ->
            div []
                [ p [] [ text "Success!" ]
                , viewMain model
                ]
        Failed ->
            div []
                [ p [] [ text "Failed ... " ]
                , viewMain model
                ]
        Loading ->
            div []
                [ p [] [ text "Now loading ..." ]
                ]

viewMain: Model -> Html Msg
viewMain model =
    div []
        [ viewInput "text" "Input your url" model.url URL
        , button [ onClick GET ] [ text "GET" ]
        , p [] [ text model.mess ]
        ]

viewInput: String -> String -> String -> (String -> msg) ->Html msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []

main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
