// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Valu_tb.h for the primary calling header

#ifndef VERILATED_VALU_TB___024ROOT_H_
#define VERILATED_VALU_TB___024ROOT_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"


class Valu_tb__Syms;

class alignas(VL_CACHE_LINE_BYTES) Valu_tb___024root final {
  public:

    // TRIVIALLY CONSTRUCTIBLE STATE
    ::CData/*2:0*/ alu_tb__DOT__alu_control;
    ::IData/*31:0*/ alu_tb__DOT__operand_a;
    ::IData/*31:0*/ alu_tb__DOT__operand_b;
    ::IData/*31:0*/ alu_tb__DOT__passed;
    ::IData/*31:0*/ alu_tb__DOT__failed;
    ::IData/*31:0*/ alu_tb__DOT__dut__DOT__alu_result;
    ::IData/*31:0*/ __Vi;
    ::VlUnpacked<::QData/*63:0*/, 1> __VstlTriggered;
    ::VlUnpacked<::QData/*63:0*/, 1> __VicoTriggered;
    ::VlUnpacked<::QData/*63:0*/, 1> __VactTriggered;
    ::VlUnpacked<::QData/*63:0*/, 1> __VactTriggeredAcc;
    ::VlUnpacked<::QData/*63:0*/, 1> __VnbaTriggered;
    ::VlUnpacked<::CData/*0:0*/, 3> __VtraceActivity;

    // NOT TRIVIALLY CONSTRUCTIBLE STATE
    union {
        struct {
            ::VlDelayScheduler __VdlySched;
        } __Vnontrivs;
    };

    // INTERNAL VARIABLES
    Valu_tb__Syms* vlSymsp;
    const char* vlNamep;

    // CONSTRUCTORS
    Valu_tb___024root(Valu_tb__Syms* symsp, const char* namep);
    ~Valu_tb___024root();
    VL_UNCOPYABLE(Valu_tb___024root);
    VL_UNMOVABLE(Valu_tb___024root);

    // INTERNAL METHODS
};


#endif  // guard
