{-# LANGUAGE CPP #-}
{-|
Module:      Spec.System.DirectorySpec
Copyright:   (C) 2014-2016 Ryan Scott
License:     BSD-style (see the file LICENSE)
Maintainer:  Ryan Scott
Stability:   Provisional
Portability: GHC

@hspec@ tests for 'Permissions'.
-}
module Spec.System.DirectorySpec (main, spec) where

import Prelude ()
import Prelude.Compat

import Test.Hspec (Spec, hspec, parallel)

#if MIN_VERSION_directory(1,1,0)
import Instances.System.Directory ()

import Spec.Utils (prop_matchesTextShow)

import System.Directory (Permissions)

import Test.Hspec (describe)
import Test.Hspec.QuickCheck (prop)

import TextShow.System.Directory ()
#endif

main :: IO ()
main = hspec spec

spec :: Spec
spec = parallel $
#if MIN_VERSION_directory(1,1,0)
    describe "Permissions" $
        prop "TextShow instance" (prop_matchesTextShow :: Int -> Permissions -> Bool)
#else
    pure ()
#endif
