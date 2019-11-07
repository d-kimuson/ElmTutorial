import Browser
import Html exposing (Html, div, input, text, p)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

-- Model

type alias Model
    = { message: String }

init = { message = "" }

-- Update

type Msg
    = Change String

update: Msg -> Model -> Model
update msg model =
    case msg of
        Change new_message ->
            { model | message = new_message }

-- View

view: Model -> Html Msg
view model =
    div []
        [ input [ placeholder "Input Text Here", onInput Change ] []
        , p [] [ text model.message ]
        ]

main = Browser.sandbox
    { init = init
    , update = update
    , view = view
    }
