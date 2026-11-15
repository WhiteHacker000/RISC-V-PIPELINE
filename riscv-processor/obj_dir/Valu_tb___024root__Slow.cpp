// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Valu_tb.h for the primary calling header

#include "Valu_tb__pch.h"

void Valu_tb___024root___ctor_var_reset(Valu_tb___024root* vlSelf);

void Valu_tb___024root__ctor(Valu_tb___024root* vlSelf, Valu_tb__Syms* symsp, const char* namep) {
    vlSelf->vlSymsp = symsp;
    vlSelf->vlNamep = strdup(namep);
    // Construct members
    VL_INPLACE_CONSTRUCT(vlSelf->__Vnontrivs.__VdlySched, *vlSelf->vlSymsp->_vm_contextp__);
    // Reset structure values
    Valu_tb___024root___ctor_var_reset(vlSelf);
}

Valu_tb___024root::Valu_tb___024root(Valu_tb__Syms* symsp, const char* namep) {
    Valu_tb___024root__ctor(this, symsp, namep);
}

void Valu_tb___024root__dtor(Valu_tb___024root* vlSelf) {
    // Destroy members
    VL_INPLACE_DESTRUCT(vlSelf->__Vnontrivs.__VdlySched);
    VL_DO_DANGLING(std::free(const_cast<char*>(vlSelf->vlNamep)), vlSelf->vlNamep);
}

Valu_tb___024root::~Valu_tb___024root() {
    Valu_tb___024root__dtor(this);
}
