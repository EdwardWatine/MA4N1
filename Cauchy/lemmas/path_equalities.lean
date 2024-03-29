import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Calculus.FDeriv.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.MeasureTheory.Integral.IntervalIntegral
import Mathlib.Analysis.Calculus.FDeriv.Basic
import Mathlib.Analysis.Normed.Field.Basic
import Mathlib.Data.Finset.Basic
import Mathlib.Algebra.BigOperators.Basic

import Cauchy.definitions.path
import Cauchy.definitions.path_integrals
import Cauchy.theorems.integral_restriction
import Cauchy.helpers.piecewise_paths
import Cauchy.lemmas.path_integral_integrable
import Cauchy.helpers.inequalities

open definitions unitInterval theorems helpers lemmas

--The aim of this file is to gather all results that are useful when working with paths
--Most of this are obvious results when doing proofs on paper, but one can't just go as
--simply over them when using Lean

-- We now show that it is the same to sum the integrals of two piece-wise paths, that to consider
--the integral of the piece-wise path that results from joining the piece-wise paths
--(what we called extend the paths) So ∫ₐf + ∫ₙf = ∫ₐ₊ₙ f

lemma piecewisepath_extend_additive {n m : ℕ} (f : ℂ → ℂ) (p : PiecewisePath n) (q : PiecewisePath m) :
  pathIntegral1 f (p.extend q) = pathIntegral1 f p + pathIntegral1 f q := by
  conv_lhs => {
    unfold pathIntegral1 PiecewisePath.extend
    rewrite [Fin.sum_univ_add]
    tactic => aesop
  }

--We now show that the linear changes to the parameters that we discussed do mnot affect the values
--of the integral when the bounds are acordingly shifted

