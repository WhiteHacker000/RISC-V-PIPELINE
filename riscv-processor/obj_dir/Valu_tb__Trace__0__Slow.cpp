// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals

#include "verilated_vcd_c.h"
#include "Valu_tb__Syms.h"


VL_ATTR_COLD void Valu_tb___024root__trace_init_sub__TOP__0(Valu_tb___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root__trace_init_sub__TOP__0\n"); );
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const int c = vlSymsp->__Vm_baseCode;
    VL_TRACE_PUSH_PREFIX(tracep, "alu_tb", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+0,0,"operand_a",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+1,0,"operand_b",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+2,0,"alu_control",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 2,0);
    VL_TRACE_DECL_BUS(tracep,c+3,0,"alu_result",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BIT(tracep,c+4,0,"zero",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+5,0,"passed",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INTEGER, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+6,0,"failed",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INTEGER, 31,0);
    VL_TRACE_PUSH_PREFIX(tracep, "dut", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+0,0,"operand_a",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+1,0,"operand_b",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+2,0,"alu_control",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 2,0);
    VL_TRACE_DECL_BUS(tracep,c+3,0,"alu_result",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BIT(tracep,c+4,0,"zero",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_POP_PREFIX(tracep);
}

VL_ATTR_COLD void Valu_tb___024root__trace_init_top(Valu_tb___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root__trace_init_top\n"); );
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Valu_tb___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Valu_tb___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
VL_ATTR_COLD void Valu_tb___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Valu_tb___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Valu_tb___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Valu_tb___024root__trace_register(Valu_tb___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root__trace_register\n"); );
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    tracep->addConstCb(&Valu_tb___024root__trace_const_0, 0, vlSelf);
    tracep->addFullCb(&Valu_tb___024root__trace_full_0, 0, vlSelf);
    tracep->addChgCb(&Valu_tb___024root__trace_chg_0, 0, vlSelf);
    tracep->addCleanupCb(&Valu_tb___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Valu_tb___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root__trace_const_0\n"); );
    // Body
    Valu_tb___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Valu_tb___024root*>(voidSelf);
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
}

VL_ATTR_COLD void Valu_tb___024root__trace_full_0_sub_0(Valu_tb___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Valu_tb___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root__trace_full_0\n"); );
    // Body
    Valu_tb___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Valu_tb___024root*>(voidSelf);
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    Valu_tb___024root__trace_full_0_sub_0((&vlSymsp->vlInst.TOP), bufp);
}

VL_ATTR_COLD void Valu_tb___024root__trace_full_0_sub_0(Valu_tb___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu_tb___024root__trace_full_0_sub_0\n"); );
    Valu_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    bufp->fullIData(oldp+0,(vlSelfRef.alu_tb__DOT__operand_a),32);
    bufp->fullIData(oldp+1,(vlSelfRef.alu_tb__DOT__operand_b),32);
    bufp->fullCData(oldp+2,(vlSelfRef.alu_tb__DOT__alu_control),3);
    bufp->fullIData(oldp+3,(((4U & (::IData)(vlSelfRef.alu_tb__DOT__alu_control))
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
    bufp->fullBit(oldp+4,((0U == ((4U & (::IData)(vlSelfRef.alu_tb__DOT__alu_control))
                                   ? ((2U & (::IData)(vlSelfRef.alu_tb__DOT__alu_control))
                                       ? (1U & (- (::IData)(
                                                            ((~ (::IData)(vlSelfRef.alu_tb__DOT__alu_control)) 
                                                             & (vlSelfRef.alu_tb__DOT__operand_a 
                                                                < vlSelfRef.alu_tb__DOT__operand_b)))))
                                       : ((1U & (::IData)(vlSelfRef.alu_tb__DOT__alu_control))
                                           ? (1U & 
                                              (- (::IData)(
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
    bufp->fullIData(oldp+5,(vlSelfRef.alu_tb__DOT__passed),32);
    bufp->fullIData(oldp+6,(vlSelfRef.alu_tb__DOT__failed),32);
}
