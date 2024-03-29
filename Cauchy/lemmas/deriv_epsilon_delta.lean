import Mathlib.Analysis.Analytic.Basic
import Mathlib.Topology.Basic
import Mathlib.Topology.Connected.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Complex.ReImTopology
import Mathlib.Data.Complex.Basic
import Mathlib.Analysis.Calculus.FDeriv.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Topology.MetricSpace.PseudoMetric

namespace lemmas

open Metric

-- In this file we show the caracterization of differentiability of a function
-- using ε δ. From the ε,δ definition of the limit (f (w) - f(z)) /(w-z) → f'(w) as w → z

--We want to get that ∀ε>0, ∃δ such that ‖w-z‖ < δ implies ‖f(w) - f(z) - (w-z) * (f'(z))‖ ≤ ε * ‖w-z‖

lemma deriv_epsilon_delta {z : ℂ} {f : ℂ → ℂ} (hf : DifferentiableAt ℂ f z) :
  ∀ε>0, ∃δ>0, ∀w : ℂ, ‖w-z‖ < δ → ‖f w - f z - (w-z) * deriv f z‖ ≤ ε * ‖w-z‖ := by
  intro e he
  have hh := DifferentiableAt.hasDerivAt hf
  rewrite [hasDerivAt_iff_tendsto, Metric.tendsto_nhds_nhds] at hh
  have ⟨d, hd, r⟩ := hh e he
  refine ⟨d, hd, ?_⟩
  intro w
  by_cases w ≠ z
  . simp only [Complex.norm_eq_abs, smul_eq_mul, dist_zero_right, norm_mul, norm_inv,
    Real.norm_eq_abs, Complex.abs_abs] at r
    have hr : dist w z < d → (Complex.abs (w - z))⁻¹ * Complex.abs (f w - f z - (w - z) * deriv f z) < e := by aesop
    conv at hr => {
      intro hw
      rewrite [inv_mul_lt_iff']
      rfl
      tactic => {
        rewrite [←Complex.norm_eq_abs]
        apply lt_of_le_of_ne
        exact norm_nonneg (w - z)
        symm
        rewrite [←dist_eq_norm, dist_ne_zero]
        exact h
      }
    }
    nth_rewrite 1 [←dist_eq_norm]
    simp only [Complex.norm_eq_abs]
    intro hdist
    exact le_of_lt $ hr hdist
  . simp at h
    rewrite [h]
    simp
