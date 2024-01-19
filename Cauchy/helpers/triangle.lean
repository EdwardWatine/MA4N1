import Mathlib.Data.Complex.Basic
import Mathlib.Data.Real.Basic
import Cauchy.definitions.triangle

open definitions

namespace helpers.triangle

def AddComponents : ℝ × ℝ × ℝ → ℝ := fun v => v.fst + v.snd.fst + v.snd.snd

def TrianglePoint (T : Triangle) : (ℝ × ℝ × ℝ) → ℂ :=
  λ v => v.fst * T.a + v.snd.fst * T.b + v.snd.snd * T.c

def R3_Pos := {v | ∃ a b c : ℝ, a ≥ 0 ∧ b ≥ 0 ∧ c ≥ 0 ∧ v = (a, b, c) }

def TriangleInR3 := R3_Pos ∩ (AddComponents ⁻¹' {1})

lemma perim_zero_iff_trivial (T : Triangle) : perimeter T = 0 ↔ Trivial T := by
  constructor
  intro hp
  unfold perimeter at hp
  repeat rewrite [add_eq_zero_iff'] at hp
  have ⟨⟨ha, hb⟩, _⟩ := hp
  rewrite [dist_eq_zero] at ha hb
  exact ⟨symm ha, symm hb⟩
  any_goals apply add_nonneg
  any_goals exact dist_nonneg
  unfold Trivial
  intro ⟨ha, hb⟩
  unfold perimeter
  rewrite [ha, hb]
  simp

lemma trivial_integral_zero {f : ℂ → ℂ} {T : Triangle} (hT : Trivial T) :
  trianglePathIntegral f T = 0 := by
  have ⟨ha, hb⟩ := hT
  rewrite [trianglePathIntegral_apply, ha, hb]
  unfold pathIntegral1' aux
  simp only [Pi.mul_apply, Function.comp_apply]
  conv_lhs => {
    conv => arg 2; arg 1; intro t; rewrite [deriv_linear_path]; simp
    arg 1; conv => arg 1; arg 1; intro t; rewrite [deriv_linear_path]; simp
    arg 2; conv => arg 1; intro t; rewrite [deriv_linear_path]; simp
  }
  simp_all only [intervalIntegral.integral_zero, add_zero]
