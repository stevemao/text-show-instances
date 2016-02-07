{-|
Module:      Spec.Data.UnorderedContainersSpec
Copyright:   (C) 2014-2016 Ryan Scott
License:     BSD-style (see the file LICENSE)
Maintainer:  Ryan Scott
Stability:   Provisional
Portability: GHC

@hspec@ tests for 'HashMap's and 'HashSet's.
-}
module Spec.Data.UnorderedContainersSpec (main, spec) where

import Data.HashMap.Lazy (HashMap)
import Data.HashSet (HashSet)

import Spec.Utils (prop_matchesTextShow)

import Test.Hspec (Spec, describe, hspec, parallel)
import Test.Hspec.QuickCheck (prop)
import Test.QuickCheck.Instances ()

import TextShow.Data.UnorderedContainers ()

main :: IO ()
main = hspec spec

spec :: Spec
spec = parallel $ do
    describe "HashMap Char Char" $
        prop "TextShow instance" (prop_matchesTextShow :: Int -> HashMap Char Char -> Bool)
    describe "HashSet Char" $
        prop "TextShow instance" (prop_matchesTextShow :: Int -> HashSet Char -> Bool)
