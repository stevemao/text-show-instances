{-# LANGUAGE CPP             #-}
{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
{-|
Module:      Text.Show.Text.Data.Vector
Copyright:   (C) 2014-2015 Ryan Scott
License:     BSD-style (see the file LICENSE)
Maintainer:  Ryan Scott
Stability:   Provisional
Portability: GHC

Monomorphic 'Show' functions for @Vector@ types.

/Since: 0.1/
-}
module Text.Show.Text.Data.Vector (
      showbVectorPrec
    , showbVectorPrecWith
    , showbVectorGenericPrec
    , showbVectorGenericPrecWith
    , showbVectorPrimitivePrec
    , showbVectorStorablePrec
    , showbVectorUnboxedPrec
    , showbSizePrec
    ) where

import qualified Data.Vector as B (Vector)
import           Data.Vector.Fusion.Stream.Size (Size)
import qualified Data.Vector.Generic as G (Vector)
import           Data.Vector.Generic (toList)
import qualified Data.Vector.Primitive as P (Vector)
import           Data.Vector.Primitive (Prim)
import qualified Data.Vector.Storable as S (Vector)
import qualified Data.Vector.Unboxed as U (Vector)
import           Data.Vector.Unboxed (Unbox)

import           Foreign.Storable (Storable)

import           Prelude hiding (Show)

import           Text.Show.Text (Show(showbPrec), Show1(..), Builder)
import           Text.Show.Text.TH (deriveShow)
import           Text.Show.Text.Utils (showbUnaryList, showbUnaryListWith)

#include "inline.h"

-- | Convert a boxed 'B.Vector' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbVectorPrec :: Show a => Int -> B.Vector a -> Builder
showbVectorPrec = showbVectorGenericPrec
{-# INLINE showbVectorPrec #-}

-- | Convert a boxed 'B.Vector' to a 'Builder' with the given show function
-- and precedence.
--
-- /Since: 1/
showbVectorPrecWith :: (a -> Builder) -> Int -> B.Vector a -> Builder
showbVectorPrecWith = showbVectorGenericPrecWith
{-# INLINE showbVectorPrecWith #-}

-- | Convert a generic 'G.Vector' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbVectorGenericPrec :: (G.Vector v a, Show a) => Int -> v a -> Builder
showbVectorGenericPrec p = showbUnaryList p . toList
{-# INLINE showbVectorGenericPrec #-}

-- | Convert a generic 'G.Vector' to a 'Builder' with the given show function
-- and precedence.
--
-- /Since: 1/
showbVectorGenericPrecWith :: G.Vector v a => (a -> Builder) -> Int -> v a -> Builder
showbVectorGenericPrecWith sp p = showbUnaryListWith sp p . toList
{-# INLINE showbVectorGenericPrecWith #-}

-- | Convert a primitive 'P.Vector' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbVectorPrimitivePrec :: (Show a, Prim a) => Int -> P.Vector a -> Builder
showbVectorPrimitivePrec = showbVectorGenericPrec
{-# INLINE showbVectorPrimitivePrec #-}

-- | Convert a storable 'S.Vector' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbVectorStorablePrec :: (Show a, Storable a) => Int -> S.Vector a -> Builder
showbVectorStorablePrec = showbVectorGenericPrec
{-# INLINE showbVectorStorablePrec #-}

-- | Convert an unboxed 'U.Vector' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbVectorUnboxedPrec :: (Show a, Unbox a) => Int -> U.Vector a -> Builder
showbVectorUnboxedPrec = showbVectorGenericPrec
{-# INLINE showbVectorUnboxedPrec #-}

-- | Convert a 'Size' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbSizePrec :: Int -> Size -> Builder
showbSizePrec = showbPrec
{-# INLINE showbSizePrec #-}

instance Show a => Show (B.Vector a) where
    showbPrec = showbVectorPrec
    INLINE_INST_FUN(showbPrec)

instance Show1 B.Vector where
    showbPrecWith sp = showbVectorPrecWith $ sp 0
    INLINE_INST_FUN(showbPrecWith)

instance (Show a, Prim a) => Show (P.Vector a) where
    showbPrec = showbVectorPrimitivePrec
    INLINE_INST_FUN(showbPrec)

instance (Show a, Storable a) => Show (S.Vector a) where
    showbPrec = showbVectorStorablePrec
    INLINE_INST_FUN(showbPrec)

instance (Show a, Unbox a) => Show (U.Vector a) where
    showbPrec = showbVectorUnboxedPrec
    INLINE_INST_FUN(showbPrec)

$(deriveShow ''Size)
