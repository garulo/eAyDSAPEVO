package com.ayd.dto;

import java.util.Date;

public class eAydObjDTO {

    private String Uid;
    private String email;
    private String password;
    private String IdSistema;
    private String montopagar;
    private String transactionId;
    private String vpc_MerchTxnRef;
    private String nispagardt;
    private String eAyd;
    private String eAydval;
    private Date date;

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

 

    public String geteAyd() {
        return eAyd;
    }

    public void seteAyd(String eAyd) {
        this.eAyd = eAyd;
    }

    public String geteAydval() {
        return eAydval;
    }

    public void seteAydval(String eAydval) {
        this.eAydval = eAydval;
    }

    public String getUid() {
        return Uid;
    }

    public void setUid(String Uid) {
        this.Uid = Uid;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getIdSistema() {
        return IdSistema;
    }

    public void setIdSistema(String IdSistema) {
        this.IdSistema = IdSistema;
    }

    public String getMontopagar() {
        return montopagar;
    }

    public void setMontopagar(String montopagar) {
        this.montopagar = montopagar;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    public String getVpc_MerchTxnRef() {
        return vpc_MerchTxnRef;
    }

    public void setVpc_MerchTxnRef(String vpc_MerchTxnRef) {
        this.vpc_MerchTxnRef = vpc_MerchTxnRef;
    }

    public String getNispagardt() {
        return nispagardt;
    }

    public void setNispagardt(String nispagardt) {
        this.nispagardt = nispagardt;
    }

}
