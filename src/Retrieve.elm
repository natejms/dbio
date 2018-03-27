port module Retrieve exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Json.Decode exposing (..)
import Navigation exposing (load)
import Result exposing (withDefault)
import Html.Attributes.Extra exposing (innerHtml)


main =
    Html.program
      { view = view
      , update = update
      , init = init
      , subscriptions = subscriptions
      }


-- MODEL

type alias Model =
  { name         : String
  , location     : String
  , image        : String
  , work         : String
  , education    : String
  , bio : String
  }

init : (Model, Cmd Msg)
init =
  ( { name         = ""
    , location     = ""
    , image        = ""
    , work         = ""
    , education    = ""
    , bio          = ""
    }
  , Cmd.none
  )


-- VIEW

ipfsGateway : String
ipfsGateway = "https://ipfs.io/ipfs/"

view : Model -> Html Msg
view model =
    div [ class "row" ]
      [ div [ class "image col-md-8 col-sm-8" ]
          [ img [ src (ipfsGateway ++ model.image) ] []
          ]
      , div [ class "content col-md-4 col-sm-4"]
          [ h1 [] [ text model.name ]
          , p [ class "subheader" ] [ text model.location ]
          , p [ innerHtml model.bio ] []
          , div [ class "container-fluid" ]
              [ div [ class "row" ]
                  [ div [ class "col-md-6 col-sm-6" ]
                      [ h3 [] [ text "Work" ]
                      , p [] [ text model.work ]
                      ]
                  , div [ class "col-md-6 col-sm-6" ]
                      [ h3 [] [ text "Education" ]
                      , p [] [ text model.education ]
                      ]
                  ]
              ]
          ]
      ]


-- UPDATE

type Msg
    = Retrieved String
    | Error

update : Msg -> Model -> (Model, Cmd msg)
update msg model =
  case msg of
    Retrieved json ->
      ( { name =
            decodeString (field "name" string) json
              |> withDefault "Somebody"
        , location =
            decodeString (field "location" string) json
             |> withDefault "Somewhere"
        , image =
            decodeString (field "image" string) json
              |> withDefault "QmSVUVwKHMgBxy98N3vKkB6RQ4Umxd2mFd4uoMLpmqYKLW"
        , work =
            decodeString (field "work" string) json
              |> withDefault "A job"
        , education =
            decodeString (field "education" string) json
              |> withDefault "Some school"
        , bio =
            decodeString (field "bio" string) json
              |> withDefault "Nothing to show..."
        }
      , Cmd.none
      )
    Error ->
    (model, load "../index.html")


-- SUBSCRIPTIONS


port receive_bio : (String -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
    receive_bio Retrieved
