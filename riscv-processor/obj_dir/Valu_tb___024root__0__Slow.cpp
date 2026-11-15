// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Valu_tb.h for the primary calling header

#include "Valu_tb__pch.h"

VL_ATTR_COLD void Valu_tb___024root___eval_static(Valu_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___eval_static\n"); );
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    {
        // Inlined CFunc: _eval_static__TOP
        vlSelfRef.alu_tb__DOT__passed = 0U;
        vlSelfRef.alu_tb__DOT__failed = 0U;
    }
    {
        // Inlined CFunc: __VtraceActivitySetAll
        vlSelfRef.__VtraceActivity[0U] = 1U;
        vlSelfRef.__VtraceActivity[1U] = 1U;
        vlSelfRef.__VtraceActivity[2U] = 1U;
    }
    do {
        vlSelfRef.__VactTriggeredAcc[vlSelfRef.__Vi] 
            = vlSelfRef.__VactTriggered[vlSelfRef.__Vi];
        vlSelfRef.__Vi = ((::IData)(1U) + vlSelfRef.__Vi);
    } while ((0U >= vlSelfRef.__Vi));
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Valu_tb___024root___dump_triggers__stl(const ::VlUnpacked<::QData/*63:0*/, 1> &triggers, const ::std::string &tag);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Valu_tb___024root___trigger_anySet__stl(const ::VlUnpacked<::QData/*63:0*/, 1> &in);

VL_ATTR_COLD bool Valu_tb___024root___eval_stl(Valu_tb___024root* vlSelf, ::CData/*0:0*/ firstIteration) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___eval_stl\n"); );
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    ::CData/*0:0*/ __VstlExecute;
    // Body
    vlSelfRef.__VstlTriggered[0U] = ((0xfffffffffffffffeULL 
                                      & vlSelfRef.__VstlTriggered[0U]) 
                                     | (::IData)((::IData)(firstIteration)));
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Valu_tb___024root___dump_triggers__stl(vlSelfRef.__VstlTriggered, "stl"s);
    }
#endif
    __VstlExecute = Valu_tb___024root___trigger_anySet__stl(vlSelfRef.__VstlTriggered);
    if (__VstlExecute) {
        {
            // Inlined CFunc: _eval_body__stl
            if ((((1ULL & vlSelfRef.__VstlTriggered[0U])) != 0ULL)) {
                {
                    // Inlined CFunc: _act_comb__TOP__0
                    vlSelfRef.alu_tb__DOT__dut__DOT__alu_result 
                        = ((4U & (::IData)(vlSelfRef.alu_tb__DOT__alu_control))
                            ? ((2U & (::IData)(vlSelfRef.alu_tb__DOT__alu_control))
                                ? (1U & (- (::IData)(
                                                     ((~ (::IData)(vlSelfRef.alu_tb__DOT__alu_control)) 
                                                      & (vlSelfRef.alu_tb__DOT__operand_a 
                                                         < vlSelfRef.alu_tb__DOT__operand_b)))))
                                : ((1U & (::IData)(vlSelfRef.alu_tb__DOT__alu_control))
                                    ? (1U & (- (::IData)(
                                                         VL_LTS_III(32, vlSelfRef.alu_tb__DOT__operand_a, vlSelfRef.alu_tb__DOT__operand_b))))
                                    : (vlSelfRef.alu_tb__DOT__operand_a 
                                       ^ vlSelfRef.alu_tb__DOT__operand_b)))
                            : ((2U & (::IData)(vlSelfRef.alu_tb__DOT__alu_control))
                                ? ((1U & (::IData)(vlSelfRef.alu_tb__DOT__alu_control))
                                    ? (vlSelfRef.alu_tb__DOT__operand_a 
                                       | vlSelfRef.alu_tb__DOT__operand_b)
                                    : (vlSelfRef.alu_tb__DOT__operand_a 
                                       & vlSelfRef.alu_tb__DOT__operand_b))
                                : ((1U & (::IData)(vlSelfRef.alu_tb__DOT__alu_control))
                                    ? (vlSelfRef.alu_tb__DOT__operand_a 
                                       - vlSelfRef.alu_tb__DOT__operand_b)
                                    : (vlSelfRef.alu_tb__DOT__operand_a 
                                       + vlSelfRef.alu_tb__DOT__operand_b))));
                }
            }
        }
    }
    return (__VstlExecute);
}

