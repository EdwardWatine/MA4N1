import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Calculus.FDeriv.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.MeasureTheory.Integral.IntervalIntegral
import Mathlib.Analysis.Calculus.FDeriv.Basic
import Mathlib.Analysis.Normed.Field.Basic

namespace definitions

---Explicitly building maps (as f(x,y)+g(x,y)*i)

def complexMap (f g : ℝ × ℝ → ℝ) : ℂ → ℂ :=
λ z => Complex.mk (f (z.re, z.im)) (g (z.re, z.im) )

--- Defining Paths from its parametrization

def isPath (f g : ℝ → ℝ) : Prop :=
  ContinuousOn f (Set.Icc 0 1) ∧
  ContinuousOn g (Set.Icc 0 1)

def isClosedPath (f g : ℝ → ℝ ): Prop :=
 isPath f g  ∧ f 1 = f 0 ∧ g 1 = g 0
def isC1Path (f g : ℝ → ℝ ): Prop :=
 isPath f g  ∧ DifferentiableOn ℝ f (Set.Icc 0 1) ∧ DifferentiableOn ℝ g (Set.Icc 0 1)

--- Defining the lenght of a path (whether as before, with parametrizations, or as a \R \r \C map)

noncomputable def lengthOfPath (f g: ℝ → ℝ ) (h: isC1Path f g) : ℝ :=
 have aux : ℝ → ℝ := λ x => Real.sqrt ((deriv f x)^2 + (deriv g x)^2)
 ∫t in (Set.Icc 0 1), aux t

noncomputable def lengthOfPath1 (f : ℝ → ℂ) (h: DifferentiableOn ℝ f (Set.Icc 0 1) )  : ℝ :=
 have aux : ℝ → ℝ := λ x => Complex.abs (f x)
 ∫t in (Set.Icc 0 1), aux t

noncomputable def ComplexPath (f g : ℝ → ℝ): ℝ → ℂ := λ x => Complex.mk (f x) (g x)

noncomputable def DerivativePath (f g : ℝ → ℝ) (h: isC1Path f g) : ℝ → ℂ := ComplexPath (deriv f) (deriv g)

noncomputable def pathIntegral (f: ℂ → ℂ ) (α β : ℝ → ℝ ): ℂ  :=
have aux : ℝ → ℂ := λ t => ((Function.comp f  (ComplexPath α β)) t) * ((ComplexPath (deriv α) (deriv β)) t)
∫t in (Set.Icc 0 1), aux t

---The hypothesis of differentiability seem like the are not needed even if we define the derivative of the function (?)

---The noncomputable before some definitions is to avoid errors

end definitions

namespace definitions_usingPaths
noncomputable def aux (x y : ℂ ) (f : ℂ → ℂ) (γ : Path x y) : ℝ  → ℂ :=
 (Function.comp f (Path.extend γ)) * (deriv (Path.extend γ))
noncomputable def pathIntegral1 (x y : ℂ ) (f : ℂ → ℂ) (γ : Path x y) : ℂ := -- consider implicit
∫t in (Set.Icc 0 1), (aux x y f γ) t

lemma pathIntAdd (x y : ℂ ) (f g : ℂ → ℂ) (γ : Path x y) :
(pathIntegral1 x y f γ) + (pathIntegral1 x y g γ) = (pathIntegral1 x y (f+g) γ) := by
unfold pathIntegral1
unfold aux
simp only [Pi.mul_apply, Function.comp_apply,Pi.add_apply]
sorry

lemma pathAddInt (x y z : ℂ) (f : ℂ → ℂ) (γ : Path x y) (α : Path y z):
(pathIntegral1 x y f γ) + (pathIntegral1 y z f α) = (pathIntegral1 x z f (Path.trans γ α)) := by sorry

lemma pathIntSymm (f: ℂ → ℂ) (γ : Path x y) :
(pathIntegral1 y x f (Path.symm γ)) = -(pathIntegral1 x y f γ) := by sorry

end definitions_usingPaths
