// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Valu_tb.h for the primary calling header

#include "Valu_tb__pch.h"

VlCoroutine Valu_tb___024root___eval_initial__TOP__Vtiming__0(Valu_tb___024root* vlSelf);

void Valu_tb___024root___eval_initial(Valu_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___eval_initial\n"); );
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Valu_tb___024root___eval_initial__TOP__Vtiming__0(vlSelf);
    vlSelfRef.__VtraceActivity[1U] = 1U;
}

void Valu_tb___024root___eval_sample(Valu_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___eval_sample\n"); );
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Valu_tb___024root___dump_triggers__ico(const ::VlUnpacked<::QData/*63:0*/, 1> &triggers, const ::std::string &tag);
#endif  // VL_DEBUG

bool Valu_tb___024root___eval_ico(Valu_tb___024root* vlSelf, ::CData/*0:0*/ firstIteration) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___eval_ico\n"); );
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VicoTriggered[0U] = ((0xfffffffffffffffeULL 
                                      & vlSelfRef.__VicoTriggered[0U]) 
                                     | (::IData)((::IData)(firstIteration)));
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Valu_tb___024root___dump_triggers__ico(vlSelfRef.__VicoTriggered, "ico"s);
    }
#endif
    return (0U);
}

void Valu_tb___024root___trigger_orInto__act_vec_vec(::VlUnpacked<::QData/*63:0*/, 1> &out, const ::VlUnpacked<::QData/*63:0*/, 1> &in);
#ifdef VL_DEBUG
VL_ATTR_COLD void Valu_tb___024root___dump_triggers__act(const ::VlUnpacked<::QData/*63:0*/, 1> &triggers, const ::std::string &tag);
#endif  // VL_DEBUG
bool Valu_tb___024root___trigger_anySet__act(const ::VlUnpacked<::QData/*63:0*/, 1> &in);

bool Valu_tb___024root___eval_act(Valu_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___eval_act\n"); );
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    ::CData/*0:0*/ __VactExecute;
    // Body
    {
        // Inlined CFunc: _eval_triggers_vec__act
        vlSelfRef.__VactTriggered[0U] = (::QData)((::IData)(vlSelfRef.__Vnontrivs.__VdlySched.awaitingCurrentTime()));
    }
    Valu_tb___024root___trigger_orInto__act_vec_vec(vlSelfRef.__VactTriggered, vlSelfRef.__VactTriggeredAcc);
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Valu_tb___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
    }
