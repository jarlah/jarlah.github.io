module Page.Search exposing (..)

import Html exposing (Html, button, div, h1, input, text)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decoder exposing (Decoder)
import Result as Http
import Session exposing (Session)


type alias Post =
    { userId : Int
    , id : Int
    , title : String
    , body : String
    }


type alias Model =
    { session : Session, term : String, posts : List Post, loading : Bool, error : String }


type Msg
    = ExecuteSearch
    | SearchResultsReceived (Http.Result Http.Error (List Post))
    | SetTerm String


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session, term = "", posts = [], loading = False, error = "" }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ExecuteSearch ->
            -- Return your search command here
            ( { model | loading = True, posts = [], error = "" }
            , Http.get
                { url = "https://jsonplaceholder.typicode.com/posts"
                , expect = Http.expectJson SearchResultsReceived (Decoder.list postDecoder)
                }
            )

        SearchResultsReceived result ->
            case result of
                Ok list ->
                    ( { model
                        | posts =
                            List.filter
                                (\post ->
                                    String.contains model.term post.title
                                        || String.contains model.term post.body
                                )
                                list
                        , loading = False
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( { model | loading = False, error = "Failed while searching jsonplaceholder api" }, Cmd.none )

        SetTerm term ->
            ( { model | term = term }, Cmd.none )


postDecoder : Decoder Post
postDecoder =
    Decoder.map4 Post
        (Decoder.field "userId" Decoder.int)
        (Decoder.field "id" Decoder.int)
        (Decoder.field "title" Decoder.string)
        (Decoder.field "body" Decoder.string)


view : Model -> { title : String, content : List (Html Msg) }
view model =
    { title = "Search"
    , content =
        [ div []
            [ h1 [] [ text "Search for posts on jsonplaceholder" ]
            , div []
                [ input [ onInput SetTerm ] []
                , button [ onClick ExecuteSearch ] [ text "Search now" ]
                ]
            , div [] [ text model.error ]
            ]
        ]
    }
