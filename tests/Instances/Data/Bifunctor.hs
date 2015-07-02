{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE StandaloneDeriving         #-}
{-# LANGUAGE UndecidableInstances       #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

{-|
Module:      Instances.Data.Bifunctor
Copyright:   (C) 2014-2015 Ryan Scott
License:     BSD-style (see the file LICENSE)
Maintainer:  Ryan Scott
Stability:   Experimental
Portability: GHC

Provides an 'Arbitrary' instance for data types in the @bifunctors@ library.
-}
module Instances.Data.Bifunctor () where

import Data.Bifunctor.Biff (Biff(..))
import Data.Bifunctor.Clown (Clown(..))
import Data.Bifunctor.Flip (Flip(..))
import Data.Bifunctor.Join (Join(..))
import Data.Bifunctor.Joker (Joker(..))
import Data.Bifunctor.Product (Product(..))
import Data.Bifunctor.Tannen (Tannen(..))
import Data.Bifunctor.Wrapped (WrappedBifunctor(..))

import Prelude ()
import Prelude.Compat

import Test.QuickCheck (Arbitrary(..))

deriving instance Arbitrary (p (f a) (g b)) => Arbitrary (Biff p f g a b)
deriving instance Arbitrary (f a)           => Arbitrary (Clown f a b)
deriving instance Arbitrary (p b a)         => Arbitrary (Flip p a b)
deriving instance Arbitrary (p a a)         => Arbitrary (Join p a)
deriving instance Arbitrary (g b)           => Arbitrary (Joker g a b)
deriving instance Arbitrary (f (p a b))     => Arbitrary (Tannen f p a b)
deriving instance Arbitrary (p a b)         => Arbitrary (WrappedBifunctor p a b)

instance (Arbitrary (f a b), Arbitrary (g a b)) => Arbitrary (Product f g a b) where
    arbitrary = Pair <$> arbitrary <*> arbitrary
