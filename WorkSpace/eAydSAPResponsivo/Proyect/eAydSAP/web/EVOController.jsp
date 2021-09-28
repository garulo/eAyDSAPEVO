<%@page import="java.io.UnsupportedEncodingException"%>
<%@page import="java.util.Base64"%>
<%@page import="java.io.IOException"%>
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


<%    //System.out.println("usuario QBController sesion:: " + usuario);
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
        String jsonObjcreasesionevoresponsedatasessionid = new String();
        String  jsonObjcreasesionevoresponsedatamerchant = new String();
        InputStream isArchivo = new FileInputStream((String) objSession.getAttribute("urlProperties"));
        Properties oProperties = new Properties();
        oProperties.load(isArchivo);
        String nispagardt = (String) session.getAttribute("nispagardt");
        objDTO.setNispagardt(nispagardt);

        String AMOUNT = (String) objSession.getAttribute("montopagar");

        final String CREASESIONEVO = oProperties.getProperty("CREASESIONEVO");
        
        
        
        
        URL urlcreasesionevo = new URL(CREASESIONEVO);
        System.out.println("urlcreasesionevo :: " + urlcreasesionevo);


//TODO
//


        HttpURLConnection concreasesionevo = (HttpURLConnection) urlcreasesionevo.openConnection();
        concreasesionevo.setRequestMethod("POST");
        concreasesionevo.setRequestProperty("Content-Type", "application/json; utf-8");
        concreasesionevo.setDoOutput(true);
        concreasesionevo.setRequestProperty("Authorization", "Bearer " + token);

        String jsonInputStringcreasesionevo = "{\n"
                + "  \"P_monto\": \"" + AMOUNT + "\"\n"
                + "}";
        System.out.println("jsonInputStringCREASESIONEVO ::: " + jsonInputStringcreasesionevo);

        try (OutputStream osconcreasesionevo = concreasesionevo.getOutputStream()) {
            byte[] inputcreasesionevo = jsonInputStringcreasesionevo.getBytes("utf-8");
            osconcreasesionevo.write(inputcreasesionevo, 0, inputcreasesionevo.length);
        }

        try (BufferedReader bdataconcreasesionevo = new BufferedReader(
                new InputStreamReader(concreasesionevo.getInputStream(), "utf-8"))) {
            String jsondataconcreasesionevo = new String();
            InputStream inputStreamdatacreasesionevo = concreasesionevo.getInputStream();
            BufferedReader bufferedReaderdatacreasesionevo = new BufferedReader(new InputStreamReader(inputStreamdatacreasesionevo), 1);
            String lineuserdatacreasesionevo;
            while ((lineuserdatacreasesionevo = bufferedReaderdatacreasesionevo.readLine()) != null) {
                jsondataconcreasesionevo = lineuserdatacreasesionevo;
            }
            System.out.println("jsondata CREASESIONEVO::: " + objDate + " / " + jsondataconcreasesionevo);
            inputStreamdatacreasesionevo.close();
            bufferedReaderdatacreasesionevo.close();
            JSONObject jsonObjdatacreasesionevo = new JSONObject(jsondataconcreasesionevo);

            if (jsonObjdatacreasesionevo.get("success").toString() == "true") {
                String msg = jsonObjdatacreasesionevo.get("message").toString();
                msg = msg.replace("Ã±", "ñ");
                System.out.println("success service CREASESIONEVO TRUE::::: " + objDate + " / " + msg + " / " + msg);
                if ("null" != jsonObjdatacreasesionevo.get("Response").toString()) {
                    JSONObject jsonObjcreasesionevoresponse = new JSONObject(jsonObjdatacreasesionevo.get("Response").toString());
                    JSONObject jsonObjcreasesionevoresponsedata = new JSONObject(jsonObjcreasesionevoresponse.get("data").toString());
                    String jsonObjcreasesionevoresponseref = jsonObjcreasesionevoresponse.get("REF").toString();

                    JSONObject jsonObjcreasesionevoresponsedatasession = new JSONObject(jsonObjcreasesionevoresponsedata.get("session").toString());
                    jsonObjcreasesionevoresponsedatamerchant = jsonObjcreasesionevoresponsedata.get("merchant").toString();
                   
                    jsonObjcreasesionevoresponsedatasessionid = jsonObjcreasesionevoresponsedatasession.get("id").toString();
                    String jsonObjcreasesionevoresponsesessionsuccessIndicator = jsonObjcreasesionevoresponsedata.get("successIndicator").toString();
                    System.out.println("successIndicator :  " + jsonObjcreasesionevoresponsesessionsuccessIndicator);
//                    System.out.println("jsonObjcreasesionevoresponseref :  " + jsonObjcreasesionevoresponseref);
                    String respuesta = "error";
                    try {
                        respuesta = new String(Base64.getDecoder().decode(jsonObjcreasesionevoresponseref.getBytes("UTF8")), "UTF-8");
                    } catch (UnsupportedEncodingException e) {
                        e.printStackTrace();
                    }
                    byte[] bytesDecodificadosref = Base64.getDecoder().decode(jsonObjcreasesionevoresponseref);
                    String cadenaDecodificadaref = new String(bytesDecodificadosref);

//                    System.out.println("decodificado: " + cadenaDecodificadaref);
//                    System.out.println("HTML REF64 :  " + respuesta);
                    

                }

            } else {
                String msg = jsonObjdatacreasesionevo.get("message").toString();
                msg = msg.replace("Ã±", "ñ");
                System.out.println("success service CREASESIONEVO FALSE:::::" + objDate + " / " + msg + " / " + msg);
                response.sendRedirect("sweetAlertError500.html");

            }
        } catch (JSONException ex) {
            System.out.println("success service CREASESIONEVO ERROR::::: " + objDate + " / " + ex + " / " + ex);
            response.sendRedirect("sweetAlertError500.html");
        }

        final String SESIONCHECKOUTEVO = oProperties.getProperty("SESIONCHECKOUT");

        final String message = new String();

        String EMAIL_USER = (String) objSession.getAttribute("usuario");
        String vpc_MerchTxnRef = (String) session.getAttribute("vpc_MerchTxnRef");
        objDTO.setVpc_MerchTxnRef(vpc_MerchTxnRef);
        objDTO.setMontopagar(AMOUNT);

        String transactionId = (String) objSession.getAttribute("transactionId");
        objDTO.setUid(transactionId);
        objDTO.setTransactionId((String) objSession.getAttribute("transactionId"));

        String password = (String) objSession.getAttribute("password");
        objDTO.setPassword(password);
        eAydObjLst.lstDTO.add(objDTO);
        
        //System.out.println("iteracion objDTOs lst "+objDTO.getUid()+" / "+objDTO.getEmail());
        for (eAydObjDTO o : eAydObjLst.lstDTO) {
//System.out.println("iteracion lst "+o.getUid()+" / "+o.getEmail());
        }