lemma unit_scale_invariance (f : ℂ → ℂ) (γ : C1Path) (scale offset : I)
  (ho : offset ≤ (1:ℝ) - scale) (hs : scale ≠ 0) :
  pathIntegral1' f (γ.transform scale offset ho hs) = pathIntegral_bounds f γ offset (scale+offset) := by
  unfold pathIntegral1' pathIntegral_bounds C1Path.transform aux
  simp only [Pi.mul_apply, Function.comp_apply, Set.Icc.coe_zero, add_zero]
  rewrite [integral_restriction]
  conv_lhs => {
    arg 1; intro x; arg 1;
    intro t;
    rewrite [Set.restrict_apply]
    conv => {
      arg 2;
      conv => {
        apply deriv.scomp
        tactic => {
          apply DifferentiableOn.differentiableAt γ.differentiable_toFun
          rewrite [mem_nhds_iff]
          refine ⟨γ.open_cover.interval, ?_⟩
          have ⟨a, defs, gti, lts⟩ := γ.open_cover.interval_apply
          rewrite [defs]
          refine ⟨lts, isOpen_Ioo, ?_⟩
          refine inequalities.unit_transform_mem_cover scale hs ⟨t, ?_⟩ gti offset ho
          exact Set.mem_of_subset_of_mem gti t.2
        }
        tactic => {
          apply Differentiable.differentiableAt
          apply Differentiable.add
          apply Differentiable.const_mul
          exact differentiable_id'
          apply differentiable_const
        }
      }
      arg 1;
      rewrite [deriv_add_const, deriv_const_mul_field]
      simp only [deriv_id'', mul_one]
    }
    simp only [Complex.real_smul]
    rewrite [mul_rotate']
    arg 2; arg 2;
  }
  conv_lhs => {
    arg 1; intro x; arg 1; intro t; arg 2;
    rewrite [←Function.comp_apply (f:=f)]
    rewrite [←Pi.mul_apply]
  }

  have unrestrict :
  ∫ (x : ℝ) in (0)..(1), function_extension (fun (t : I) => ↑↑scale * (deriv γ.toFun * f ∘ γ.toFun)
    (↑scale * ↑t + ↑offset)) x =
  ∫ (t : ℝ) in (0)..(1), ↑↑scale * (deriv γ.toFun * f ∘ γ.toFun) (↑scale * ↑t + ↑offset) := by
    apply intervalIntegral.integral_congr
    unfold function_extension Set.EqOn
    aesop

  rewrite [unrestrict]
  simp only [intervalIntegral.integral_const_mul]
  rewrite [intervalIntegral.integral_comp_mul_add]
  simp only [Pi.mul_apply, Function.comp_apply, mul_zero, mul_one, Complex.real_smul,
    Complex.ofReal_inv, ne_eq, Complex.ofReal_eq_zero, Set.Icc.coe_eq_zero]
  rewrite [mul_rotate', mul_rotate']
  simp_all only [ne_eq, Pi.mul_apply, Function.comp_apply, intervalIntegral.integral_const_mul,
    Complex.ofReal_eq_zero, Set.Icc.coe_eq_zero, not_false_eq_true, mul_inv_cancel, mul_one, zero_add]
  conv in _ * _ => {
    rewrite [mul_comm]
  }
  all_goals aesop

--We now show that the path integral over a C¹ Path is the same as the path integral over the Piece-wise path
--that results from splitting the C¹ path into two
--useful since it shows that PathIntegral1 and PathIntegral1' behave well together

theorem split_equality {U : Set ℂ} (f : ℂ → ℂ) (h : DifferentiableOn ℂ f U)
  (γ : C1Path) (hγ : γ '' I ⊆ U) :
  pathIntegral1' f γ = pathIntegral1 f (γ.split split) := by
  rewrite [PiecewisePath.path_integral_two]
  unfold C1Path.split
  simp
  repeat rewrite [unit_scale_invariance]
  simp only [Set.Icc.coe_zero, add_zero, sub_add_cancel]
  unfold pathIntegral_bounds
  rewrite [intervalIntegral.integral_add_adjacent_intervals]
  unfold pathIntegral1'; rfl
  apply IntervalIntegrable.mono_set (a:=0) (b:=1)
  . exact aux_integrable f h γ hγ
  . rewrite [Set.uIcc_subset_uIcc_iff_mem]
    simp; exact ⟨le_of_lt split.2.1, le_of_lt split.2.2⟩
  apply IntervalIntegrable.mono_set (a:=0) (b:=1)
  . exact aux_integrable f h γ hγ
  . rewrite [Set.uIcc_subset_uIcc_iff_mem]
    simp; exact ⟨le_of_lt split.2.1, le_of_lt split.2.2⟩

-- We now show that the effect of the direction of the path is only the sign of the integral
-- So ∫₋ₐ f = - ∫ₐf

theorem reverse_pathIntegral_neg (f : ℂ → ℂ) (γ : C1Path) :
  pathIntegral1' f γ.reverse = -pathIntegral1' f γ := by
  unfold pathIntegral1' C1Path.reverse aux
  simp only [Pi.mul_apply, Function.comp_apply]
  rewrite [integral_restriction]
  conv_lhs => {
    arg 1; intro x; arg 1;
    intro t;
    rewrite [Set.restrict_apply]
    conv => {
      arg 2;
      conv => {
        apply deriv.scomp
        tactic => {
          apply DifferentiableOn.differentiableAt γ.differentiable_toFun
          rewrite [mem_nhds_iff]
          refine ⟨γ.open_cover.interval, ?_⟩
          have ⟨a, defs, gti, lts⟩ := γ.open_cover.interval_apply
          rewrite [defs]
          refine ⟨lts, isOpen_Ioo, ?_⟩
          refine inequalities.reverse_mem_cover ⟨t, ?_⟩
          exact Set.mem_of_subset_of_mem gti t.2
        }
        tactic => {
          apply Differentiable.differentiableAt
          apply Differentiable.add
          apply differentiable_const
          apply Differentiable.neg
          exact differentiable_id'
        }
      }
      arg 1;
      rewrite [deriv_const_sub]
      simp only [deriv_id'', mul_one]
    }
    simp only [Complex.real_smul]
    rewrite [mul_rotate']
    arg 2; arg 2;
  }
  conv_lhs => {
    arg 1; intro x; arg 1; intro t; arg 2;
    rewrite [←Function.comp_apply (f:=f)]
    rewrite [←Pi.mul_apply]
  }
  simp only [Complex.ofReal_neg, Complex.ofReal_one]
  have unrestrict :
  ∫ (x : ℝ) in (0)..(1), function_extension (fun (t : I) => -1 * (deriv γ.toFun * f ∘ γ.toFun) (1 - ↑t)) x =
  ∫ (x : ℝ) in (0)..(1), -1 * (deriv γ.toFun * f ∘ γ.toFun) (1 - ↑x) := by
    apply intervalIntegral.integral_congr
    unfold function_extension Set.EqOn
    aesop

  rewrite [unrestrict]
  simp only [intervalIntegral.integral_const_mul]
  rewrite [intervalIntegral.integral_comp_sub_left]
  simp only [Pi.mul_apply, Function.comp_apply, sub_self, sub_zero, neg_mul, one_mul, neg_inj]
  conv in _ * _ => {
    rewrite [mul_comm]
  }
  exact zero_le_one
