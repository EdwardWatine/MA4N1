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

lemma zero_le_of_gt_zero {x : ℝ} (hx : x ≥ 0) (he : ∀ε > 0, x ≤ ε) : x = 0 := by
  by_contra c
  rewrite [←Ne, ne_iff_lt_or_gt] at c
  cases c with
  | inl h => have h := not_lt_of_ge hx; contradiction
  | inr h => {
    have h₁ := he (x/2) (by linarith)
    linarith
  }

lemma zero_le_of_gt_zero_bounded {x y : ℝ} (hx : x ≥ 0) (hy : y > 0) (he : ∀ε ∈ Set.Ioo 0 y, x ≤ ε) : x = 0 := by
  by_contra c
  rewrite [←Ne, ne_iff_lt_or_gt] at c
  have hx' := lt_of_le_of_lt (a:=x) (b:=(y/2)) (c:=y) ?_ (by linarith)
  swap; apply he (y/2) ?_
  simp only [Set.mem_Ioo]
  exact ⟨by linarith, by linarith⟩

  cases c with
  | inl h => have h := not_lt_of_ge hx; contradiction
  | inr h => {
    have h₁ := he (x/2) ?_
    linarith
    simp only [Set.mem_Ioo]
    refine ⟨by linarith, lt_trans (by linarith) hx'⟩
  }
