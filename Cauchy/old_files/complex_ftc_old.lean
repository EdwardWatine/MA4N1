import Cauchy.definitions.triangle
import Mathlib.Data.Complex.Basic
import Mathlib.Algebra.Field.Defs
import Mathlib.Tactic
import Cauchy.lemmas.triangle_inequality
import Cauchy.lemmas.complex_real_norm_equiv
import Cauchy.lemmas.path_integral_integrable
import Cauchy.theorems.integral_restriction
import Mathlib.Topology.Connected.PathConnected
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Calculus.FDeriv.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.MeasureTheory.Integral.IntervalIntegral
import Mathlib.Analysis.Normed.Field.Basic
import Mathlib.MeasureTheory.Integral.Bochner
import Mathlib.MeasureTheory.Integral.FundThmCalculus
import Mathlib.Analysis.Calculus.Deriv.Comp
import Mathlib.Data.Set.Intervals.UnorderedInterval
import Mathlib.MeasureTheory.Integral.SetIntegral

-- This file is where the Fundamental Theorem of Calculus was going to be proved
-- prior to the change from Paths to C1Paths


open definitions lemmas theorems

open Set
open Nat Real MeasureTheory Set Filter Function intervalIntegral Interval unitInterval

lemma aux3 {f : ℂ → ℂ} {γ : C1Path}
   (hf : DifferentiableAt ℝ (f ∘ γ) x) :
    DifferentiableAt ℂ f (γ x) := by
  sorry

lemma complex_ftc1 {f : ℂ → ℂ} (γ : C1Path)
    (hf_deriv : ∀ x ∈ (Set.uIcc 0 1), DifferentiableAt ℝ (f ∘ γ) x)
    (hγ_deriv : ∀ x ∈ (Set.uIcc 0 1), DifferentiableAt ℝ γ x)
    (h_int : IntervalIntegrable (deriv (f ∘ γ)) volume 0 1) :
    pathIntegral1' (deriv f) γ = f (γ 1) - f (γ 0) := by
  have : ∀ y ∈ (Set.uIcc 0 1), deriv f (γ y) * deriv γ y = deriv (f ∘ γ) y := by
    intro y hy
    rw [deriv.comp]
    · exact aux3 (hf_deriv y hy)
    · exact hγ_deriv y hy
  unfold pathIntegral1'
  unfold aux
  simp
  rw [integral_congr this, integral_deriv_eq_sub hf_deriv h_int]
  trivial

  lemma aux2 {z w : ℂ} {f : ℂ → ℂ} {γ : Path z w} (hf : DifferentiableAt ℝ (f ∘ (Path.extend γ)) x) :
           DifferentiableAt ℂ f ((Path.extend γ) x) := by
  sorry

--lemma complex_ftc2 (z w : ℂ) (f : ℂ → ℂ) (γ : Path z w)
  --   (hf_deriv : ∀ x ∈ (Set.uIcc 0 1), DifferentiableAt ℝ (f ∘ (Path.extend γ)) x)
    -- (hγ_deriv : ∀ x ∈ (Set.uIcc 0 1), DifferentiableAt ℝ (Path.extend γ) x)
     --(h_int : IntervalIntegrable (deriv (f ∘ (Path.extend γ))) volume 0 1) :
     --pathIntegral1 (deriv f) γ = (f ∘ (Path.extend γ)) 1 - (f ∘ (Path.extend γ)) 0 := by
     --unfold pathIntegral1
     --unfold aux
     --have : ∀ y ∈ (Set.uIcc 0 1),(deriv f ∘ Path.extend γ * deriv (Path.extend γ)) y = deriv (f ∘ (Path.extend γ)) y := by
       --intro y hy
       --rw [deriv.comp]
       --simp
       --· exact aux2 (hf_deriv y hy)
       --· exact hγ_deriv y hy
     --rw [integral_congr this, integral_deriv_eq_sub hf_deriv h_int]
     --sorry
