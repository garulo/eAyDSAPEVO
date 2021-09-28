<%@page import="com.ayd.dto.addeAydObjLst"%>
<%@page import="java.util.Date"%>
<%@page import="com.ayd.dto.eAydObjLst"%>
<%@page import="java.io.FileWriter"%>
<%@page import="com.ayd.dto.eAydObjDTO"%>
<%@page import="java.util.Properties"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="org.json.JSONException"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.math.BigInteger"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    HttpSession objSession = request.getSession(false);
    String usuario = (String) objSession.getAttribute("usuario");
    String pass = (String) objSession.getAttribute("password");
    eAydObjDTO objDTO = new eAydObjDTO();
    objDTO.setEmail(usuario);
    objDTO.setPassword(pass);
    Date objDate = new Date(); 
    //System.out.println("objDate " +objDate.toString());
    Long l = objDate.getTime();
    objDTO.setDate(objDate);
    
    
    %>


<%
    //System.out.println("usuario QBController sesion:: " + usuario);
    String nombreusuario = (String) objSession.getAttribute("nombreusuario");
    String token = (String) objSession.getAttribute("token");
    if (null == usuario) {
        System.out.println("success HttpSession FALSE:::::");
        out.println("<script type=\"text/javascript\">");
        out.println("window.parent.location.href='sweetAlert.html'");
        out.println("</script>");
    } else if (usuario.equals("")) {
        System.out.println("success HttpSession FALSE:::::");
        out.println("<script type=\"text/javascript\">");
        out.println("window.parent.location.href='sweetAlert.html'");
        out.println("</script>");
    } else {
        InputStream isArchivo = new FileInputStream((String) objSession.getAttribute("urlProperties"));
        Properties oProperties = new Properties();
        oProperties.load(isArchivo);
        String nispagardt = (String)session.getAttribute("nispagardt");
        objDTO.setNispagardt(nispagardt);

        final String SECURE_SECRET = oProperties.getProperty("SECURE_SECRET");
        final String ORIGIN = oProperties.getProperty("ORIGIN");
        final String AFFLILIATION_NUMBER = oProperties.getProperty("AFFLILIATION_NUMBER");
        final String JIDUU_ID = oProperties.getProperty("JIDUU_ID");
       
       
        final String URL_REQUEST = oProperties.getProperty("URL_REQUEST");
        final String PLACE_ID = oProperties.getProperty("PLACE_ID");
        final String message = new String();

%>
<%    String EMAIL_USER = (String) objSession.getAttribute("usuario");
    String AMOUNT = (String) objSession.getAttribute("montopagar");
    String vpc_MerchTxnRef =(String)session.getAttribute("vpc_MerchTxnRef");
    objDTO.setVpc_MerchTxnRef(vpc_MerchTxnRef);
    objDTO.setMontopagar(AMOUNT);
    
    //String AMOUNT = "0.20";
    //System.out.println("EMAIL_USER:: " + EMAIL_USER + " AMOUNT:: " + AMOUNT);
    String transactionId = (String) objSession.getAttribute("transactionId");
     final String URL_RESPONSE = oProperties.getProperty("URL_RESPONSE")+transactionId;
     //System.out.println("transactionId controller :::: "+transactionId);
    objDTO.setUid(transactionId);
    objDTO.setTransactionId((String) objSession.getAttribute("transactionId"));
   
    String value = transactionId + AMOUNT + ORIGIN + PLACE_ID + AFFLILIATION_NUMBER + JIDUU_ID + EMAIL_USER + URL_RESPONSE;
    String sha1 = new String();
    try {
        MessageDigest digest = MessageDigest.getInstance("SHA-1");
        digest.reset();
        digest.update(value.getBytes("utf8"));
        sha1 = String.format("%040x", new BigInteger(1, digest.digest()));
    } catch (Exception e) {
        e.printStackTrace();
    }
String password = (String) objSession.getAttribute("password");
objDTO.setPassword(password);
    //Mapeado de sesión
    //Mapeado eAydObjDTO de sesión
    
     eAydObjLst.lstDTO.add(objDTO);
     //System.out.println("iteracion objDTOs lst "+objDTO.getUid()+" / "+objDTO.getEmail());
for(eAydObjDTO o:eAydObjLst.lstDTO){
//System.out.println("iteracion lst "+o.getUid()+" / "+o.getEmail());
}
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta content = "default-src 'self' *. qbitspay.com data: 'unsafe- inline '' unsafe-eval '"http-equiv =" Content-Security-Policy "/>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
        <meta charset="UTF-8">
        <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">
        <title>Loading...</title>
        <link href=\"archivos/uploaded_files/5b1ddbe400c01d95eb9dd383_IconoSADM.png\" rel=\"shortcut icon\" type=\"image/x-icon\" />
        <link href=\"archivos/uploaded_files/5b6afb8e41c61684eb69bcee_logo_sadm_color.png\" rel=\"apple-touch-icon\" />
        <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
    </head>
    <body onload="document.getElementById('formEnviar').submit();" xmlns:th="http://www.thymeleaf.org">

        <div style="width: 100%">
            <div >
                 <%
                System.out.println(":: POST DE PAGO FORM :: ");
                System.out.println("URLREQUEST PAGO:: "+URL_REQUEST);
                System.out.println("URLREQUEST transactionId "+transactionId);
                System.out.println("URLREQUEST AMOUNT:: "+AMOUNT);
                System.out.println("URLREQUEST ORIGIN:: "+ORIGIN);
                System.out.println("URLREQUEST PLACE_ID:: "+PLACE_ID);
                System.out.println("URLREQUEST AFFLILIATION_NUMBER:: "+AFFLILIATION_NUMBER);
                System.out.println("URLREQUEST JIDUU_ID:: "+JIDUU_ID);
                System.out.println("URLREQUEST EMAIL_USER:: "+EMAIL_USER);
                System.out.println("URLREQUEST URL_RESPONSE:: "+URL_RESPONSE);
                System.out.println("URLREQUEST wantAsave:: false");
                System.out.println("URLREQUEST push:: false");
                System.out.println("URLREQUEST digest:: "+sha1);
                System.out.println(":: POST DE PAGO FORM :: ");
                 %>
                <form action="<%=URL_REQUEST%>" id="formEnviar"  method="POST" hidden>
                    <div>
                        <input type="text" class="form-control" value="<%=transactionId%>" id="transactionId" name="transactionId" readonly>
                         <!--<input type="text" class="form-control" value="20e90958-cb24-4596-9eb9-f1a80c2d942e9520" id="transactionId" name="transactionId" readonly>-->
                    </div>
                    <div>
                        <input type="text" class="form-control" value="<%=AMOUNT%>" id="amount" name="amount" readonly>
                    </div>
                    <div>
                        <input type="text" class="form-control" id="origin" value="<%=ORIGIN%>" name="origin"  readonly>
                    </div>
                    <div>
                        <input type="text" class="form-control" id="placeId" value="<%=PLACE_ID%>" name="placeId" readonly>
                    </div>
                    <div>
                        <input type="text" class="form-control" id="affiliationNumber" value="<%=AFFLILIATION_NUMBER%>" name="affiliationNumber" readonly>
                    </div>
                    <div>
                        <input type="text" class="form-control" id="jidUuId" value="<%=JIDUU_ID%>" name="jidUuId" readonly>
                    </div>
                    <div>
                        <input type="text" class="form-control" id="email" value="<%=EMAIL_USER%>" name="email" readonly>
                    </div>
                    <div>
                        <input type="text" class="form-control" id="urlResponse" value="<%=URL_RESPONSE%>" name="urlResponse" readonly>
                    </div>
                    <div>
                        <input type="checkbox" class="form-control" id="wantAsave" value="false" checked ="false" name="wantAsave" checked readonly hidden>
                    </div>
                    <div>
                        <input type="checkbox" class="form-control" id="push" value="false" checked ="false" name="push" checked readonly hidden>
                    </div>
                    <div>
                        <input type="text" class="form-control" id="digest" name="digest" value="<%=sha1%>" readonly>
                    </div>
                    <div>
                        <button type="submit" class="btn btn-success" id="PayOn" name="PayOn">Pagar (Proceso de Pago)</button>
                    </div>
                </form>

                <br><br><br><br>
                <br><br><br><br>
                <br><br><br><br>
                <br><br><br><br>
                <center>
                    <div class="spinner-border text-primary" style="width: 15rem; height: 15rem;" role="status">
                        <span class="sr-only">Loading...</span>
                    </div>
                </center>

            </div>
        </div>

    </body>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/gh/emn178/js-sha1/build/sha1.min.js"></script>

</html>
<%}%>