VL_ATTR_COLD void Valu_tb___024root___eval_dump_triggers__stl(Valu_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___eval_dump_triggers__stl\n"); );
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
#ifdef VL_DEBUG
    Valu_tb___024root___dump_triggers__stl(vlSelfRef.__VstlTriggered, "stl"s);
#endif
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Valu_tb___024root___dump_triggers__ico(const ::VlUnpacked<::QData/*63:0*/, 1> &triggers, const ::std::string &tag);
#endif  // VL_DEBUG

VL_ATTR_COLD void Valu_tb___024root___eval_dump_triggers__ico(Valu_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___eval_dump_triggers__ico\n"); );
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
#ifdef VL_DEBUG
    Valu_tb___024root___dump_triggers__ico(vlSelfRef.__VicoTriggered, "ico"s);
#endif
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Valu_tb___024root___dump_triggers__act(const ::VlUnpacked<::QData/*63:0*/, 1> &triggers, const ::std::string &tag);
#endif  // VL_DEBUG

VL_ATTR_COLD void Valu_tb___024root___eval_dump_triggers__act(Valu_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___eval_dump_triggers__act\n"); );
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
#ifdef VL_DEBUG
    Valu_tb___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
#endif
}

VL_ATTR_COLD void Valu_tb___024root___eval_dump_triggers__nba(Valu_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___eval_dump_triggers__nba\n"); );
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
#ifdef VL_DEBUG
    Valu_tb___024root___dump_triggers__act(vlSelfRef.__VnbaTriggered, "nba"s);
#endif
}

VL_ATTR_COLD void Valu_tb___024root___eval_dump_triggers__obs(Valu_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___eval_dump_triggers__obs\n"); );
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Valu_tb___024root___eval_dump_triggers__react(Valu_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___eval_dump_triggers__react\n"); );
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Valu_tb___024root___eval_final(Valu_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___eval_final\n"); );
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Valu_tb___024root___dump_triggers__stl(const ::VlUnpacked<::QData/*63:0*/, 1> &triggers, const ::std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (::IData)(Valu_tb___024root___trigger_anySet__stl(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (::IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD bool Valu_tb___024root___trigger_anySet__stl(const ::VlUnpacked<::QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___trigger_anySet__stl\n"); );
    // Locals
    ::IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        if (in[n]) {
            return (1U);
        }
        n = ((::IData)(1U) + n);
    } while ((1U > n));
    return (0U);
}

bool Valu_tb___024root___trigger_anySet__ico(const ::VlUnpacked<::QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Valu_tb___024root___dump_triggers__ico(const ::VlUnpacked<::QData/*63:0*/, 1> &triggers, const ::std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___dump_triggers__ico\n"); );
    // Body
    if ((1U & (~ (::IData)(Valu_tb___024root___trigger_anySet__ico(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (::IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: Internal 'ico' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

bool Valu_tb___024root___trigger_anySet__act(const ::VlUnpacked<::QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Valu_tb___024root___dump_triggers__act(const ::VlUnpacked<::QData/*63:0*/, 1> &triggers, const ::std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (::IData)(Valu_tb___024root___trigger_anySet__act(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (::IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: @([true] __VdlySched.awaitingCurrentTime())\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Valu_tb___024root___ctor_var_reset(Valu_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___ctor_var_reset\n"); );
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->vlNamep);
    vlSelf->alu_tb__DOT__operand_a = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 9113927655815975914ull);
    vlSelf->alu_tb__DOT__operand_b = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 2190821872220524683ull);
    vlSelf->alu_tb__DOT__alu_control = VL_SCOPED_RAND_RESET_I(3, __VscopeHash, 17931386034944069072ull);
    vlSelf->alu_tb__DOT__dut__DOT__alu_result = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 9359315696872766798ull);
    vlSelf->__VstlTriggered[0] = 0;
    VL_UNPACKED_FILL(vlSelf->__VstlTriggered.data(), sizeof(vlSelf->__VstlTriggered[0]), 1);
    vlSelf->__VicoTriggered[0] = 0;
    VL_UNPACKED_FILL(vlSelf->__VicoTriggered.data(), sizeof(vlSelf->__VicoTriggered[0]), 1);
    vlSelf->__VactTriggered[0] = 0;
    VL_UNPACKED_FILL(vlSelf->__VactTriggered.data(), sizeof(vlSelf->__VactTriggered[0]), 1);
    vlSelf->__VactTriggeredAcc[0] = 0;
    VL_UNPACKED_FILL(vlSelf->__VactTriggeredAcc.data(), sizeof(vlSelf->__VactTriggeredAcc[0]), 1);
    vlSelf->__VnbaTriggered[0] = 0;
    VL_UNPACKED_FILL(vlSelf->__VnbaTriggered.data(), sizeof(vlSelf->__VnbaTriggered[0]), 1);
    vlSelf->__Vi = 0;
    vlSelf->__VtraceActivity[0] = 0;
    VL_UNPACKED_FILL(vlSelf->__VtraceActivity.data(), sizeof(vlSelf->__VtraceActivity[0]), 3);
}
