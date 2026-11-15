// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals

#include "verilated_vcd_c.h"
#include "Valu_tb__Syms.h"


void Valu_tb___024root__trace_chg_0_sub_0(Valu_tb___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Valu_tb___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root__trace_chg_0\n"); );
    // Body
    Valu_tb___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Valu_tb___024root*>(voidSelf);
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    Valu_tb___024root__trace_chg_0_sub_0((&vlSymsp->vlInst.TOP), bufp);
}

void Valu_tb___024root__trace_chg_0_sub_0(Valu_tb___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root__trace_chg_0_sub_0\n"); );
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 0);
    if (VL_UNLIKELY(((vlSelfRef.__VtraceActivity[1U] 
                      | vlSelfRef.__VtraceActivity[2U])))) {
        bufp->chgIData(oldp+0,(vlSelfRef.alu_tb__DOT__operand_a),32);
        bufp->chgIData(oldp+1,(vlSelfRef.alu_tb__DOT__operand_b),32);
        bufp->chgCData(oldp+2,(vlSelfRef.alu_tb__DOT__alu_control),3);
        bufp->chgIData(oldp+3,(((4U & (::IData)(vlSelfRef.alu_tb__DOT__alu_control))
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
                                            + vlSelfRef.alu_tb__DOT__operand_b))))),32);
        bufp->chgBit(oldp+4,((0U == ((4U & (::IData)(vlSelfRef.alu_tb__DOT__alu_control))
                                      ? ((2U & (::IData)(vlSelfRef.alu_tb__DOT__alu_control))
                                          ? (1U & (- (::IData)(
                                                               ((~ (::IData)(vlSelfRef.alu_tb__DOT__alu_control)) 
                                                                & (vlSelfRef.alu_tb__DOT__operand_a 
                                                                   < vlSelfRef.alu_tb__DOT__operand_b)))))
                                          : ((1U & (::IData)(vlSelfRef.alu_tb__DOT__alu_control))
                                              ? (1U 
                                                 & (- (::IData)(
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
                                                 + vlSelfRef.alu_tb__DOT__operand_b)))))));
        bufp->chgIData(oldp+5,(vlSelfRef.alu_tb__DOT__passed),32);
        bufp->chgIData(oldp+6,(vlSelfRef.alu_tb__DOT__failed),32);
    }
}

void Valu_tb___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root__trace_cleanup\n"); );
    // Body
    Valu_tb___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Valu_tb___024root*>(voidSelf);
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    vlSymsp->__Vm_activity = false;
    vlSymsp->vlInst.TOP.__VtraceActivity[0U] = 0U;
    vlSymsp->vlInst.TOP.__VtraceActivity[1U] = 0U;
    vlSymsp->vlInst.TOP.__VtraceActivity[2U] = 0U;
}
