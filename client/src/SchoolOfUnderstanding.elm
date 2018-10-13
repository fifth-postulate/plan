module SchoolOfUnderstanding exposing
    ( Dict
    , empty, insert
    , foldr
    )

{-| The module defines various functionalities that model the planning problem of the [School of Understanding](https://www.schoolofunderstanding.nl/).


# Types

@docs Dict


# Building

@docs empty, insert


# Transform

@docs foldr

-}

import Dict.Any as AnyDict exposing (AnyDict)


{-| A convenience type of dictionary.
-}
type alias Dict k v =
    AnyDict Int k v


{-| Create an empty dictionary.
-}
empty : (k -> Int) -> Dict k v
empty converter =
    AnyDict.empty converter


{-| Associate a key with a value into a `Dict`
-}
insert : k -> v -> Dict k v -> Dict k v
insert key value dict =
    dict
        |> AnyDict.insert key value


{-| Foldr over the keys of a `Dict`.
-}
foldr : (k -> v -> b -> b) -> b -> Dict k v -> b
foldr f accumulator dictionary =
    AnyDict.foldr f accumulator dictionary
