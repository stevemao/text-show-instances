{-|
Module:      Spec.Data.BinarySpec
Copyright:   (C) 2014-2016 Ryan Scott
License:     BSD-style (see the file LICENSE)
Maintainer:  Ryan Scott
Stability:   Provisional
Portability: GHC

@hspec@ tests for 'Decoder's.
-}
module Spec.Data.BinarySpec (main, spec) where

import Data.Binary.Get.Internal (Decoder)

import Instances.Data.Binary ()

import Spec.Utils (prop_matchesTextShow)

import Test.Hspec (Spec, describe, hspec, parallel)
import Test.Hspec.QuickCheck (prop)

import TextShow.Data.Binary ()

main :: IO ()
main = hspec spec

spec :: Spec
spec = parallel . describe "Decoder Int" $
    prop "TextShow instance" (prop_matchesTextShow :: Int -> Decoder Int -> Bool)
