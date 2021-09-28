<%@page import="sun.rmi.transport.proxy.CGIHandler"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.ayd.dao.SwitchLoginDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.ayd.dao.RutaProperties"%>
<%@page import="com.ayd.dto.eAydObjLst"%>
<%@page import="com.ayd.beans.eAydObj"%>
<%@page import="com.ayd.dto.addeAydObjLst"%>
<%@page import="com.ayd.servlet.Autenticacion"%>
<%@page import="com.ayd.dto.eAydObjDTO"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.util.logging.Formatter"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="com.ayd.dao.ServicioNISDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.security.MessageDigest"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%

    System.out.println("eAydObjLst.lstDTO.isEmpty():: " + eAydObjLst.lstDTO.isEmpty());
    ArrayList<eAydObjDTO> lstDTO;
    lstDTO = eAydObjLst.lstDTO;
    eAydObjDTO eAydObj = new eAydObjDTO();
    RutaProperties rp = new RutaProperties();
    String urlProperties = rp.getRuta();
    String responseCode = request.getParameter("responseCode");
    Date fechaactual = new Date();
    //System.out.println("session user result:::" + session.getAttribute("usuario"));

    //System.out.println("request.getParameter(\"prosaCode\") : " + request.getParameter("prosaCode"));
    String transactionIdentifier = request.getParameter("uid");
    boolean eliminarDeLista = false;
    System.out.println("::Response pago:::" + transactionIdentifier);
    System.out.println("::transactionIdentifier url::: " + transactionIdentifier + "eliminar de la lista :: " + eliminarDeLista);

    System.out.println("trnsaction id qbits:" + request.getParameter("transactionIdentifier"));
    System.out.println("::Response pago:::");
    System.out.println("responseCode: " + request.getParameter("responseCode"));
    System.out.println("message: " + request.getParameter("message"));
    System.out.println("prosaCode: " + request.getParameter("prosaCode"));
    System.out.println("traceNumber: " + request.getParameter("messageObject[traceNumber]"));
    System.out.println("authorizationCode: " + request.getParameter("messageObject[authorizationCode]"));
    System.out.println("amount: " + request.getParameter("traceNumber[amount]"));
    System.out.println("cardDigits: " + request.getParameter("messageObject[cardDigits]"));
    System.out.println("bin: " + request.getParameter("messageObject[bin]"));
    System.out.println("affiliationNumber: " + request.getParameter("messageObject[affiliationNumber]"));
    System.out.println("transactionIdentifier: " + request.getParameter("transactionIdentifier"));
    System.out.println("transactionDate: " + request.getParameter("transactionDate"));
    System.out.println("transactionTime: " + request.getParameter("transactionTime"));
    System.out.println("::Response pago:::" + transactionIdentifier);
    String respuesta = new String();
    String StatusProsaCode = request.getParameter("prosaCode");
    String StatusMessage = new String();
    StatusMessage = request.getParameter("message");
    String StatusAuthorizationCode = request.getParameter("messageObject[authorizationCode]");
    InputStream isArchivo = new FileInputStream(urlProperties);
    Properties oProperties = new Properties();
    String respuestacancelado = new String();
    oProperties.load(isArchivo);
    int index = 0;

    for (eAydObjDTO eAydObjDTO : eAydObjLst.lstDTO) {
        //System.out.println("::eAydObjDTO.getUid() for::: " + eAydObjDTO.getUid());
        if (transactionIdentifier.equalsIgnoreCase(eAydObjDTO.getUid())) {
            eAydObj = new eAydObjDTO();
            eAydObj.setEmail(eAydObjDTO.getEmail());

            eAydObj.setMontopagar(eAydObjDTO.getMontopagar());
            eAydObj.setNispagardt(eAydObjDTO.getNispagardt());
            eAydObj.setPassword(eAydObjDTO.getPassword());
            eAydObj.setTransactionId(eAydObjDTO.getTransactionId());
            eAydObj.setUid(eAydObjDTO.getTransactionId());
            eAydObj.setVpc_MerchTxnRef(eAydObjDTO.getVpc_MerchTxnRef());
            // System.out.println("::eAydObjDTO.getUid() ecuals list::: " + eAydObjDTO.getUid() + "email: " + eAydObj.getEmail());
            //ELiminar dela lista
            //respuesta = "Error de Pago";

        } else {
            //System.out.println("transaccion id con el de la lista  no coincide  " + transactionIdentifier + " / " + eAydObjDTO.getUid());

        }

    }
    int bound = eAydObjLst.lstDTO.size();
//     System.out.println(" :: bound :: "+bound)

    ArrayList ObjLts = new ArrayList(eAydObjLst.lstDTO);
    Iterator<eAydObjDTO> it1 = ObjLts.iterator();
    int cont = -1;
    try {
        while (it1.hasNext()) {
            cont = cont + 1;
            eAydObjDTO tmp = it1.next();
            //System.out.println("index: " + cont);
            if (tmp.getUid().equals(transactionIdentifier)) {
                System.out.println("La cuenta:" + tmp.getEmail() + "tiene id:" + tmp.getUid());
                index = cont;
//            System.out.println("transaccion id  existe :: " + index+"");
                break;
            } else {
                //System.out.println("transaccion id con el de la lista almacenada  no existe");
            }
        }
    } catch (Exception ex) {
        //ex.printStackTrace();
        System.out.println("falla en calculo de lista se envía al inicio.:::");

        SwitchLoginDTO sg = new SwitchLoginDTO();
        sg.setDetenerLogin("true");
        response.sendRedirect("sweetAlert.html");
    }

