import Mathlib.Tactic
import Mathlib.CategoryTheory.Limits.Shapes.IsTerminal

set_option autoImplicit false

-- section Initial
-- open CategoryTheory

-- universe u'
-- universe v'
-- variable {C : Type u'} [Category.{v'} C]

-- class InitialObject (X : C) : Prop where
--   unique_morphism : ∀ (Y : C), ∃ (f : X ⟶ Y), ∀ (g : X ⟶ Y), f = g

-- end Initial


namespace CategoryTheory

universe u v

variable {C : Type u} [Category.{v} C]

structure FAlgebra (F : C ⥤ C) where
  /-- carrier -/
  carrier : C
  /-- the arrow -/
  mor : F.obj carrier ⟶ carrier

namespace FAlgebra

local notation:80 g " ⊚ " f:80 => f ≫ g    -- type as \oo


variable {F : C ⥤ C} -- (A : FAlgebra F){B C : FAlgebra F}

/-- Define that all F-Algebra form a category.
This include components:
* homomorphisms: `h : (A, α) ⟶ (B, β)` is essentially an arrow `h : A ⟶ B`
  such that `h ∘ α = β ∘ F (h)`
* identities: identity arrows

```
         F h
   F A -----> F B
    |         |
  α |         | β
    V         V
    A  -----> B
        h
```
-/

@[ext]
structure AlgebraHom (A B : FAlgebra F) where
  -- mathching carrier
  h : A.carrier ⟶ B.carrier
  --
  condition : h ⊚ A.mor = B.mor ⊚ (F.map h)

variable (A : FAlgebra F){A' B' C': FAlgebra F}


namespace AlgebraHom

def id : AlgebraHom A A where
  h := 𝟙 _
  condition := by
    aesop

def comp (m1: AlgebraHom A' B') (m2: AlgebraHom B' C') : AlgebraHom A' C' where
  h := m2.h ⊚ m1.h
  condition := by
    simp [Functor.map_comp]
    rw [← m2.condition]
    simp [← Category.assoc]
    rw [m1.condition]

def equiv_hom (m1: AlgebraHom A' B') (m2: AlgebraHom A' B') : Prop
  := (m1.h = m2.h) → m1 = m2

end AlgebraHom

instance (F : C ⥤ C) : CategoryStruct (FAlgebra F) where
  Hom := AlgebraHom
  id := AlgebraHom.id -- (X : FAlgebra F) → X ⟶ X
  comp := @AlgebraHom.comp _ _ _ -- {X Y Z : FAlgebra F} → (X ⟶ Y) → (Y ⟶ Z) → (X ⟶ Z)
--

@[ext]
lemma ext {A B : FAlgebra F} {f g : A ⟶ B} (w : f.h = g.h) : f = g :=
  AlgebraHom.ext w

theorem comp_distr {f : B' ⟶ C'}{g : A' ⟶ B'} : (f ⊚ g).h = f.h ⊚ g.h := by
  rfl

theorem id_distr {A : FAlgebra F}: (𝟙 _ : A ⟶ A).h = 𝟙 A.carrier := by
  rfl


instance (F : C ⥤ C) : Category (FAlgebra F) := {
  --  ∀ {X Y : obj} (f : X ⟶ Y), 𝟙 X ≫ f = f
  id_comp := by
    intros X Y f
    ext
    rw [comp_distr, id_distr, Category.id_comp]
  -- ∀ {X Y : obj} (f : X ⟶ Y), f ≫ 𝟙 Y = f
  comp_id := by
    intros X Y f
    ext
    rw [comp_distr, id_distr, Category.comp_id]
  -- Composition in a category is associative.
  assoc := by
    intros W X Y Z f g h
    ext
    simp [comp_distr]
}


namespace Initial
  variable {T} (h : @Limits.IsInitial (FAlgebra F) _ T)
end Initial

-- theorem hom_isIso ()

/--
Given any endofunctor F : C → C on an arbitrary category C,
if i : F(I) → I is an initial F-algebra,
then i is an isomorphism.

isomorphism:IsIso

CategoryTheory.IsIso

given: F : C ==> C
given: i : IsInitial I in (Category of F-Algebra)
to show: IsIso i in (Category of F-Algebra)

-/


def placeholder : Prop := sorry



end FAlgebra

end CategoryTheory
