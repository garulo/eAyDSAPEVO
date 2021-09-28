package com.ayd.dao;

public class SwitchLoginDTO {

    private static String detenerLogin = "false";
    private static String fchStop;

    public String getDetenerLogin() {
        return detenerLogin;
    }

    public void setDetenerLogin(String detenerLogin) {
        this.detenerLogin = detenerLogin;
    }

    public SwitchLoginDTO() {
    }

    public static String getFchStop() {
        return fchStop;
    }

    public static void setFchStop(String fchStop) {
        SwitchLoginDTO.fchStop = fchStop;
    }

}