#endif
    Valu_tb___024root___trigger_orInto__act_vec_vec(vlSelfRef.__VnbaTriggered, vlSelfRef.__VactTriggered);
    __VactExecute = Valu_tb___024root___trigger_anySet__act(vlSelfRef.__VactTriggered);
    if (__VactExecute) {
        vlSelfRef.__VactTriggeredAcc.fill(0ULL);
        {
            // Inlined CFunc: _timing_resume
            if ((((1ULL & vlSelfRef.__VactTriggered[0U])) != 0ULL)) {
                vlSelfRef.__Vnontrivs.__VdlySched.resume();
            }
        }
        {
            // Inlined CFunc: _eval_body__act
            if ((((1ULL & vlSelfRef.__VactTriggered[0U])) != 0ULL)) {
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
    return (__VactExecute);
}

bool Valu_tb___024root___eval_inact(Valu_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___eval_inact\n"); );
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    ::CData/*0:0*/ __VinactExecute;
    // Body
    __VinactExecute = vlSelfRef.__Vnontrivs.__VdlySched.awaitingZeroDelay();
    if (__VinactExecute) {
        VL_FATAL_MT("testbench/alu_tb.sv", 1, "", "ZERODLY: Design Verilated with '--no-sched-zero-delay', but #0 delay executed at runtime");
    }
    return (__VinactExecute);
}

void Valu_tb___024root___trigger_clear__act(::VlUnpacked<::QData/*63:0*/, 1> &out);

bool Valu_tb___024root___eval_nba(Valu_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___eval_nba\n"); );
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    ::CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = Valu_tb___024root___trigger_anySet__act(vlSelfRef.__VnbaTriggered);
    if (__VnbaExecute) {
        {
            // Inlined CFunc: _eval_body__nba
            if ((((1ULL & vlSelfRef.__VnbaTriggered[0U])) != 0ULL)) {
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
        Valu_tb___024root___trigger_clear__act(vlSelfRef.__VnbaTriggered);
    }
    return (__VnbaExecute);
}

bool Valu_tb___024root___eval_obs(Valu_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___eval_obs\n"); );
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    return (0U);
}

bool Valu_tb___024root___eval_react(Valu_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___eval_react\n"); );
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    return (0U);
}

void Valu_tb___024root___eval_postponed(Valu_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___eval_postponed\n"); );
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VlCoroutine Valu_tb___024root___eval_initial__TOP__Vtiming__0(Valu_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___eval_initial__TOP__Vtiming__0\n"); );
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    ::CData/*2:0*/ __Vtask_alu_tb__DOT__check_result__operation_0;
    __Vtask_alu_tb__DOT__check_result__operation_0 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__a_1;
    __Vtask_alu_tb__DOT__check_result__a_1 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__b_2;
    __Vtask_alu_tb__DOT__check_result__b_2 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__expected_3;
    __Vtask_alu_tb__DOT__check_result__expected_3 = 0;
    ::CData/*2:0*/ __Vtask_alu_tb__DOT__check_result__operation_4;
    __Vtask_alu_tb__DOT__check_result__operation_4 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__a_5;
    __Vtask_alu_tb__DOT__check_result__a_5 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__b_6;
    __Vtask_alu_tb__DOT__check_result__b_6 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__expected_7;
    __Vtask_alu_tb__DOT__check_result__expected_7 = 0;
    ::CData/*2:0*/ __Vtask_alu_tb__DOT__check_result__operation_8;
    __Vtask_alu_tb__DOT__check_result__operation_8 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__a_9;
    __Vtask_alu_tb__DOT__check_result__a_9 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__b_10;
    __Vtask_alu_tb__DOT__check_result__b_10 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__expected_11;
    __Vtask_alu_tb__DOT__check_result__expected_11 = 0;
    ::CData/*2:0*/ __Vtask_alu_tb__DOT__check_result__operation_12;
    __Vtask_alu_tb__DOT__check_result__operation_12 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__a_13;
    __Vtask_alu_tb__DOT__check_result__a_13 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__b_14;
    __Vtask_alu_tb__DOT__check_result__b_14 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__expected_15;
    __Vtask_alu_tb__DOT__check_result__expected_15 = 0;
    ::CData/*2:0*/ __Vtask_alu_tb__DOT__check_result__operation_16;
    __Vtask_alu_tb__DOT__check_result__operation_16 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__a_17;
    __Vtask_alu_tb__DOT__check_result__a_17 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__b_18;
    __Vtask_alu_tb__DOT__check_result__b_18 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__expected_19;
    __Vtask_alu_tb__DOT__check_result__expected_19 = 0;
    ::CData/*2:0*/ __Vtask_alu_tb__DOT__check_result__operation_20;
    __Vtask_alu_tb__DOT__check_result__operation_20 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__a_21;
    __Vtask_alu_tb__DOT__check_result__a_21 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__b_22;
    __Vtask_alu_tb__DOT__check_result__b_22 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__expected_23;
    __Vtask_alu_tb__DOT__check_result__expected_23 = 0;
    ::CData/*2:0*/ __Vtask_alu_tb__DOT__check_result__operation_24;
    __Vtask_alu_tb__DOT__check_result__operation_24 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__a_25;
    __Vtask_alu_tb__DOT__check_result__a_25 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__b_26;
    __Vtask_alu_tb__DOT__check_result__b_26 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__expected_27;
    __Vtask_alu_tb__DOT__check_result__expected_27 = 0;
    ::CData/*2:0*/ __Vtask_alu_tb__DOT__check_result__operation_28;
    __Vtask_alu_tb__DOT__check_result__operation_28 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__a_29;
    __Vtask_alu_tb__DOT__check_result__a_29 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__b_30;
    __Vtask_alu_tb__DOT__check_result__b_30 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__expected_31;
    __Vtask_alu_tb__DOT__check_result__expected_31 = 0;
    ::CData/*2:0*/ __Vtask_alu_tb__DOT__check_result__operation_32;
    __Vtask_alu_tb__DOT__check_result__operation_32 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__a_33;
    __Vtask_alu_tb__DOT__check_result__a_33 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__b_34;
    __Vtask_alu_tb__DOT__check_result__b_34 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__expected_35;
    __Vtask_alu_tb__DOT__check_result__expected_35 = 0;
    ::CData/*2:0*/ __Vtask_alu_tb__DOT__check_result__operation_36;
    __Vtask_alu_tb__DOT__check_result__operation_36 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__a_37;
    __Vtask_alu_tb__DOT__check_result__a_37 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__b_38;
    __Vtask_alu_tb__DOT__check_result__b_38 = 0;
    ::IData/*31:0*/ __Vtask_alu_tb__DOT__check_result__expected_39;
    __Vtask_alu_tb__DOT__check_result__expected_39 = 0;
    // Body
    vlSymsp->_vm_contextp__->dumpfile("simulation/alu.vcd"s);
    vlSymsp->_traceDumpOpen();
    VL_WRITEF_NX("\n========== ALU TESTING STARTED ==========\n\n",0);
    __Vtask_alu_tb__DOT__check_result__expected_3 = 0x0000001eU;
    __Vtask_alu_tb__DOT__check_result__b_2 = 0x00000014U;
    __Vtask_alu_tb__DOT__check_result__a_1 = 0x0000000aU;
    __Vtask_alu_tb__DOT__check_result__operation_0 = 0U;
    vlSelfRef.alu_tb__DOT__alu_control = 0U;
    vlSelfRef.alu_tb__DOT__operand_a = 0x0000000aU;
    vlSelfRef.alu_tb__DOT__operand_b = 0x00000014U;
    co_await vlSelfRef.__Vnontrivs.__VdlySched.delay(1ULL, 
                                                     nullptr, 
                                                     "testbench/alu_tb.sv", 
                                                     33);
    vlSelfRef.__VtraceActivity[2U] = 1U;
    if (((vlSelfRef.alu_tb__DOT__dut__DOT__alu_result 
          == __Vtask_alu_tb__DOT__check_result__expected_3) 
         & ((0U == vlSelfRef.alu_tb__DOT__dut__DOT__alu_result) 
            == (0U == __Vtask_alu_tb__DOT__check_result__expected_3)))) {
        vlSelfRef.alu_tb__DOT__passed = ((::IData)(1U) 
                                         + vlSelfRef.alu_tb__DOT__passed);
        VL_WRITEF_NX("PASS | OP=%b | A=%h | B=%h | RESULT=%h\n",4
                     , '#',3,__Vtask_alu_tb__DOT__check_result__operation_0
                     , '#',32,__Vtask_alu_tb__DOT__check_result__a_1
                     , '#',32,__Vtask_alu_tb__DOT__check_result__b_2
                     , '#',32,vlSelfRef.alu_tb__DOT__dut__DOT__alu_result);
    } else {
        vlSelfRef.alu_tb__DOT__failed = ((::IData)(1U) 
                                         + vlSelfRef.alu_tb__DOT__failed);
        VL_WRITEF_NX("FAIL | OP=%b | EXPECTED=%h | ACTUAL=%h\n",3
                     , '#',3,__Vtask_alu_tb__DOT__check_result__operation_0
                     , '#',32,__Vtask_alu_tb__DOT__check_result__expected_3
                     , '#',32,vlSelfRef.alu_tb__DOT__dut__DOT__alu_result);
    }
    __Vtask_alu_tb__DOT__check_result__expected_7 = 0x00000014U;
    __Vtask_alu_tb__DOT__check_result__b_6 = 0x0000000aU;
    __Vtask_alu_tb__DOT__check_result__a_5 = 0x0000001eU;
    __Vtask_alu_tb__DOT__check_result__operation_4 = 1U;
    vlSelfRef.alu_tb__DOT__alu_control = __Vtask_alu_tb__DOT__check_result__operation_4;
    vlSelfRef.alu_tb__DOT__operand_a = __Vtask_alu_tb__DOT__check_result__a_5;
    vlSelfRef.alu_tb__DOT__operand_b = __Vtask_alu_tb__DOT__check_result__b_6;
    co_await vlSelfRef.__Vnontrivs.__VdlySched.delay(1ULL, 
                                                     nullptr, 
                                                     "testbench/alu_tb.sv", 
                                                     33);
    vlSelfRef.__VtraceActivity[2U] = 1U;
    if (((vlSelfRef.alu_tb__DOT__dut__DOT__alu_result 
          == __Vtask_alu_tb__DOT__check_result__expected_7) 
         & ((0U == vlSelfRef.alu_tb__DOT__dut__DOT__alu_result) 
            == (0U == __Vtask_alu_tb__DOT__check_result__expected_7)))) {
        vlSelfRef.alu_tb__DOT__passed = ((::IData)(1U) 
                                         + vlSelfRef.alu_tb__DOT__passed);
        VL_WRITEF_NX("PASS | OP=%b | A=%h | B=%h | RESULT=%h\n",4
                     , '#',3,__Vtask_alu_tb__DOT__check_result__operation_4
                     , '#',32,__Vtask_alu_tb__DOT__check_result__a_5
                     , '#',32,__Vtask_alu_tb__DOT__check_result__b_6
                     , '#',32,vlSelfRef.alu_tb__DOT__dut__DOT__alu_result);
    } else {
        vlSelfRef.alu_tb__DOT__failed = ((::IData)(1U) 
                                         + vlSelfRef.alu_tb__DOT__failed);
        VL_WRITEF_NX("FAIL | OP=%b | EXPECTED=%h | ACTUAL=%h\n",3
                     , '#',3,__Vtask_alu_tb__DOT__check_result__operation_4
                     , '#',32,__Vtask_alu_tb__DOT__check_result__expected_7
                     , '#',32,vlSelfRef.alu_tb__DOT__dut__DOT__alu_result);
    }
    __Vtask_alu_tb__DOT__check_result__expected_11 = 0x00000f00U;
    __Vtask_alu_tb__DOT__check_result__b_10 = 0x00000ff0U;
    __Vtask_alu_tb__DOT__check_result__a_9 = 0x0000ff00U;
    __Vtask_alu_tb__DOT__check_result__operation_8 = 2U;
    vlSelfRef.alu_tb__DOT__alu_control = __Vtask_alu_tb__DOT__check_result__operation_8;
    vlSelfRef.alu_tb__DOT__operand_a = __Vtask_alu_tb__DOT__check_result__a_9;
    vlSelfRef.alu_tb__DOT__operand_b = __Vtask_alu_tb__DOT__check_result__b_10;
    co_await vlSelfRef.__Vnontrivs.__VdlySched.delay(1ULL, 
                                                     nullptr, 
                                                     "testbench/alu_tb.sv", 
                                                     33);
    vlSelfRef.__VtraceActivity[2U] = 1U;
    if (((vlSelfRef.alu_tb__DOT__dut__DOT__alu_result 
          == __Vtask_alu_tb__DOT__check_result__expected_11) 
         & ((0U == vlSelfRef.alu_tb__DOT__dut__DOT__alu_result) 
            == (0U == __Vtask_alu_tb__DOT__check_result__expected_11)))) {
        vlSelfRef.alu_tb__DOT__passed = ((::IData)(1U) 
                                         + vlSelfRef.alu_tb__DOT__passed);
        VL_WRITEF_NX("PASS | OP=%b | A=%h | B=%h | RESULT=%h\n",4
                     , '#',3,__Vtask_alu_tb__DOT__check_result__operation_8
                     , '#',32,__Vtask_alu_tb__DOT__check_result__a_9
                     , '#',32,__Vtask_alu_tb__DOT__check_result__b_10
                     , '#',32,vlSelfRef.alu_tb__DOT__dut__DOT__alu_result);
    } else {
        vlSelfRef.alu_tb__DOT__failed = ((::IData)(1U) 
                                         + vlSelfRef.alu_tb__DOT__failed);
        VL_WRITEF_NX("FAIL | OP=%b | EXPECTED=%h | ACTUAL=%h\n",3
                     , '#',3,__Vtask_alu_tb__DOT__check_result__operation_8
                     , '#',32,__Vtask_alu_tb__DOT__check_result__expected_11
                     , '#',32,vlSelfRef.alu_tb__DOT__dut__DOT__alu_result);
    }
    __Vtask_alu_tb__DOT__check_result__expected_15 = 0x0000f0ffU;
    __Vtask_alu_tb__DOT__check_result__b_14 = 0x000000ffU;
    __Vtask_alu_tb__DOT__check_result__a_13 = 0x0000f000U;
    __Vtask_alu_tb__DOT__check_result__operation_12 = 3U;
    vlSelfRef.alu_tb__DOT__alu_control = __Vtask_alu_tb__DOT__check_result__operation_12;
    vlSelfRef.alu_tb__DOT__operand_a = __Vtask_alu_tb__DOT__check_result__a_13;
    vlSelfRef.alu_tb__DOT__operand_b = __Vtask_alu_tb__DOT__check_result__b_14;
    co_await vlSelfRef.__Vnontrivs.__VdlySched.delay(1ULL, 
                                                     nullptr, 
                                                     "testbench/alu_tb.sv", 
                                                     33);
    vlSelfRef.__VtraceActivity[2U] = 1U;
    if (((vlSelfRef.alu_tb__DOT__dut__DOT__alu_result 
          == __Vtask_alu_tb__DOT__check_result__expected_15) 
         & ((0U == vlSelfRef.alu_tb__DOT__dut__DOT__alu_result) 
            == (0U == __Vtask_alu_tb__DOT__check_result__expected_15)))) {
        vlSelfRef.alu_tb__DOT__passed = ((::IData)(1U) 
                                         + vlSelfRef.alu_tb__DOT__passed);
        VL_WRITEF_NX("PASS | OP=%b | A=%h | B=%h | RESULT=%h\n",4
                     , '#',3,__Vtask_alu_tb__DOT__check_result__operation_12
                     , '#',32,__Vtask_alu_tb__DOT__check_result__a_13
                     , '#',32,__Vtask_alu_tb__DOT__check_result__b_14
                     , '#',32,vlSelfRef.alu_tb__DOT__dut__DOT__alu_result);
    } else {
        vlSelfRef.alu_tb__DOT__failed = ((::IData)(1U) 
                                         + vlSelfRef.alu_tb__DOT__failed);
        VL_WRITEF_NX("FAIL | OP=%b | EXPECTED=%h | ACTUAL=%h\n",3
                     , '#',3,__Vtask_alu_tb__DOT__check_result__operation_12
                     , '#',32,__Vtask_alu_tb__DOT__check_result__expected_15
                     , '#',32,vlSelfRef.alu_tb__DOT__dut__DOT__alu_result);
    }
    __Vtask_alu_tb__DOT__check_result__expected_19 = 0x0000ffffU;
    __Vtask_alu_tb__DOT__check_result__b_18 = 0x00005555U;
    __Vtask_alu_tb__DOT__check_result__a_17 = 0x0000aaaaU;
    __Vtask_alu_tb__DOT__check_result__operation_16 = 4U;
    vlSelfRef.alu_tb__DOT__alu_control = __Vtask_alu_tb__DOT__check_result__operation_16;
    vlSelfRef.alu_tb__DOT__operand_a = __Vtask_alu_tb__DOT__check_result__a_17;
    vlSelfRef.alu_tb__DOT__operand_b = __Vtask_alu_tb__DOT__check_result__b_18;
    co_await vlSelfRef.__Vnontrivs.__VdlySched.delay(1ULL, 
                                                     nullptr, 
                                                     "testbench/alu_tb.sv", 
                                                     33);
    vlSelfRef.__VtraceActivity[2U] = 1U;
    if (((vlSelfRef.alu_tb__DOT__dut__DOT__alu_result 
          == __Vtask_alu_tb__DOT__check_result__expected_19) 
         & ((0U == vlSelfRef.alu_tb__DOT__dut__DOT__alu_result) 
            == (0U == __Vtask_alu_tb__DOT__check_result__expected_19)))) {
        vlSelfRef.alu_tb__DOT__passed = ((::IData)(1U) 
                                         + vlSelfRef.alu_tb__DOT__passed);
        VL_WRITEF_NX("PASS | OP=%b | A=%h | B=%h | RESULT=%h\n",4
                     , '#',3,__Vtask_alu_tb__DOT__check_result__operation_16
                     , '#',32,__Vtask_alu_tb__DOT__check_result__a_17
                     , '#',32,__Vtask_alu_tb__DOT__check_result__b_18
                     , '#',32,vlSelfRef.alu_tb__DOT__dut__DOT__alu_result);
    } else {
        vlSelfRef.alu_tb__DOT__failed = ((::IData)(1U) 
                                         + vlSelfRef.alu_tb__DOT__failed);
        VL_WRITEF_NX("FAIL | OP=%b | EXPECTED=%h | ACTUAL=%h\n",3
                     , '#',3,__Vtask_alu_tb__DOT__check_result__operation_16
                     , '#',32,__Vtask_alu_tb__DOT__check_result__expected_19
                     , '#',32,vlSelfRef.alu_tb__DOT__dut__DOT__alu_result);
    }
    __Vtask_alu_tb__DOT__check_result__expected_23 = 1U;
    __Vtask_alu_tb__DOT__check_result__b_22 = 1U;
    __Vtask_alu_tb__DOT__check_result__a_21 = 0xffffffffU;
    __Vtask_alu_tb__DOT__check_result__operation_20 = 5U;
    vlSelfRef.alu_tb__DOT__alu_control = __Vtask_alu_tb__DOT__check_result__operation_20;
    vlSelfRef.alu_tb__DOT__operand_a = __Vtask_alu_tb__DOT__check_result__a_21;
    vlSelfRef.alu_tb__DOT__operand_b = __Vtask_alu_tb__DOT__check_result__b_22;
    co_await vlSelfRef.__Vnontrivs.__VdlySched.delay(1ULL, 
                                                     nullptr, 
                                                     "testbench/alu_tb.sv", 
                                                     33);
    vlSelfRef.__VtraceActivity[2U] = 1U;
    if (((vlSelfRef.alu_tb__DOT__dut__DOT__alu_result 
          == __Vtask_alu_tb__DOT__check_result__expected_23) 
         & ((0U == vlSelfRef.alu_tb__DOT__dut__DOT__alu_result) 
            == (0U == __Vtask_alu_tb__DOT__check_result__expected_23)))) {
        vlSelfRef.alu_tb__DOT__passed = ((::IData)(1U) 
                                         + vlSelfRef.alu_tb__DOT__passed);
        VL_WRITEF_NX("PASS | OP=%b | A=%h | B=%h | RESULT=%h\n",4
                     , '#',3,__Vtask_alu_tb__DOT__check_result__operation_20
                     , '#',32,__Vtask_alu_tb__DOT__check_result__a_21
                     , '#',32,__Vtask_alu_tb__DOT__check_result__b_22
                     , '#',32,vlSelfRef.alu_tb__DOT__dut__DOT__alu_result);
    } else {
        vlSelfRef.alu_tb__DOT__failed = ((::IData)(1U) 
                                         + vlSelfRef.alu_tb__DOT__failed);
        VL_WRITEF_NX("FAIL | OP=%b | EXPECTED=%h | ACTUAL=%h\n",3
                     , '#',3,__Vtask_alu_tb__DOT__check_result__operation_20
                     , '#',32,__Vtask_alu_tb__DOT__check_result__expected_23
                     , '#',32,vlSelfRef.alu_tb__DOT__dut__DOT__alu_result);
    }
    __Vtask_alu_tb__DOT__check_result__expected_27 = 0U;
    __Vtask_alu_tb__DOT__check_result__b_26 = 1U;
    __Vtask_alu_tb__DOT__check_result__a_25 = 0xffffffffU;
    __Vtask_alu_tb__DOT__check_result__operation_24 = 6U;
    vlSelfRef.alu_tb__DOT__alu_control = __Vtask_alu_tb__DOT__check_result__operation_24;
    vlSelfRef.alu_tb__DOT__operand_a = __Vtask_alu_tb__DOT__check_result__a_25;
    vlSelfRef.alu_tb__DOT__operand_b = __Vtask_alu_tb__DOT__check_result__b_26;
    co_await vlSelfRef.__Vnontrivs.__VdlySched.delay(1ULL, 
                                                     nullptr, 
                                                     "testbench/alu_tb.sv", 
                                                     33);
    vlSelfRef.__VtraceActivity[2U] = 1U;
    if (((vlSelfRef.alu_tb__DOT__dut__DOT__alu_result 
          == __Vtask_alu_tb__DOT__check_result__expected_27) 
         & ((0U == vlSelfRef.alu_tb__DOT__dut__DOT__alu_result) 
            == (0U == __Vtask_alu_tb__DOT__check_result__expected_27)))) {
        vlSelfRef.alu_tb__DOT__passed = ((::IData)(1U) 
                                         + vlSelfRef.alu_tb__DOT__passed);
        VL_WRITEF_NX("PASS | OP=%b | A=%h | B=%h | RESULT=%h\n",4
                     , '#',3,__Vtask_alu_tb__DOT__check_result__operation_24
                     , '#',32,__Vtask_alu_tb__DOT__check_result__a_25
                     , '#',32,__Vtask_alu_tb__DOT__check_result__b_26
                     , '#',32,vlSelfRef.alu_tb__DOT__dut__DOT__alu_result);
    } else {
        vlSelfRef.alu_tb__DOT__failed = ((::IData)(1U) 
                                         + vlSelfRef.alu_tb__DOT__failed);
        VL_WRITEF_NX("FAIL | OP=%b | EXPECTED=%h | ACTUAL=%h\n",3
                     , '#',3,__Vtask_alu_tb__DOT__check_result__operation_24
                     , '#',32,__Vtask_alu_tb__DOT__check_result__expected_27
                     , '#',32,vlSelfRef.alu_tb__DOT__dut__DOT__alu_result);
    }
    __Vtask_alu_tb__DOT__check_result__expected_31 = 0U;
    __Vtask_alu_tb__DOT__check_result__b_30 = 1U;
    __Vtask_alu_tb__DOT__check_result__a_29 = 0xffffffffU;
    __Vtask_alu_tb__DOT__check_result__operation_28 = 0U;
    vlSelfRef.alu_tb__DOT__alu_control = __Vtask_alu_tb__DOT__check_result__operation_28;
    vlSelfRef.alu_tb__DOT__operand_a = __Vtask_alu_tb__DOT__check_result__a_29;
    vlSelfRef.alu_tb__DOT__operand_b = __Vtask_alu_tb__DOT__check_result__b_30;
    co_await vlSelfRef.__Vnontrivs.__VdlySched.delay(1ULL, 
                                                     nullptr, 
                                                     "testbench/alu_tb.sv", 
                                                     33);
    vlSelfRef.__VtraceActivity[2U] = 1U;
    if (((vlSelfRef.alu_tb__DOT__dut__DOT__alu_result 
          == __Vtask_alu_tb__DOT__check_result__expected_31) 
         & ((0U == vlSelfRef.alu_tb__DOT__dut__DOT__alu_result) 
            == (0U == __Vtask_alu_tb__DOT__check_result__expected_31)))) {
        vlSelfRef.alu_tb__DOT__passed = ((::IData)(1U) 
                                         + vlSelfRef.alu_tb__DOT__passed);
        VL_WRITEF_NX("PASS | OP=%b | A=%h | B=%h | RESULT=%h\n",4
                     , '#',3,__Vtask_alu_tb__DOT__check_result__operation_28
                     , '#',32,__Vtask_alu_tb__DOT__check_result__a_29
                     , '#',32,__Vtask_alu_tb__DOT__check_result__b_30
                     , '#',32,vlSelfRef.alu_tb__DOT__dut__DOT__alu_result);
    } else {
        vlSelfRef.alu_tb__DOT__failed = ((::IData)(1U) 
                                         + vlSelfRef.alu_tb__DOT__failed);
        VL_WRITEF_NX("FAIL | OP=%b | EXPECTED=%h | ACTUAL=%h\n",3
                     , '#',3,__Vtask_alu_tb__DOT__check_result__operation_28
                     , '#',32,__Vtask_alu_tb__DOT__check_result__expected_31
                     , '#',32,vlSelfRef.alu_tb__DOT__dut__DOT__alu_result);
    }
    __Vtask_alu_tb__DOT__check_result__expected_35 = 0U;
    __Vtask_alu_tb__DOT__check_result__b_34 = 0x00000064U;
    __Vtask_alu_tb__DOT__check_result__a_33 = 0x00000064U;
    __Vtask_alu_tb__DOT__check_result__operation_32 = 1U;
    vlSelfRef.alu_tb__DOT__alu_control = __Vtask_alu_tb__DOT__check_result__operation_32;
    vlSelfRef.alu_tb__DOT__operand_a = __Vtask_alu_tb__DOT__check_result__a_33;
    vlSelfRef.alu_tb__DOT__operand_b = __Vtask_alu_tb__DOT__check_result__b_34;
    co_await vlSelfRef.__Vnontrivs.__VdlySched.delay(1ULL, 
                                                     nullptr, 
                                                     "testbench/alu_tb.sv", 
                                                     33);
    vlSelfRef.__VtraceActivity[2U] = 1U;
    if (((vlSelfRef.alu_tb__DOT__dut__DOT__alu_result 
          == __Vtask_alu_tb__DOT__check_result__expected_35) 
         & ((0U == vlSelfRef.alu_tb__DOT__dut__DOT__alu_result) 
            == (0U == __Vtask_alu_tb__DOT__check_result__expected_35)))) {
        vlSelfRef.alu_tb__DOT__passed = ((::IData)(1U) 
                                         + vlSelfRef.alu_tb__DOT__passed);
        VL_WRITEF_NX("PASS | OP=%b | A=%h | B=%h | RESULT=%h\n",4
                     , '#',3,__Vtask_alu_tb__DOT__check_result__operation_32
                     , '#',32,__Vtask_alu_tb__DOT__check_result__a_33
                     , '#',32,__Vtask_alu_tb__DOT__check_result__b_34
                     , '#',32,vlSelfRef.alu_tb__DOT__dut__DOT__alu_result);
    } else {
        vlSelfRef.alu_tb__DOT__failed = ((::IData)(1U) 
                                         + vlSelfRef.alu_tb__DOT__failed);
        VL_WRITEF_NX("FAIL | OP=%b | EXPECTED=%h | ACTUAL=%h\n",3
                     , '#',3,__Vtask_alu_tb__DOT__check_result__operation_32
                     , '#',32,__Vtask_alu_tb__DOT__check_result__expected_35
                     , '#',32,vlSelfRef.alu_tb__DOT__dut__DOT__alu_result);
    }
    __Vtask_alu_tb__DOT__check_result__expected_39 = 0U;
    __Vtask_alu_tb__DOT__check_result__b_38 = 0x00000014U;
    __Vtask_alu_tb__DOT__check_result__a_37 = 0x0000000aU;
    __Vtask_alu_tb__DOT__check_result__operation_36 = 7U;
    vlSelfRef.alu_tb__DOT__alu_control = __Vtask_alu_tb__DOT__check_result__operation_36;
    vlSelfRef.alu_tb__DOT__operand_a = __Vtask_alu_tb__DOT__check_result__a_37;
    vlSelfRef.alu_tb__DOT__operand_b = __Vtask_alu_tb__DOT__check_result__b_38;
    co_await vlSelfRef.__Vnontrivs.__VdlySched.delay(1ULL, 
                                                     nullptr, 
                                                     "testbench/alu_tb.sv", 
                                                     33);
    vlSelfRef.__VtraceActivity[2U] = 1U;
    if (((vlSelfRef.alu_tb__DOT__dut__DOT__alu_result 
          == __Vtask_alu_tb__DOT__check_result__expected_39) 
         & ((0U == vlSelfRef.alu_tb__DOT__dut__DOT__alu_result) 
            == (0U == __Vtask_alu_tb__DOT__check_result__expected_39)))) {
        vlSelfRef.alu_tb__DOT__passed = ((::IData)(1U) 
                                         + vlSelfRef.alu_tb__DOT__passed);
        VL_WRITEF_NX("PASS | OP=%b | A=%h | B=%h | RESULT=%h\n",4
                     , '#',3,__Vtask_alu_tb__DOT__check_result__operation_36
                     , '#',32,__Vtask_alu_tb__DOT__check_result__a_37
                     , '#',32,__Vtask_alu_tb__DOT__check_result__b_38
                     , '#',32,vlSelfRef.alu_tb__DOT__dut__DOT__alu_result);
    } else {
        vlSelfRef.alu_tb__DOT__failed = ((::IData)(1U) 
                                         + vlSelfRef.alu_tb__DOT__failed);
        VL_WRITEF_NX("FAIL | OP=%b | EXPECTED=%h | ACTUAL=%h\n",3
                     , '#',3,__Vtask_alu_tb__DOT__check_result__operation_36
                     , '#',32,__Vtask_alu_tb__DOT__check_result__expected_39
                     , '#',32,vlSelfRef.alu_tb__DOT__dut__DOT__alu_result);
    }
    VL_WRITEF_NX("\n========== TEST SUMMARY ==========\nPASSED: %0d\nFAILED: %0d\n",2
                 , '~',32,vlSelfRef.alu_tb__DOT__passed
                 , '~',32,vlSelfRef.alu_tb__DOT__failed);
    if (VL_LIKELY(((0U == vlSelfRef.alu_tb__DOT__failed)))) {
        VL_WRITEF_NX("ALU VERIFICATION SUCCESSFUL\n",0);
    } else {
        VL_WRITEF_NX("[%0t] %%Fatal: alu_tb.sv:104: Assertion failed in %m: ALU VERIFICATION FAILED\n",3, 'M',vlSymsp->__Vm_topNames[1].c_str(),"", 'T',-12
                     , '#',64,VL_TIME_UNITED_Q(1));
        VL_STOP_MT("testbench/alu_tb.sv", 104, "", false);
    }
    VL_FINISH_MT("testbench/alu_tb.sv", 106, "");
    vlSelfRef.__VtraceActivity[2U] = 1U;
    co_return;
}

bool Valu_tb___024root___trigger_anySet__ico(const ::VlUnpacked<::QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___trigger_anySet__ico\n"); );
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

bool Valu_tb___024root___trigger_anySet__act(const ::VlUnpacked<::QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___trigger_anySet__act\n"); );
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

void Valu_tb___024root___trigger_orInto__act_vec_vec(::VlUnpacked<::QData/*63:0*/, 1> &out, const ::VlUnpacked<::QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___trigger_orInto__act_vec_vec\n"); );
    // Locals
    ::IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = (out[n] | in[n]);
        n = ((::IData)(1U) + n);
    } while ((0U >= n));
}

void Valu_tb___024root___trigger_clear__act(::VlUnpacked<::QData/*63:0*/, 1> &out) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___trigger_clear__act\n"); );
    // Locals
    ::IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = 0ULL;
        n = ((::IData)(1U) + n);
    } while ((1U > n));
}

#ifdef VL_DEBUG
void Valu_tb___024root___eval_debug_assertions(Valu_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root___eval_debug_assertions\n"); );
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}
#endif  // VL_DEBUG
