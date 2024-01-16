-- Average of four numbers

import Mathlib.Data.Real.Basic
import Mathlib.Tactic
import Cauchy.lemmas.triangle_inequality
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecialFunctions.Pow.Asymptotics

namespace lemmas

open lemmas

lemma pow_zseq_to_zero (a x : ℝ) (hx : x > 1) : ∀ε > 0, ∃(n:ℤ), n ≤ 0 ∧ z*x^n ≤ ε := by
  intro e he
  by_cases z <= 0
  refine ⟨0, ?_⟩
  simp only [Int.cast_zero, Real.rpow_zero, mul_one, true_and]
  linarith
  simp only [not_le] at h
  have hl := tendsto_rpow_atTop_of_base_gt_one x hx
  rewrite [Metric.tendsto_nhds] at hl
  have hh := hl (e/z) (div_pos he h)
  simp at hh
  have ⟨n', hn'⟩ := hh
  have f := Real.exists_floor n'
  have ⟨n, hn⟩ := f
  have lb := hn' (min n 0) ?_
  rewrite [lt_div_iff' h, abs_of_pos] at lb
  refine ⟨min n 0, Int.min_le_right n 0, ?_⟩
  simp only [Int.cast_min, Int.cast_zero]
  exact le_of_lt lb
  apply Real.rpow_pos_of_pos
  linarith
  aesop

lemma pow_seq_to_zero (a x : ℝ) (hx : x > 1) : ∀ε > 0, ∃n:ℕ, z/x^(n:ℝ) ≤ ε := by
  intro e he
  have h : ∀ε > 0, ∃(n:ℤ), n ≤ 0 ∧ z*x^n ≤ ε := pow_zseq_to_zero a x hx
  have hh := h e he
  have ⟨n', hn'⟩ := hh
  have ⟨n, hn⟩ := Int.exists_eq_neg_ofNat hn'.1
  refine ⟨n, ?_⟩
  rewrite [div_eq_mul_inv, ←Real.rpow_neg]
  convert hn'.2
  aesop
  linarith

end lemmas