//     try{
//    for (int userInd = 0; userInd < bound; userInd++) {
//        System.out.println("userInd :: " + userInd+"");
//        if (eAydObjLst.lstDTO.get(userInd).getUid().equals(transactionIdentifier)) {
//            index = userInd;
////            System.out.println("transaccion id  existe :: " + index+"");
//            break;
//        } else {
//            // System.out.println("transaccion id con el de la lista almacenada  no existe");
//        }
//    }}catch(Exception ex){
//    ex.printStackTrace();
//    System.out.println("falla en calculo de lista se envía al inicio.:::");
//    eAydObjLst eAydObjLst = new eAydObjLst();
//    response.sendRedirect("Login.jsp");
//    }
    if (null == session.getAttribute("usuario")) {
        //System.out.println("transactionIdentifier::" + transactionIdentifier);

        HttpSession objSession = request.getSession(true);

        String LOGINZ = oProperties.getProperty("LOGIN");
        URL urlz = new URL(LOGINZ + eAydObj.getEmail() + "&Password=" + eAydObj.getPassword() + "&IdSistema=eAyd");
        //System.out.println("url :: " + urlz);
        HttpURLConnection conn = (HttpURLConnection) urlz.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Accept", "application/json");
        if (conn.getResponseCode() != 200) {
            response.sendRedirect("Login.jsp");
            response.sendRedirect("sweetAlertAutenticaciónError.html");
            //throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());

        } else {

            try {

                InputStream inputStream = conn.getInputStream();
                String json = new String();
                BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream), 1);
                String line;
                while ((line = bufferedReader.readLine()) != null) {
                    json = line;
                }
                inputStream.close();
                bufferedReader.close();
                //System.out.println("json ::: " + json);
                JSONObject jsonObj = new JSONObject(json);
                //System.out.println("::jsonObj.get(\"Response\").toString():: "+jsonObj.get("Response").toString());
                if ("null" != jsonObj.get("Response").toString()) {
                    JSONObject jsonObjloginresponse = new JSONObject(jsonObj.get("Response").toString());
                    JSONObject jsonObjloginresponsedata = new JSONObject(jsonObjloginresponse.get("data").toString());
                    JSONObject jsonObjloginresponsedatauser = new JSONObject(jsonObjloginresponsedata.get("Usuario").toString());
                    String tokenlogin = jsonObjloginresponsedata.get("Token").toString();
                    String username = jsonObjloginresponsedatauser.get("StrNombre").toString() + " " + jsonObjloginresponsedatauser.get("StrApellidoPaterno").toString() + " " + jsonObjloginresponsedatauser.get("StrApellidoMaterno").toString();

                    if (jsonObj.get("success").toString() == "true") {
                        System.out.println("success LOGIN TRUE session null::::: " + eAydObj.getEmail());
                        HttpSession objSessionzz = request.getSession(true);
                        objSession.setAttribute("usuario", eAydObj.getEmail());
                        objSession.setAttribute("token", tokenlogin);
                        objSession.setAttribute("password", eAydObj.getPassword());
                        objSession.setAttribute("nombreusuario", username);

                        String token = (String) objSessionzz.getAttribute("token");
                        System.out.println("success LOGIN TRUE session null::::: 0" + session.getAttribute("usuario"));
//                        out.println("<script type=\"text/javascript\">");
//                        out.println("window.parent.location.href='sweetAlertqbitspay.html'");
//                        out.println("</script>");

                    }
                }
            } catch (IOException ioe) {
                System.out.println("IOExceptionLOGIN ::::: " + ioe + " ////  " + session.getAttribute("usuario"));
                //Logger.getLogger(Autenticacion.class.getName()).log(Level.SEVERE, null, ioe);
            } catch (JSONException ex) {
                System.out.println("JSONExceptionLOGIN ::::: " + ex + " ////  " + session.getAttribute("usuario"));
                //Logger.getLogger(Autenticacion.class.getName()).log(Level.SEVERE, null, ex);
            }

            //System.out.println(":::::::::::" + session.getAttribute("usuario"));
        }

    }

    //System.out.println("No es null session :::::::::::" + session.getAttribute("usuario"));
    //String responseCode = "false";
    System.out.println("responseCode request " + responseCode);
    //responseCode="false";
    if (responseCode.equalsIgnoreCase("false")) {

        System.out.println("El motor de pagos no contesta(response code false), se redirecciona al inicio:::::");

        System.out.println("::: Response rechazo ::: ");
        String responseCodefalse = request.getParameter("responseCode");
        String transactionIdentifierfalse = request.getParameter("transactionIdentifier");
        String messagefalse = request.getParameter("message");
        System.out.println("responseCode : " + responseCodefalse);
        System.out.println("transactionIdentifier : " + transactionIdentifierfalse);
        System.out.println("message : " + messagefalse);
        System.out.println("::: Response rechazo ::: ");

        //UPDATE REF  CODI  ECM   message error de comunicacion.
        StatusProsaCode = new String();
        StatusProsaCode = request.getParameter("prosaCode");
        if (request.getParameter("prosaCode").toString().equalsIgnoreCase("")) {
            StatusProsaCode = "9";
        }
        StatusMessage = request.getParameter("message");

        //Notificacion UpdateReferencia
        String UPDATEREFERENCIA = oProperties.getProperty("UPDATEREFERENCIA");
        System.out.println("" + UPDATEREFERENCIA + " ::: " + transactionIdentifier);
        URL urlUpdateReferencia = new URL(UPDATEREFERENCIA);
        HttpURLConnection conUpdateReferencia = (HttpURLConnection) urlUpdateReferencia.openConnection();
        conUpdateReferencia.setRequestMethod("POST");
        conUpdateReferencia.setRequestProperty("Content-Type", "application/json; utf-8");
        conUpdateReferencia.setDoOutput(true);
        conUpdateReferencia.setRequestProperty("Authorization", "Bearer " + session.getAttribute("token"));

        String jsonIStr = "{\n"
                + "  \"Mensaje\": \"" + StatusProsaCode + "\" ,\n"
                + "  \"Referencia\": \"EAF" + transactionIdentifier + "\",\n"
                + "  \"Campo\": \"-\"\n"
                + "}";
        System.out.println("jsonInputStringUpdateReferencia ::: " + jsonIStr);
        try (OutputStream os = conUpdateReferencia.getOutputStream()) {
            byte[] input = jsonIStr.getBytes("utf-8");
            os.write(input, 0, input.length);
        }

        try (BufferedReader bdata = new BufferedReader(
                new InputStreamReader(conUpdateReferencia.getInputStream(), "utf-8"))) {
            String jsondata = new String();
            InputStream inputStreamdata = conUpdateReferencia.getInputStream();
            BufferedReader bufferedReaderdata = new BufferedReader(new InputStreamReader(inputStreamdata), 1);
            String lineuserdata;
            while ((lineuserdata = bufferedReaderdata.readLine()) != null) {
                jsondata = lineuserdata;
            }
            System.out.println("jsondata conUpdateReferencia ::: " + jsondata);
            inputStreamdata.close();
            bufferedReaderdata.close();
            JSONObject jsonObjdata = new JSONObject(jsondata);

            if (jsonObjdata.get("success").toString() == "true") {
                String msg = jsonObjdata.get("message").toString();
                msg = msg.replace("Ã±", "ñ");
                eliminarDeLista = true;
                System.out.println("success service conUpdateReferencia TRUE:::::eliminar de la lista ::" + eliminarDeLista);

            } else {
                eliminarDeLista = false;
                System.out.println("success service conUpdateReferencia FALSE:::::" + eliminarDeLista);

            }
        } catch (JSONException ex) {
            System.out.println("JSONException service conUpdateReferencia FALSE:::::" + eliminarDeLista + " / " + ex);
        }
        //Notificacion UpdateReferenciaSQL 
%>
<!DOCTYPE html>
<html>
    <head>

        <meta name="tipo_contenido"  content="text/html;" http-equiv="content-type" charset="utf-8">
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>RESPUESTA DEL PAGO</title>
        <link href="archivos/5b1ddbe400c01d95eb9dd383_IconoSADM.png" rel="shortcut icon" type="image/x-icon" />
        <script src="https://ajax.googleapis.com/ajax/libs/webfont/1.4.7/webfont.js" type="text/javascript"></script>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">

        <link href="styles/webflow1.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow4.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow3.css" rel="stylesheet" type="text/css" />
        <SCRIPT LANGUAGE="JavaScript">
            history.forward()
        </SCRIPT>
    </head>
    <body  oncontextmenu="return false;">
        <%@include file="Top.jsp" %>
        <div class="container-fluid my-4">
            <br>
            <br><br><br>
            <div class="row py2">

                <div class="container py2">

                    <div style="width: 100%;margin-left: 80px;">                            

                        <hr>

                        <h2 colspan="4">Datos de Respuesta de Transacción</h2>
                        <br>


                        <h6 >Estatus de Pago: <%=StatusMessage%></h6>
                        <br>
                        <h6 >Código de Respuesta <%=StatusProsaCode%> | <%=StatusMessage%></h6>
                        <br>

                        <button  class="btn btn-outline-primary " onclick="redi()" type="button">Aceptar</button>
                        <script>
                            function redi() {
                                top.location.href = "Inicio.jsp";
                            }
                        </script>
                    </div> </div> </div> </div>

        <%@include file="Bottom.jsp" %>
    </body>
</html>



<%

} else {

    // System.out.println("session 1" + session.getAttribute("usuario"));

%>

<%    String email = eAydObj.getEmail();

    //System.out.println("SIZE:::::::LST::::   " + eAydObjLst.lstDTO.size());
//System.out.println("transactionIdentifier :: " + transactionIdentifier);
    String IdSistema = "eAyd";
    String montopagar = eAydObj.getMontopagar();
    String nispagardt = eAydObj.getNispagardt();
    System.out.println("nispagardt:: : "+nispagardt);
    String password = eAydObj.getPassword();
    String transactionId = eAydObj.getTransactionId();
    String vpc_MerchTxnRef = eAydObj.getVpc_MerchTxnRef();
//
//    System.out.println("Session user: " + email);
//    System.out.println("Session IdSistema: " + IdSistema);
//    System.out.println("Session nispagardt: " + nispagardt);
//    System.out.println("Session montopagar: " + montopagar);
//    System.out.println("Session password: " + password);
    // System.out.println("Session transactionId: " + transactionId);
    //System.out.println("Session vpc_MerchTxnRef: " + vpc_MerchTxnRef);
    //System.out.println(" StatusProsaCode  c1: "+ StatusProsaCode);
    if (!StatusProsaCode.equalsIgnoreCase("c1") || !StatusProsaCode.equalsIgnoreCase("")) {
        try {

            /*Consultar Estatus*/
            System.out.println("::::: Consultar Estatus de transacción BitsPay :::::" + fechaactual + " / " + transactionIdentifier);
            String QBITSPAYMENTSSTATUS = oProperties.getProperty("QBITSPAYMENTSSTATUS");
            URL urlStatus = new URL(QBITSPAYMENTSSTATUS + transactionIdentifier + "");
            HttpURLConnection connStatus = (HttpURLConnection) urlStatus.openConnection();
            connStatus.setRequestMethod("GET");
            connStatus.setRequestProperty("Accept", "application/json");
            connStatus.setRequestProperty("Authorization", "Bearer " + session.getAttribute("token"));
            System.out.println("connStatus :: " + connStatus);
            System.out.println("connStatus code :: " + connStatus.getResponseCode());
            if (connStatus.getResponseCode() != 200) {
                eliminarDeLista = false;
                System.out.println("Sin estatus confirmado de qbits eliminar de lista : " + eliminarDeLista);
                response.sendRedirect("sweetAlertError500.html");
                //throw new RuntimeException("Failed : HTTP error code : " + connStatus.getResponseCode());

            } else {
                try {
                    InputStream inputStreamStatus = connStatus.getInputStream();
                    String jsonstatus = new String();
                    BufferedReader bufferedReaderstatus = new BufferedReader(new InputStreamReader(inputStreamStatus), 1);
                    String linestatus;
                    while ((linestatus = bufferedReaderstatus.readLine()) != null) {
                        jsonstatus = linestatus;
                    }
                    bufferedReaderstatus.close();
                    bufferedReaderstatus.close();
                    System.out.println("json status qbits c1 ::: " + jsonstatus);
                    JSONObject jsonObjstatus = new JSONObject(jsonstatus);
                    System.out.println("Response status transaction :: " + jsonstatus.toString());
                    StatusMessage = jsonObjstatus.get("message").toString();
//            System.out.println("StatusMessage :: " + StatusMessage);

                    String StatusResponseCode = jsonObjstatus.get("responseCode").toString();

                    System.out.println("StatusResponseCode :: " + StatusResponseCode);
                    StatusProsaCode = jsonObjstatus.get("prosaCode").toString();
//            System.out.println("StatusProsaCode :: " + StatusProsaCode.trim());
                    String StatusTransactionIdentifier = jsonObjstatus.get("transactionIdentifier").toString();
                    System.out.println("StatusTransactionIdentifier :: " + StatusTransactionIdentifier);
                    String[] StatustransLst = StatusTransactionIdentifier.split("#");
                    //  String StatTransacId = StatustransLst[1].toString();
                    String StatTransacId = StatusTransactionIdentifier;
                    System.out.println("StatTransacId ::: " + StatTransacId);

                    if (!StatusProsaCode.equalsIgnoreCase("9")) {

                        String StatusTransactionDate = jsonObjstatus.get("transactionDate").toString();
//            System.out.println("StatusTransactionDate :: " + StatusTransactionDate);

                        String StatusTransactionTime = jsonObjstatus.get("transactionTime").toString();
//            System.out.println("StatusTransactionTime :: " + StatusTransactionTime);

                        JSONObject jsonObjmessageObj = new JSONObject(jsonObjstatus.get("messageObject").toString());
                        System.out.println("jsonObjmessageObj :: " + jsonObjmessageObj.toString());
                        String StatusTraceNumber = jsonObjmessageObj.get("traceNumber").toString();
//            System.out.println("StatusTraceNumber :: " + StatusTraceNumber);
                        StatusAuthorizationCode = jsonObjmessageObj.get("authorizationCode").toString();
            System.out.println("StatusAuthorizationCode :: " + StatusAuthorizationCode);
                        String StatusAmount = jsonObjmessageObj.get("amount").toString();
//            System.out.println("StatusAmount :: " + StatusAmount);
                        String StatusAffiliationNumber = jsonObjmessageObj.get("affiliationNumber").toString();
//            System.out.println("StatusAffiliationNumber :: " + StatusAffiliationNumber);
                        String StatusBin = jsonObjmessageObj.get("bin").toString();
//            System.out.println("StatusBin :: " + StatusBin);
                        String StatusCardDigits = jsonObjmessageObj.get("cardDigits").toString();
//            System.out.println("StatusCardDigits :: " + StatusCardDigits);

                        JSONObject jsonObjCard = new JSONObject(jsonObjstatus.get("card").toString());
                        //System.out.println("jsonObjmessageObj :: " +jsonObjmessageObj.toString());
                        String StatusMasterId = jsonObjCard.get("masterId").toString();
//            System.out.println("StatusMasterId :: " + StatusMasterId);
                        String StatusBrand = jsonObjCard.get("brand").toString();
//            System.out.println("StatusBrand :: " + StatusBrand);
                        String StatusBank = jsonObjCard.get("bank").toString();
//            System.out.println("StatusBank :: " + StatusBank);
                        String StatusType = jsonObjCard.get("type").toString();
//            System.out.println("StatusType :: " + StatusType);
                        String StatusCardStatusCatId = jsonObjCard.get("cardStatusCatId").toString();
//            System.out.println("StatusCardStatusCatId :: " + StatusCardStatusCatId);
                        String StatusAboutToExpire = jsonObjCard.get("aboutToExpire").toString();
//            System.out.println("StatusAboutToExpire :: " + StatusAboutToExpire);
                        String StatusSave = jsonObjCard.get("save").toString();
                        //System.out.println("StatusSave :: " + StatusSave);
                        System.out.println("QBITSPAYMENTSSTATUS Consultar Estatus completado :: " + fechaactual + " / " + StatTransacId);
//                        //Consultar Estatus
                        //Recalcular y enlistar nis para su iteración en validaciones y envio de notificaciones 
                        System.out.println("nispagardt :: "+nispagardt);
                        String[] listNisPagar = nispagardt.split("nis");
                        ArrayList<ServicioNISDAO> lstServ = new ArrayList();
                        String SELSALDOS = oProperties.getProperty("SELSALDOS");
                        URL urlsaldos = new URL(SELSALDOS + session.getAttribute("usuario"));

                        HttpURLConnection connsaldos = (HttpURLConnection) urlsaldos.openConnection();
                        connsaldos.setRequestMethod("GET");
                        connsaldos.setRequestProperty("Accept", "application/json");
                        connsaldos.setRequestProperty("Authorization", "Bearer " + session.getAttribute("token"));

                        if (connsaldos.getResponseCode() != 200) {
                            eliminarDeLista = false;
                            System.out.println(StatTransacId + " ::SELSALDOS No posible recalcular el saldo response code: " + fechaactual + " / " + connsaldos.getResponseCode());
//                            System.out.println(StatTransacId+" ::SELSALDOS No posible recalcular el saldo response code: "+eliminarDeLista);
                            eliminarDeLista = false;
                            response.sendRedirect("sweetAlertError500.html");
//                        throw new RuntimeException("Failed : HTTP error code : " + connsaldos.getResponseCode());

                        } else {
                            System.out.println("::SELSALDOS RecalcularSaldos :: " + fechaactual + " / " + StatTransacId);
                            try {

                                InputStream inputStreamsaldos = connsaldos.getInputStream();
                                String jsonsaldos = new String();
                                BufferedReader bufferedReadersaldos = new BufferedReader(new InputStreamReader(inputStreamsaldos), 1);
                                String linesaldos = "";
                                while ((linesaldos = bufferedReadersaldos.readLine()) != null) {
                                    jsonsaldos = linesaldos;
                                }
                                inputStreamsaldos.close();
                                bufferedReadersaldos.close();
                                System.out.println("jsonsaldos recalcular ::: " + jsonsaldos);
                                JSONObject jsonObjsaldos = new JSONObject(jsonsaldos);

                                JSONObject jsonObjservresponse = new JSONObject(jsonObjsaldos.get("Response").toString());
                                // System.out.println("strjsonObjservresponsedata :: " +jsonObjservresponse.toString());
                                String strjsonObjservresponsedata = jsonObjservresponse.get("data").toString();

                                strjsonObjservresponsedata = strjsonObjservresponsedata.replace("[", "");
                                strjsonObjservresponsedata = strjsonObjservresponsedata.replace("]", "");

                                //System.out.println("strjsonObjservresponsedata :: " + strjsonObjservresponsedata);
                                JSONObject jsonObjservresponsedata = new JSONObject(strjsonObjservresponsedata);
                                System.out.println("jsonObjservresponsedata recalcular saldos :: " + jsonObjservresponsedata.toString());

                                JSONArray results = new JSONArray(jsonObjservresponse.get("data").toString());
                                // System.out.println("result:: " + results.length());
                                for (int i = 0; i < results.length(); i++) {
                                    JSONObject aux = results.getJSONObject(i);
                                    ServicioNISDAO serv = new ServicioNISDAO();
                                    serv.setV_nis_rad(aux.get("NIS").toString());
                                    serv.setV_sec_rec("0");
                                    serv.setV_f_fact(aux.get("Fecha_Venc").toString());
                                    serv.setV_sec_nis(aux.get("Fecha_Venc").toString());
                                    serv.setV_f_vcto(aux.get("Fecha_Venc").toString());
                                    serv.setV_importe(Double.parseDouble(aux.get("v_totaladeu").toString()));
                                    String strDomicilio = "" + aux.get("Direccion").toString() + " ";
                                    String strdomicilioLegible = new String(strDomicilio.getBytes("ISO-8859-1"), "UTF-8");
                                    serv.setP_Direccion(strdomicilioLegible);
                                    serv.setPartner(aux.get("Partner").toString());
                                    serv.setVkont(aux.get("Vkont").toString());
                                    lstServ.add(serv);
                                }
                                connsaldos.disconnect();
                            } catch (IOException ioe) {
                                    System.out.println(StatTransacId+" IOException selsaldos recalcular ::: " + ioe);
                            } catch (JSONException ex) {
                                System.out.println(StatTransacId +" JSONException selsaldos recalcular ::: " + ex);
                            }
                        }
                        double amountcalc = 0;
                        for (String n : listNisPagar) {
                            System.out.println("n.substring(0, 9) nis: " + n.substring(0, 9));
                            for (ServicioNISDAO sn : lstServ) {
                                if (n.substring(0, 9).equalsIgnoreCase(sn.getV_nis_rad())) {

                                    amountcalc = amountcalc + sn.getV_importe();

                                }
                            }
                        }
//                    DecimalFormat df2 = new DecimalFormat ("#.##"); 
//                    amountcalc = Double.parseDouble(df2.format (amountcalc));
//                    String abc = String.valueOf(amountcalc) ;
                        String abc = String.valueOf(amountcalc);
                        abc = abc.replace(".", "");
                        amountcalc = Double.parseDouble(abc) * 100;

                        Long lon = Long.parseLong(abc) * 10;
                        System.out.println("::::::::: amountcalc: " + lon);
                        String finalamountcalc = "" + lon;
                        for (int i = finalamountcalc.length(); i < 12; i++) {
                            finalamountcalc = "0" + finalamountcalc;
                        }

                        System.out.println("El amountcalc recalculado y formateado para bitspay a 12 digitos" + fechaactual + " / " + StatTransacId + "/" + finalamountcalc);
                        //System.out.println("La suma del adeudo en los servicios seleccionados a pagar  es:  " + amountcalc);
                        //Recalcular y enlistar nis para su iteración en validaciones y envio de notificaciones 
                        //Validaciones y Notificaciones eAyd
                        //*****-----******
                        System.out.println("StatusProsaCode ::" + StatusProsaCode);
                        if (StatusProsaCode.equalsIgnoreCase("00") && StatusAmount.equalsIgnoreCase(finalamountcalc.toString())) {
//                            if (StatusProsaCode.equalsIgnoreCase("00")) {
                            respuesta = "Pago completado.";
                            System.out.println("El código de respuesta es 00: " + fechaactual + " / " + StatTransacId);
                            System.out.println("Montos : StatusAmount= " + fechaactual + " / " + StatTransacId + "/" + StatusAmount + " / finalamountcalc= " + finalamountcalc);

                            //Iteración de notificacion PAYMENTSAP/INSERTPAGOPAGOSQL
                            System.out.println("listNisPagar: "+listNisPagar.length );
                            System.out.println("lstServ:: "+lstServ.size() );
                            for (String n : listNisPagar) {

                                for (ServicioNISDAO sn : lstServ) {

                                    if (n.substring(0, 9).equalsIgnoreCase(sn.getV_nis_rad())) {

                                        if (sn.getV_importe() > 0) {
                                            

                                            String INSERTARSERVICIOPAGOSQL = oProperties.getProperty("INSERTARSERVICIOPAGOSQL");
                                            System.out.println("" + INSERTARSERVICIOPAGOSQL + "::: " + sn.getV_nis_rad());

                                            URL urlinsertarServicioPagoSQL = new URL(INSERTARSERVICIOPAGOSQL);
                                            HttpURLConnection coninsertarServicioPagoSQL = (HttpURLConnection) urlinsertarServicioPagoSQL.openConnection();
                                            coninsertarServicioPagoSQL.setRequestMethod("POST");
                                            coninsertarServicioPagoSQL.setRequestProperty("Content-Type", "application/json; utf-8");
                                            coninsertarServicioPagoSQL.setDoOutput(true);
                                            coninsertarServicioPagoSQL.setRequestProperty("Authorization", "Bearer " + session.getAttribute("token"));

                                            String jsonIString = "{\n"
                                                    + "  \"v_nis_rad\": \"" + sn.getV_nis_rad() + "\",\n"
                                                    + "  \"v_sec_rec\": \"" + sn.getV_sec_rec() + "\",\n"
                                                    + "  \"v_f_fact\": \"" + sn.getV_f_fact() + "\",\n"
                                                    + "  \"v_sec_nis\": \"" + sn.getV_sec_nis() + "\",\n"
                                                    + "  \"v_f_vcto\": \"" + sn.getV_f_vcto() + "\",\n"
                                                    + "  \"v_importe\": \"" + sn.getV_importe() + "\",\n"
                                                    + "  \"v_referencia\": \"" + vpc_MerchTxnRef + "\",\n"
                                                    + "  \"email\": \"" + session.getAttribute("usuario") + "\",\n"
                                                    + "  \"P_Direccion\": \"" + sn.getP_Direccion() + "\",\n"
                                                    + "  \"authorizationId\": \"" + StatusAuthorizationCode + "\"\n"
                                                    + "}";
                                            System.out.println("jsonInputStringinsertarServicioPagoSQL ::: " + jsonIString);
                                            try (OutputStream os = coninsertarServicioPagoSQL.getOutputStream()) {
                                                byte[] input = jsonIString.getBytes("utf-8");
                                                os.write(input, 0, input.length);
                                            }

                                            try (BufferedReader bdata = new BufferedReader(
                                                    new InputStreamReader(coninsertarServicioPagoSQL.getInputStream(), "utf-8"))) {
                                                String jsondata = new String();
                                                InputStream inputStreamdata = coninsertarServicioPagoSQL.getInputStream();
                                                BufferedReader bufferedReaderdata = new BufferedReader(new InputStreamReader(inputStreamdata), 1);
                                                String lineuserdata;
                                                while ((lineuserdata = bufferedReaderdata.readLine()) != null) {
                                                    jsondata = lineuserdata;
                                                }
                                                System.out.println("jsondata coninsertarServicioPagoSQL ::: " + jsondata);
                                                inputStreamdata.close();
                                                bufferedReaderdata.close();
                                                JSONObject jsonObjdata = new JSONObject(jsondata);

                                                if (jsonObjdata.get("success").toString() == "true") {
                                                    String msg = jsonObjdata.get("message").toString();
                                                    msg = msg.replace("Ã±", "ñ");
                                                    System.out.println("success service coninsertarServicioPagoSQL TRUE:::::");
                                                    eliminarDeLista = true;

                                                } else {
                                                    System.out.println("success service coninsertarServicioPagoSQL FALSE:::::");
                                                    eliminarDeLista = false;

                                                }
                                            } catch (JSONException ex) {
                                                ex.printStackTrace();
                                            }
                                            
                                            System.out.println("try PAYMENTSAP NIS: " + sn.getV_nis_rad() + "/" + fechaactual + " / " + StatTransacId + " amount: " + sn.getV_importe());

                                            String PAYMENTSAP = oProperties.getProperty("PAYMENTSAP");

                                            URL urlinsertarServicioPago = new URL(PAYMENTSAP);
                                            System.out.println("urlPaymentSap: " + PAYMENTSAP + "::: " + sn.getV_nis_rad() + "/" + fechaactual + " / " + StatTransacId);
                                            HttpURLConnection coninsertarServicioPago = (HttpURLConnection) urlinsertarServicioPago.openConnection();
                                            coninsertarServicioPago.setRequestMethod("POST");
                                            coninsertarServicioPago.setRequestProperty("Content-Type", "application/json; utf-8");
                                            coninsertarServicioPago.setDoOutput(true);
                                            coninsertarServicioPago.setRequestProperty("Authorization", "Bearer " + session.getAttribute("token"));

                                            //TODO
                                            Date dat = new Date();
                                            //System.out.println("dtIDMessageHeader:: "+new SimpleDateFormat("ddMMyyyy").format(dat));
                                            String dtIDMessageHeader = new SimpleDateFormat("ddMMyyyy").format(dat);
                                            String DtCreationMessageHeader = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(dat);
                                            //System.out.println("DtCreationMessageHeader :: "+DtCreationMessageHeader);
                                            String valueDt = new SimpleDateFormat("yyyy-MM-dd").format(dat);
                                            int consecutivo = (int) (9 * Math.random());
                                            String fconsecutivo = "" + consecutivo;
                                            for (int i = fconsecutivo.length(); i < 5; i++) {
                                                fconsecutivo = "0" + fconsecutivo;
                                            }
                                            int consecutivo1 = (int) (999 * Math.random());
                                            String fconsecutivo1 = "" + consecutivo1;
                                            for (int i = fconsecutivo1.length(); i < 3; i++) {
                                                fconsecutivo1 = "0" + fconsecutivo1;
                                            }

                                            String IDMessageHeader = "PAY-" + dtIDMessageHeader + "-" + sn.getV_nis_rad().substring(0, 4) + fconsecutivo;//(Pay + fecha (ddMMyyyy) + consecutivo(00001))";
                                            String DateCreationMessageHeader = DtCreationMessageHeader;//(formato: yyyy-MM-dd’T’HH:mm:ss’Z’).
                                            String CashPointReferenceID = "E99";//(Caja)//Qbits code web eAyd??????
                                            String CashPointOfficeReferenceID = "SADM_1INT";//(Oficina)TODO
                                            String CashPointPaymentGroupReferenceID = "EAF-" + dtIDMessageHeader + "-001" ;//(Grupos del Pagos del Dia INT-ddMMyyyy- consecutivo).
                                            String PaymentTransactionID = IDMessageHeader;//(Igual que el parámetro “ID”).
                                            String PaymentAmount = String.valueOf(sn.getV_importe());//(Añadir atributo currencyCode = MxN).
                                            String ValueDate = valueDt;//(Formato Fecha yyyy-MM-dd).
                                            String OnAccountIndicator = "false";
                                            String OutgoingPayment = "false";
                                            String InternalID = sn.getPartner();//(PARTNER. Obtenido de WSDL Consulta).
                                            String DebtorInternalID = InternalID;//. (Igual que el parametro “InternalID”).
                                            System.out.println("sn.getVkont(): " + sn.getVkont());
                                            String ContractAccountReferenceID = sn.getVkont();//. (VKONT. Obtenido de WSDL Consulta).
                                            String ContractReferenceID = sn.getV_nis_rad();//(NIS).

                                            String jsonInString = "{\n"
                                                    + "  \"IDMessageHeader\": \"" + IDMessageHeader + "\",\n"
                                                    + "  \"DateCreationMessageHeader\": \"" + DateCreationMessageHeader + "\",\n"
                                                    + "  \"CashPointReferenceID\": \"" + CashPointReferenceID + "\",\n"
                                                    + "  \"CashPointOfficeReferenceID\": \"" + CashPointOfficeReferenceID + "\",\n"
                                                    + "  \"CashPointPaymentGroupReferenceID\": \"" + CashPointPaymentGroupReferenceID + "\",\n"
                                                    + "  \"PaymentTransactionID\": \"" + PaymentTransactionID + "\",\n"
                                                    + "  \"PaymentAmount\": \"" + PaymentAmount + "\",\n"
                                                    + "  \"ValueDate\": \"" + ValueDate + "\",\n"
                                                    + "  \"OnAccountIndicator\": \"" + OnAccountIndicator + "\",\n"
                                                    + "  \"OutgoingPayment\": \"" + OutgoingPayment + "\",\n"
                                                    + "  \"InternalID\": \"" + InternalID + "\",\n"
                                                    + "  \"DebtorInternalID\": \"" + DebtorInternalID + "\",\n"
                                                    + "  \"ContractAccountReferenceID\": \"" + ContractAccountReferenceID + "\",\n"
                                                    + "  \"ContractReferenceID\": \"" + ContractReferenceID + "\"\n"
                                                    + "}";
                                            System.out.println("jsonInputStringPAYMENTSAP ::: " + jsonInString);
                                            try (OutputStream os = coninsertarServicioPago.getOutputStream()) {
                                                byte[] input = jsonInString.getBytes("utf-8");
                                                os.write(input, 0, input.length);
                                            }

                                            try (BufferedReader bdata = new BufferedReader(
                                                    new InputStreamReader(coninsertarServicioPago.getInputStream(), "utf-8"))) {
                                                String jsondata = new String();
                                                InputStream inputStreamdata = coninsertarServicioPago.getInputStream();
                                                BufferedReader bufferedReaderdata = new BufferedReader(new InputStreamReader(inputStreamdata), 1);
                                                String lineuserdata;
                                                while ((lineuserdata = bufferedReaderdata.readLine()) != null) {
                                                    jsondata = lineuserdata;
                                                }
                                                System.out.println("jsondata consumir PAYMENTSAP ::: " + sn.getV_nis_rad() + "/" + fechaactual + " / " + StatTransacId + jsondata);
                                                inputStreamdata.close();
                                                bufferedReaderdata.close();
                                                JSONObject jsonObjdata = new JSONObject(jsondata);

                                                if (jsonObjdata.get("success").toString() == "true") {
                                                    String msg = jsonObjdata.get("message").toString();
                                                    msg = msg.replace("Ã±", "ñ");
                                                    System.out.println("success service PAYMENTSAP TRUE:::::" + sn.getV_nis_rad() + "/" + fechaactual + " / " + StatTransacId);
                                                    eliminarDeLista = true;

                                                } else {
                                                    System.out.println("success service PAYMENTSAP FALSE:::::" + sn.getV_nis_rad() + "/" + fechaactual + " / " + StatTransacId);
                                                    eliminarDeLista = false;

                                                }
                                            } catch (JSONException ex) {
                                                System.out.println(StatTransacId + " PAYMENTSAP No posible recalcular el saldonsertar el pago response code: " + fechaactual + " / " + ex);
//                         
                                            }

                                            

                                        } else {
                                            System.out.println("el importe del nis no puede notificarse en con monto 0");
                                        }

                                    } else {
                                        //System.out.println("::");
                                        // System.out.println("el nis iterado no es el mismo para notificar pago");
                                    }
                                }
                            }
                            //Iteración de notificacion insertpago/insertpagosql

                            //Notificacion UpdateReferencia
                                            String UPDATEREFERENCIA = oProperties.getProperty("UPDATEREFERENCIA");
                                            System.out.println("" + UPDATEREFERENCIA + " ::: " + transactionIdentifier);
                                            URL urlUpdateReferencia = new URL(UPDATEREFERENCIA);
                                            HttpURLConnection conUpdateReferencia = (HttpURLConnection) urlUpdateReferencia.openConnection();
                                            conUpdateReferencia.setRequestMethod("POST");
                                            conUpdateReferencia.setRequestProperty("Content-Type", "application/json; utf-8");
                                            conUpdateReferencia.setDoOutput(true);
                                            conUpdateReferencia.setRequestProperty("Authorization", "Bearer " + session.getAttribute("token"));

                                            String jsonIStr = "{\n"
                                                    + "  \"Mensaje\": \"" + StatusProsaCode + "\" ,\n"
                                                    + "  \"Referencia\": \"EAF" + transactionIdentifier + "\",\n"
                                                    + "  \"Campo\": \""+StatusAuthorizationCode+"\"\n"
                                                    + "}";
                                            System.out.println("jsonInputStringUpdateReferencia ::: " + jsonIStr);
                                            try (OutputStream os = conUpdateReferencia.getOutputStream()) {
                                                byte[] input = jsonIStr.getBytes("utf-8");
                                                os.write(input, 0, input.length);
                                            }

                                            try (BufferedReader bdata = new BufferedReader(
                                                    new InputStreamReader(conUpdateReferencia.getInputStream(), "utf-8"))) {
                                                String jsondata = new String();
                                                InputStream inputStreamdata = conUpdateReferencia.getInputStream();
                                                BufferedReader bufferedReaderdata = new BufferedReader(new InputStreamReader(inputStreamdata), 1);
                                                String lineuserdata;
                                                while ((lineuserdata = bufferedReaderdata.readLine()) != null) {
                                                    jsondata = lineuserdata;
                                                }
                                                System.out.println("jsondata conUpdateReferencia ::: " + jsondata);
                                                inputStreamdata.close();
                                                bufferedReaderdata.close();
                                                JSONObject jsonObjdata = new JSONObject(jsondata);

                                                if (jsonObjdata.get("success").toString() == "true") {
                                                    String msg = jsonObjdata.get("message").toString();
                                                    msg = msg.replace("Ã±", "ñ");
                                                    eliminarDeLista = true;
                                                    System.out.println("success service conUpdateReferencia TRUE:::::eliminar de la lista ::" + eliminarDeLista);

                                                } else {
                                                    eliminarDeLista = false;
                                                    System.out.println("success service conUpdateReferencia FALSE:::::" + eliminarDeLista);

                                                }
                                            } catch (JSONException ex) {
                                                System.out.println("JSONException service conUpdateReferencia FALSE:::::" + eliminarDeLista + " / " + ex);
                                            }
                                            //Notificacion UpdateReferenciaSQL 
                            
                            
                        } else {
                            System.out.println("No paso validacion de status y monto :: " + StatTransacId);
                            if (!StatusAmount.equalsIgnoreCase(finalamountcalc.toString())) {
                                respuesta = "Pago no realizado inconsistencias en los montos.";
                            } else {
                                respuesta = StatusMessage;
                            }

                            System.out.println("Montos : StatusAmount= " + StatusAmount + " / finalamountcalc= " + finalamountcalc);
                            System.out.println("El código de respuesta: " + StatusProsaCode);
                            //Notificacion UpdateReferencia
                            String UPDATEREFERENCIA = oProperties.getProperty("UPDATEREFERENCIA");
                            System.out.println("" + UPDATEREFERENCIA + " ::: " + transactionIdentifier);
                            URL urlUpdateReferencia = new URL(UPDATEREFERENCIA);
                            HttpURLConnection conUpdateReferencia = (HttpURLConnection) urlUpdateReferencia.openConnection();
                            conUpdateReferencia.setRequestMethod("POST");
                            conUpdateReferencia.setRequestProperty("Content-Type", "application/json; utf-8");
                            conUpdateReferencia.setDoOutput(true);
                            conUpdateReferencia.setRequestProperty("Authorization", "Bearer " + session.getAttribute("token"));

                            String jsonIStr = "{\n"
                                    + "  \"Mensaje\": \"" + StatusProsaCode + "\" ,\n"
                                    + "  \"Referencia\": \"EAF" + transactionIdentifier + "\",\n"
                                    + "  \"Campo\": \""+StatusMessage+"\"\n"
                                    + "}";
                            System.out.println("jsonInputStringUpdateReferencia ::: " + jsonIStr);
                            try (OutputStream os = conUpdateReferencia.getOutputStream()) {
                                byte[] input = jsonIStr.getBytes("utf-8");
                                os.write(input, 0, input.length);
                            }

                            try (BufferedReader bdata = new BufferedReader(
                                    new InputStreamReader(conUpdateReferencia.getInputStream(), "utf-8"))) {
                                String jsondata = new String();
                                InputStream inputStreamdata = conUpdateReferencia.getInputStream();
                                BufferedReader bufferedReaderdata = new BufferedReader(new InputStreamReader(inputStreamdata), 1);
                                String lineuserdata;
                                while ((lineuserdata = bufferedReaderdata.readLine()) != null) {
                                    jsondata = lineuserdata;
                                }
                                System.out.println("jsondata conUpdateReferencia ::: " + jsondata);
                                inputStreamdata.close();
                                bufferedReaderdata.close();
                                JSONObject jsonObjdata = new JSONObject(jsondata);

                                if (jsonObjdata.get("success").toString() == "true") {
                                    String msg = jsonObjdata.get("message").toString();
                                    msg = msg.replace("Ã±", "ñ");
                                    eliminarDeLista = true;
                                    System.out.println("success service conUpdateReferencia TRUE:::::eliminar de la lista ::" + eliminarDeLista);

                                } else {
                                    eliminarDeLista = false;
                                    System.out.println("success service conUpdateReferencia FALSE:::::" + eliminarDeLista);

                                }
                            } catch (JSONException ex) {
                                System.out.println("JSONException service conUpdateReferencia FALSE:::::" + eliminarDeLista + " / " + ex);
                            }
                            //Notificacion UpdateReferenciaSQL 

                        }
                    } else {

                        //PAgo status 9
                        System.out.println("StatusProsaCode es igual a: " + StatusProsaCode);
                        respuesta = StatusMessage;
                        System.out.println("El código de respuesta: " + StatusProsaCode);
                        //Notificacion UpdateReferencia
                        String UPDATEREFERENCIA = oProperties.getProperty("UPDATEREFERENCIA");
                        System.out.println("" + UPDATEREFERENCIA + " ::: " + transactionIdentifier);
                        URL urlUpdateReferencia = new URL(UPDATEREFERENCIA);
                        HttpURLConnection conUpdateReferencia = (HttpURLConnection) urlUpdateReferencia.openConnection();
                        conUpdateReferencia.setRequestMethod("POST");
                        conUpdateReferencia.setRequestProperty("Content-Type", "application/json; utf-8");
                        conUpdateReferencia.setDoOutput(true);
                        conUpdateReferencia.setRequestProperty("Authorization", "Bearer " + session.getAttribute("token"));

                        String jsonIStr = "{\n"
                                + "  \"Mensaje\": \"" + StatusProsaCode + "\" ,\n"
                                + "  \"Referencia\": \"EAF" + transactionIdentifier + "\",\n"
                                + "  \"Campo\": \""+StatusMessage+"\"\n"
                                + "}";
                        System.out.println("jsonInputStringUpdateReferencia ::: " + jsonIStr);
                        try (OutputStream os = conUpdateReferencia.getOutputStream()) {
                            byte[] input = jsonIStr.getBytes("utf-8");
                            os.write(input, 0, input.length);
                        }

                        try (BufferedReader bdata = new BufferedReader(
                                new InputStreamReader(conUpdateReferencia.getInputStream(), "utf-8"))) {
                            String jsondata = new String();
                            InputStream inputStreamdata = conUpdateReferencia.getInputStream();
                            BufferedReader bufferedReaderdata = new BufferedReader(new InputStreamReader(inputStreamdata), 1);
                            String lineuserdata;
                            while ((lineuserdata = bufferedReaderdata.readLine()) != null) {
                                jsondata = lineuserdata;
                            }
                            System.out.println("jsondata conUpdateReferencia ::: " + jsondata);
                            inputStreamdata.close();
                            bufferedReaderdata.close();
                            JSONObject jsonObjdata = new JSONObject(jsondata);

                            if (jsonObjdata.get("success").toString() == "true") {
                                String msg = jsonObjdata.get("message").toString();
                                msg = msg.replace("Ã±", "ñ");
                                eliminarDeLista = true;
                                System.out.println("success service conUpdateReferencia TRUE:::::eliminar de la lista ::" + eliminarDeLista);

                            } else {
                                eliminarDeLista = false;
                                System.out.println("success service conUpdateReferencia FALSE:::::" + eliminarDeLista);

                            }
                        } catch (JSONException ex) {
                            System.out.println("JSONException service conUpdateReferencia FALSE:::::" + eliminarDeLista + " / " + ex);
                        }
                        //Notificacion UpdateReferenciaSQL 

                    }

                } catch (IOException ioe) {
                    eliminarDeLista = false;
                    System.out.println("success LOGIN FALSE:::::");
                    out.println("<script type=\"text/javascript\">");
                    out.println("Falla de comunicación. Vuelva a intentar.');");
                    out.println("window.parent.location.href='https://ayd.sadm.gob.mx/eAyd/'");
                    out.println("</script>");
                    ioe.printStackTrace();
                }

            }
        } catch (IOException ioe) {
            Logger.getLogger(Autenticacion.class.getName()).log(Level.SEVERE, null, ioe);
        } catch (JSONException ex) {
            Logger.getLogger(Autenticacion.class.getName()).log(Level.SEVERE, null, ex);
        }
    } else {

        //CANCELADO
        System.out.println("::::: Pago Cancelado :::::" + fechaactual + " / " + transactionIdentifier);

        respuestacancelado = "Pago Cancelado";
        StatusMessage = request.getParameter("message");
        respuesta = StatusMessage;
        //Notificacion UpdateReferencia
        String UPDATEREFERENCIA = oProperties.getProperty("UPDATEREFERENCIA");
        System.out.println("" + UPDATEREFERENCIA + " ::: " + transactionIdentifier);
        URL urlUpdateReferencia = new URL(UPDATEREFERENCIA);
        HttpURLConnection conUpdateReferencia = (HttpURLConnection) urlUpdateReferencia.openConnection();
        conUpdateReferencia.setRequestMethod("POST");
        conUpdateReferencia.setRequestProperty("Content-Type", "application/json; utf-8");
        conUpdateReferencia.setDoOutput(true);
        conUpdateReferencia.setRequestProperty("Authorization", "Bearer " + session.getAttribute("token"));

        String jsonIStr = "{\n"
                + "  \"Mensaje\": \"" + StatusProsaCode + "\" ,\n"
                + "  \"Referencia\": \"EAF" + transactionIdentifier + "\",\n"
                + "  \"Campo\": \"-\"\n"
                + "}";
        System.out.println("jsonInputStringUpdateReferencia ::: " + jsonIStr);
        try (OutputStream os = conUpdateReferencia.getOutputStream()) {
            byte[] input = jsonIStr.getBytes("utf-8");
            os.write(input, 0, input.length);
        }

        try (BufferedReader bdata = new BufferedReader(
                new InputStreamReader(conUpdateReferencia.getInputStream(), "utf-8"))) {
            String jsondata = new String();
            InputStream inputStreamdata = conUpdateReferencia.getInputStream();
            BufferedReader bufferedReaderdata = new BufferedReader(new InputStreamReader(inputStreamdata), 1);
            String lineuserdata;
            while ((lineuserdata = bufferedReaderdata.readLine()) != null) {
                jsondata = lineuserdata;
            }
            System.out.println("jsondata conUpdateReferencia ::: " + jsondata);
            inputStreamdata.close();
            bufferedReaderdata.close();
            JSONObject jsonObjdata = new JSONObject(jsondata);

            if (jsonObjdata.get("success").toString() == "true") {
                String msg = jsonObjdata.get("message").toString();
                msg = msg.replace("Ã±", "ñ");
                eliminarDeLista = true;
                System.out.println("success service conUpdateReferencia TRUE:::::eliminar de la lista ::" + eliminarDeLista);

            } else {
                eliminarDeLista = false;
                System.out.println("success service conUpdateReferencia FALSE:::::" + eliminarDeLista);

            }
        } catch (JSONException ex) {
            System.out.println("JSONException service conUpdateReferencia FALSE:::::" + eliminarDeLista + " / " + ex);
        }
        //Notificacion UpdateReferenciaSQL 

    }

%>

<!DOCTYPE html>
<html>
    <head>
        <SCRIPT LANGUAGE="JavaScript">
            history.forward()
        </SCRIPT>
        <meta name="tipo_contenido"  content="text/html;" http-equiv="content-type" charset="utf-8">
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>RESPUESTA DEL PAGO</title>
        <link href="archivos/5b1ddbe400c01d95eb9dd383_IconoSADM.png" rel="shortcut icon" type="image/x-icon" />
        <script src="https://ajax.googleapis.com/ajax/libs/webfont/1.4.7/webfont.js" type="text/javascript"></script>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">

        <link href="styles/webflow1.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow4.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow3.css" rel="stylesheet" type="text/css" />
    </head>
    <body  oncontextmenu="return false;">
        <%@include file="Top.jsp" %>
        <div class="container-fluid my-4">
            <br><br><br><br>
            <div class="row py2">

                <div class="container py2">

                    <div style="width: 100%;margin-left: 80px;">                            

                        <hr>

                        <h2 colspan="4">Datos de Respuesta de Transacción</h2>
                        <br>


                        <h6 >Estatus de Pago: <%=respuesta%></h6>
                        <br>
                        <h6 >Código de Respuesta <%=StatusProsaCode%> | <%=StatusMessage%></h6>
                        <br>


                        <%
                            if (StatusProsaCode.equals("00")) {
                        %>
                        <h6 >El número de Autorización: <%=StatusAuthorizationCode%></h6>

                        <%}%>
                        <button  class="btn btn-outline-primary " onclick="redi()" type="button">Aceptar</button>
                        <script>
                            function redi() {
                                top.location.href = "Inicio.jsp";
                            }
                        </script>
                    </div> </div> </div> </div>

        <%@include file="Bottom.jsp" %>
    </body>
</html>
<%
    }

    System.out.println("eliminar de lista al final: " + eliminarDeLista);
    if (eliminarDeLista) {
        System.out.println("lista con obj   " + eAydObjLst.lstDTO.size());
        System.out.println("copia de lista con obj   " + eAydObjLst.lstDTO.size());
        try {
            if (eAydObjLst.lstDTO.isEmpty()) {
                System.out.println(":::copia de lista vacia no se elimina index:::");
            } else {
                System.out.println("Borrar index de lista: " + eAydObjLst.lstDTO.get(index).getUid());

                eAydObjLst.lstDTO.remove(index);
                System.out.println("index borrar: " + index);
            }
            System.out.println("SIZE:::::::LST:::: sn objeto despues de remove  " + eAydObjLst.lstDTO.size());
        } catch (Exception x) {
            System.out.println("Exception eliminar de lista al final:  " + x);
            response.sendRedirect("sweetAlert.html");
        }
    }
%>