import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url.Parser exposing (Parser, (</>), int, map, oneOf, s, string, parse)
import Url


-- Routing


type Route
  = Index
  | Home
  | Profile
  | Reviews String
  | NotFound

routeParser : Parser (Route -> a) a
routeParser =
  oneOf
    [ map Home    (s "home")
    , map Profile (s "profile")
    , map Reviews (s "reviews" </> string)
    , map Index   (s "")
    ]

route2string: Route -> String
route2string route =
    case route of
        Index ->
            "Index"
        Home ->
            "Home"
        Profile ->
            "Profile"
        Reviews info ->
            "Reviews for" ++ info
        NotFound ->
            "NotFound"


-- MODEL


type alias Model =
  { key : Nav.Key
  , url : Url.Url
  , route : Route
  , data : { name : String }
  }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
  ( { key = key
    , url = url
    , route = Index
    , data = { name = "Kaito" }
    }, Cmd.none )


-- UPDATE


type Msg
  = LinkClicked Browser.UrlRequest
  | UrlChanged Url.Url
  | Move Route


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    LinkClicked urlRequest ->
      case urlRequest of
        Browser.Internal url ->
          ( model, Nav.pushUrl model.key (Url.toString url) )
        Browser.External href ->
          ( model, Nav.load href )

    UrlChanged url ->
        case (parse routeParser url) of
            Just route ->
                ( { model | url = url, route = route }, Cmd.none )
            Nothing ->
                ( { model | url = url, route = NotFound }, Cmd.none )

    Move route ->
      ( { model | route = route }
      , Cmd.none
      )

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    case model.route of
        Index ->
            viewPage model "Index" (div [] [ text "This is Index page!" ])
        Home ->
            viewPage model "Home" (div [] [ text "This is Home page!" ])
        Profile ->
            viewPage model "Profile" (div [] [ text "This is Profile page!" ])
        Reviews info ->
            viewPage model "Reviews" (div [] [ text "This is Reviews page!" ])
        NotFound ->
            { title = "NotFound"
            , body =
                [ p [] [ text "Page Not found ..." ]
                , p [] [ text (route2string model.route) ]
                ]
            }

viewPage: Model -> String -> Html Msg -> Browser.Document Msg
viewPage model title page =
    { title = title
    , body =
        [ viewHeader model
        , page
        ]
    }

viewHeader: Model -> Html Msg
viewHeader model =
    div []
        [ text "The current URL is: "
        , b [] [ text (Url.toString model.url) ]
        , ul []
            [ viewLink "/home"
            , viewLink "/profile"
            , viewLink "/reviews/the-century-of-the-self"
            , viewLink "/reviews/public-opinion"
            , viewLink "/reviews/shah-of-shahs"
            ]
        ]

viewLink : String -> Html msg
viewLink path =
  li [] [ a [ href path ] [ text path ] ]


-- MAIN


main : Program () Model Msg
main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }
