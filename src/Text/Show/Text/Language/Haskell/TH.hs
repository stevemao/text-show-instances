{-# LANGUAGE CPP                  #-}
{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE TypeSynonymInstances #-}
#if !(MIN_VERSION_template_haskell(2,10,0))
{-# LANGUAGE MagicHash            #-}
#endif
{-# OPTIONS_GHC -fno-warn-orphans #-}
{-|
Module:      Text.Show.Text.Language.Haskell.TH
Copyright:   (C) 2014-2015 Ryan Scott
License:     BSD-style (see the file LICENSE)
Maintainer:  Ryan Scott
Stability:   Provisional
Portability: GHC

Monomorphic 'Show' functions for data types in the @template-haskell@ library.

/Since: 0.1/
-}
module Text.Show.Text.Language.Haskell.TH (
#if MIN_VERSION_template_haskell(2,9,0)
      showbAnnLookupPrec
    , showbAnnTargetPrec,
#endif
      showbBodyPrec
    , showbCallconv
#if MIN_VERSION_template_haskell(2,5,0) && !(MIN_VERSION_template_haskell(2,7,0))
    , showbClassInstancePrec
#endif
    , showbClausePrec
    , showbConPrec
    , showbDecPrec
    , showbExpPrec
    , showbFamFlavour
    , showbFixityPrec
    , showbFixityDirection
    , showbForeignPrec
    , showbFunDepPrec
    , showbGuardPrec
    , showbInfoPrec
#if MIN_VERSION_template_haskell(2,8,0)
    , showbInline
#else
    , showbInlineSpecPrec
#endif
    , showbKindPrec
    , showbLitPrec
    , showbLocPrec
    , showbMatchPrec
    , showbModNamePrec
#if MIN_VERSION_template_haskell(2,9,0)
    , showbModulePrec
    , showbModuleInfoPrec
#endif
    , showbName
    , showbName'
    , showbOccNamePrec
    , showbPatPrec
#if MIN_VERSION_template_haskell(2,8,0)
    , showbPhasesPrec
#endif
    , showbPkgNamePrec
    , showbPragmaPrec
    , showbPredPrec
    , showbRangePrec
#if MIN_VERSION_template_haskell(2,9,0)
    , showbRole
#endif
#if MIN_VERSION_template_haskell(2,8,0)
    , showbRuleBndrPrec
    , showbRuleMatch
#endif
    , showbSafety
    , showbStmtPrec
    , showbStrict
#if MIN_VERSION_template_haskell(2,8,0)
    , showbTyLitPrec
#endif
    , showbTypePrec
    , showbTyVarBndrPrec
#if MIN_VERSION_template_haskell(2,9,0)
    , showbTySynEqnPrec
#endif
    , showbDoc
    ) where

import           Data.Char (isAlpha)
import           Data.Maybe (fromJust)
import           Data.Monoid.Compat
import qualified Data.Text.Lazy as TL (Text, dropWhile, null, tail)
import           Data.Text.Lazy (uncons)

#if !(MIN_VERSION_template_haskell(2,10,0))
import           GHC.Exts (Int(I#))
#endif

import           Language.Haskell.TH.PprLib (Doc, to_HPJ_Doc)
import           Language.Haskell.TH.Syntax

import           Prelude hiding (Show)

import           Text.Show.Text (Show(showb, showbPrec), Builder,
                                 fromString, singleton, toLazyText)
import           Text.Show.Text.Data.Integral (showbIntPrec)
import           Text.Show.Text.Text.PrettyPrint (renderB)
import           Text.Show.Text.TH (deriveShow)

-- | Convert a 'Body' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbBodyPrec :: Int -> Body -> Builder
showbBodyPrec = showbPrec

-- | Convert a 'Callconv' to a 'Builder'.
--
-- /Since: 0.1/
showbCallconv :: Callconv -> Builder
showbCallconv = showb

-- | Convert a 'Clause' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbClausePrec :: Int -> Clause -> Builder
showbClausePrec = showbPrec

-- | Convert a 'Con' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbConPrec :: Int -> Con -> Builder
showbConPrec = showbPrec

-- | Convert a 'Dec' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbDecPrec :: Int -> Dec -> Builder
showbDecPrec = showbPrec

-- | Convert an 'Exp' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbExpPrec :: Int -> Exp -> Builder
showbExpPrec = showbPrec

-- | Convert a 'FamFlavour' to a 'Builder'.
--
-- /Since: 0.1/
showbFamFlavour :: FamFlavour -> Builder
showbFamFlavour = showb

-- | Convert a 'Fixity' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbFixityPrec :: Int -> Fixity -> Builder
showbFixityPrec = showbPrec

-- | Convert a 'FixityDirection' to a 'Builder'.
--
-- /Since: 0.1/
showbFixityDirection :: FixityDirection -> Builder
showbFixityDirection = showb

-- | Convert a 'Foreign' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbForeignPrec :: Int -> Foreign -> Builder
showbForeignPrec = showbPrec

-- | Convert a 'FunDep' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbFunDepPrec :: Int -> FunDep -> Builder
showbFunDepPrec = showbPrec

-- | Convert a 'Guard' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbGuardPrec :: Int -> Guard -> Builder
showbGuardPrec = showbPrec

-- | Convert an 'Info' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbInfoPrec :: Int -> Info -> Builder
showbInfoPrec = showbPrec

-- | Convert a 'Kind' to a 'Builder' with the given precedence.
--
-- /Since: 0.2/
showbKindPrec :: Int -> Kind -> Builder
#if MIN_VERSION_template_haskell(2,8,0)
showbKindPrec = showbTypePrec
#else
showbKindPrec = showbPrec
#endif

-- | Convert a 'Lit' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbLitPrec :: Int -> Dec -> Builder
showbLitPrec = showbPrec

-- | Convert a 'Loc' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbLocPrec :: Int -> Loc -> Builder
showbLocPrec = showbPrec

-- | Convert a 'Match' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbMatchPrec :: Int -> Match -> Builder
showbMatchPrec = showbPrec

-- | Convert a 'ModName' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbModNamePrec :: Int -> ModName -> Builder
showbModNamePrec = showbPrec

-- | Convert a 'Name' to a 'Builder'.
--
-- /Since: 0.1/
showbName :: Name -> Builder
showbName = showbName' Alone

-- | Convert a 'Name' to a 'Builder' with the given 'NameIs' settings.
--
-- /Since: 0.1/
showbName' :: NameIs -> Name -> Builder
showbName' ni nm = case ni of
    Alone           -> nms
    Applied
        | pnam      -> nms
        | otherwise -> singleton '(' <> nms <> singleton ')'
    Infix
        | pnam      -> singleton '`' <> nms <> singleton '`'
        | otherwise -> nms
  where
    -- For now, we make the NameQ and NameG print the same, even though
    -- NameQ is a qualified name (so what it means depends on what the
    -- current scope is), and NameG is an original name (so its meaning
    -- should be independent of what's in scope.
    -- We may well want to distinguish them in the end.
    -- Ditto NameU and NameL
    nms :: Builder
    nms = case nm of
               Name occ NameS         -> occB occ
               Name occ (NameQ m)     -> modB m   <> singleton '.' <> occB occ
               Name occ (NameG _ _ m) -> modB m   <> singleton '.' <> occB occ
               Name occ (NameU u)     -> occB occ <> singleton '_' <> showbIntPrec 0 (mkInt u)
               Name occ (NameL u)     -> occB occ <> singleton '_' <> showbIntPrec 0 (mkInt u)

#if MIN_VERSION_template_haskell(2,10,0)
    mkInt = id
#else
    mkInt i# = I# i#
#endif

    occB :: OccName -> Builder
    occB = fromString . occString

    modB :: ModName -> Builder
    modB = fromString . modString

    pnam :: Bool
    pnam = classify $ toLazyText nms

    -- True if we are function style, e.g. f, [], (,)
    -- False if we are operator style, e.g. +, :+
    classify :: TL.Text -> Bool
    classify t
        | TL.null t  = False -- shouldn't happen; . operator is handled below
        | otherwise = case fromJust $ uncons t of
              (x, xs) -> if isAlpha x || (x `elem` "_[]()")
                            then let t' = TL.dropWhile (/= '.') xs
                                 in if TL.null t'
                                       then True
                                       else classify $ TL.tail t'
                            else False


-- | Convert an 'OccName' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbOccNamePrec :: Int -> OccName -> Builder
showbOccNamePrec = showbPrec

-- | Convert a 'Pat' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbPatPrec :: Int -> Pat -> Builder
showbPatPrec = showbPrec

-- | Convert a 'PkgName' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbPkgNamePrec :: Int -> PkgName -> Builder
showbPkgNamePrec = showbPrec

-- | Convert a 'Pragma' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbPragmaPrec :: Int -> Pragma -> Builder
showbPragmaPrec = showbPrec

-- | Convert a 'Pred' to a 'Builder' with the given precedence.
--
-- /Since: 0.2/
showbPredPrec :: Int -> Pred -> Builder
#if MIN_VERSION_template_haskell(2,10,0)
showbPredPrec = showbTypePrec
#else
showbPredPrec = showbPrec
#endif

-- | Convert a 'Range' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbRangePrec :: Int -> Range -> Builder
showbRangePrec = showbPrec

-- | Convert a 'Safety' to a 'Builder'.
--
-- /Since: 0.1/
showbSafety :: Safety -> Builder
showbSafety = showb

-- | Convert a 'Stmt' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbStmtPrec :: Int -> Stmt -> Builder
showbStmtPrec = showbPrec

-- | Convert a 'Strict' to a 'Builder'.
--
-- /Since: 0.1/
showbStrict :: Strict -> Builder
showbStrict = showb

-- | Convert a 'Type' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbTypePrec :: Int -> Type -> Builder
showbTypePrec = showbPrec

-- | Convert a 'TyVarBndr' to a 'Builder' with the given precedence.
--
-- /Since: 0.1/
showbTyVarBndrPrec :: Int -> TyVarBndr -> Builder
showbTyVarBndrPrec = showbPrec

-- | Convert a 'Doc' to a 'Builder'.
--
-- /Since: 0.3/
showbDoc :: Doc -> Builder
showbDoc = renderB . to_HPJ_Doc

#if MIN_VERSION_template_haskell(2,5,0) && !(MIN_VERSION_template_haskell(2,7,0))
-- | Convert a 'ClassInstance' to a 'Builder' with the given precedence.
-- This function is only available with @template-haskell@ 2.5.0.0 or 2.6.0.0.
--
-- /Since: 0.1/
showbClassInstancePrec :: Int -> ClassInstance -> Builder
showbClassInstancePrec = showbPrec
#endif

#if MIN_VERSION_template_haskell(2,8,0)
-- | Convert an 'Inline' to a 'Builder'.
-- This function is only available with @template-haskell-2.8.0.0@ or later.
--
-- /Since: 0.1/
showbInline :: Inline -> Builder
showbInline = showb

-- | Convert a 'Phases' to a 'Builder' with the given precedence.
-- This function is only available with @template-haskell-2.8.0.0@ or later.
--
-- /Since: 0.1/
showbPhasesPrec :: Int -> Phases -> Builder
showbPhasesPrec = showbPrec

-- | Convert a 'RuleMatch' to a 'Builder'.
-- This function is only available with @template-haskell-2.8.0.0@ or later.
--
-- /Since: 0.1/
showbRuleMatch :: RuleMatch -> Builder
showbRuleMatch = showb

-- | Convert a 'RuleBndr' to a 'Builder' with the given precedence.
-- This function is only available with @template-haskell-2.8.0.0@ or later.
--
-- /Since: 0.1/
showbRuleBndrPrec :: Int -> RuleBndr -> Builder
showbRuleBndrPrec = showbPrec

-- | Convert a 'TyLit' to a 'Builder' with the given precedence.
-- This function is only available with @template-haskell-2.8.0.0@ or later.
--
-- /Since: 0.1/
showbTyLitPrec :: Int -> TyLit -> Builder
showbTyLitPrec = showbPrec
#else
-- | Convert an 'InlineSpec' to a 'Builder' with the given precedence.
-- This function is only available with @template-haskell-2.7.0.0@ or earlier.
--
-- /Since: 0.1/
showbInlineSpecPrec :: Int -> InlineSpec -> Builder
showbInlineSpecPrec = showbPrec
#endif

#if MIN_VERSION_template_haskell(2,9,0)
-- | Convert an 'AnnLookup' to a 'Builder' with the given precedence.
-- This function is only available with @template-haskell-2.9.0.0@ or later.
--
-- /Since: 0.1/
showbAnnLookupPrec :: Int -> AnnLookup -> Builder
showbAnnLookupPrec = showbPrec

-- | Convert an 'AnnTarget' to a 'Builder' with the given precedence.
-- This function is only available with @template-haskell-2.9.0.0@ or later.
--
-- /Since: 0.1/
showbAnnTargetPrec :: Int -> AnnTarget -> Builder
showbAnnTargetPrec = showbPrec

-- | Convert a 'Module' to a 'Builder' with the given precedence.
-- This function is only available with @template-haskell-2.9.0.0@ or later.
--
-- /Since: 0.1/
showbModulePrec :: Int -> Module -> Builder
showbModulePrec = showbPrec

-- | Convert a 'ModuleInfo' to a 'Builder' with the given precedence.
-- This function is only available with @template-haskell-2.9.0.0@ or later.
--
-- /Since: 0.1/
showbModuleInfoPrec :: Int -> ModuleInfo -> Builder
showbModuleInfoPrec = showbPrec

-- | Convert a 'Role' to a 'Builder'.
-- This function is only available with @template-haskell-2.9.0.0@ or later.
--
-- /Since: 0.1/
showbRole :: Role -> Builder
showbRole = showb

-- | Convert a 'TySynEqn' to a 'Builder' with the given precedence.
-- This function is only available with @template-haskell-2.9.0.0@ or later.
--
-- /Since: 0.1/
showbTySynEqnPrec :: Int -> TySynEqn -> Builder
showbTySynEqnPrec = showbPrec
#endif

$(deriveShow ''Body)
$(deriveShow ''Callconv)
$(deriveShow ''Clause)
$(deriveShow ''Con)
$(deriveShow ''Dec)
$(deriveShow ''Exp)
$(deriveShow ''FamFlavour)
$(deriveShow ''Fixity)
$(deriveShow ''FixityDirection)
$(deriveShow ''Foreign)
$(deriveShow ''FunDep)
$(deriveShow ''Guard)
$(deriveShow ''Info)
$(deriveShow ''Lit)
$(deriveShow ''Loc)
$(deriveShow ''Match)
$(deriveShow ''ModName)

instance Show Name where
    showb = showbName

$(deriveShow ''OccName)
$(deriveShow ''Pat)
$(deriveShow ''PkgName)
$(deriveShow ''Pragma)
$(deriveShow ''Range)
$(deriveShow ''Safety)
$(deriveShow ''Stmt)
$(deriveShow ''Strict)
$(deriveShow ''Type)
$(deriveShow ''TyVarBndr)

instance Show Doc where
    showb = showbDoc

#if MIN_VERSION_template_haskell(2,5,0) && !(MIN_VERSION_template_haskell(2,7,0))
$(deriveShow ''ClassInstance)
#endif

#if MIN_VERSION_template_haskell(2,8,0)
$(deriveShow ''Inline)
$(deriveShow ''Phases)
$(deriveShow ''RuleBndr)
$(deriveShow ''RuleMatch)
$(deriveShow ''TyLit)
#else
$(deriveShow ''InlineSpec)
$(deriveShow ''Kind)
#endif

#if MIN_VERSION_template_haskell(2,9,0)
$(deriveShow ''AnnLookup)
$(deriveShow ''AnnTarget)
$(deriveShow ''Module)
$(deriveShow ''ModuleInfo)
$(deriveShow ''Role)
$(deriveShow ''TySynEqn)
#endif

#if !(MIN_VERSION_template_haskell(2,10,0))
$(deriveShow ''Pred)
#endif
