module Page.About exposing (..)

import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Session exposing (Session)


type alias Model =
    { session : Session, readMore : Bool }


type Msg
    = ReadMore


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session, readMore = False }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReadMore ->
            ( { model | readMore = not model.readMore }, Cmd.none )


view : Model -> { title : String, content : List (Html Msg) }
view model =
    { title = "About"
    , content =
        [ div []
            [ h1 []
                [ text "About" ]
            , div []
                [ div []
                    [ text "Who am I?" ]
                , div [ onClick ReadMore, style "cursor" "pointer" ]
                    [ text "Click here to read more" ]
                ]
            , if model.readMore then
                div []
                    [ text "I am a professional full stack developer and senior software architect. If you are reading this, well you know where to find me and my projects." ]

              else
                div []
                    []
            ]
        ]
    }