//NATIVE IMPLEMENT EVO 61

        final String EVOCHECKOUT = oProperties.getProperty("EVOCHECKOUT");
        

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
         <%@ include file="HeaderOptions.jsp" %>
        <title>Pagos SADM</title>
        <link href=\"archivos/uploaded_files/5b1ddbe400c01d95eb9dd383_IconoSADM.png\" rel=\"shortcut icon\" type=\"image/x-icon\" />
        <link href=\"archivos/uploaded_files/5b6afb8e41c61684eb69bcee_logo_sadm_color.png\" rel=\"apple-touch-icon\" />
        <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
        <script src="https://evopaymentsmexico.gateway.mastercard.com/checkout/version/61/checkout.js" data-error="errorCallback" data-cancel="cancelCallback"></script>
        <script type="text/javascript">
            function errorCallback(error) {
                console.log(JSON.stringify(error));
            }
            function cancelCallback() {
                console.log('Payment cancelled');
            }
            Checkout.configure({
                session: {
                    id: '<%=jsonObjcreasesionevoresponsedatasessionid%>'
                },
                interaction: {
                    merchant: {
                        name: '<%=jsonObjcreasesionevoresponsedatamerchant%>',
                        address: {
                            line1: '200 Sample St',
                            line2: '1234 Example Town'
                        }
                    }
                }
            });
        </script>
    </head>
    <body  >
<%@include file="Top.jsp" %>
         <div style="margin-top: 20%;">
	
        
		<center><img src='imagenes/logo_transp.gif'></br>
       ...
       <input class="btn btn-outline-secondary" type="button" value="Pagar" onclick="Checkout.showLightbox();" />
      <input class="btn btn-outline-secondary" type="button" value="Pay with Payment Page" onclick="Checkout.showPaymentPage();" />
       ...
                </center>
        </div>
<%@include file="Bottom.jsp" %>
    </body>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/gh/emn178/js-sha1/build/sha1.min.js"></script>

</html>
<%}%>