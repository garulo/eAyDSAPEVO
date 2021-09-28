<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.io.OutputStream"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.util.Date"%>
<%@page import="com.ayd.dao.RutaProperties"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.IOException"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.URL"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="java.io.InputStream"%>
<%@page import="com.ayd.dao.ServicioNISDAO"%>
<%@page import="com.ayd.dao.ServicioNISDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    HttpSession objSession = request.getSession();
    String usuario = (String) objSession.getAttribute("usuario");
    System.out.println("usuario inicio sesion:: " + usuario);

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

        String strauthorizationCode = "00001";
        String nombreusuario = (String) objSession.getAttribute("nombreusuario");
        String token = (String) objSession.getAttribute("token");
        String nispagardt = (String) objSession.getAttribute("nispagardt");

        //CALCULO DE LISTA DE contratos a pagar
        String[] listNisPagar = nispagardt.split("nis");
        String finalamountcalc = (String) objSession.getAttribute("finalamountcalc");
        String idReferece = (String) objSession.getAttribute("idReferece");

        String successIndicator = (String) objSession.getAttribute("successIndicator");
        System.out.println("successIndicator::::: " + successIndicator);
        String resultIndicator = request.getParameter("resultIndicator");
        String parametro = request.getParameter("parametro");
        String mensajeParametro = new String();

        RutaProperties rp = new RutaProperties();
        String urlProperties = rp.getRuta();
        InputStream isArchivo = new FileInputStream(urlProperties);
        Properties oProperties = new Properties();
        oProperties.load(isArchivo);

        //CALCULO DE LISTA DE todos los contratos vinculados
        Date fechaactual = new Date();
        ArrayList<ServicioNISDAO> lstServ = new ArrayList();
        String SELSALDOS = oProperties.getProperty("SELSALDOS");
        URL urlsaldos = new URL(SELSALDOS + session.getAttribute("usuario"));

        HttpURLConnection connsaldos = (HttpURLConnection) urlsaldos.openConnection();
        connsaldos.setRequestMethod("GET");
        connsaldos.setRequestProperty("Accept", "application/json");
        connsaldos.setRequestProperty("Authorization", "Bearer " + session.getAttribute("token"));

        if (connsaldos.getResponseCode() != 200) {
            System.out.println(idReferece + " ::SELSALDOS No posible recalcular el saldo response code: " + fechaactual + " / " + connsaldos.getResponseCode());

            response.sendRedirect("sweetAlertError500.html");
//                        throw new RuntimeException("Failed : HTTP error code : " + connsaldos.getResponseCode());

        } else {
            System.out.println("::SELSALDOS RecalcularSaldos :: " + fechaactual + " / " + idReferece);
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
                System.out.println(idReferece + " IOException selsaldos recalcular ::: " + ioe);
            } catch (JSONException ex) {
                System.out.println(idReferece + " JSONException selsaldos recalcular ::: " + ex);
            }
        }
        //CALCULO DE LISTA DE todos los contratos vinculados

        //PARAMETROS EN VISTA DE RESPUESTA
        System.out.println("parametro: " + parametro);
        System.out.println("successIndicator " + successIndicator);
        System.out.println("resultIndicator " + resultIndicator);
        if (parametro.equalsIgnoreCase("00") && successIndicator.equalsIgnoreCase(resultIndicator)) {
            mensajeParametro = "Pago Exitoso";
            System.out.println("PAGO EXITOSO IDREFERENCE ::: " + idReferece);

            //SE CONSULTA RETRIVE
            System.out.println("try RETRIVE: " + idReferece);
            String RETRIVE = oProperties.getProperty("RETRIVE");

            for (int i = 1; i < 10; ++i) {
                URL urlRetrive = new URL(RETRIVE + idReferece + "&transaction=" + i);
                System.out.println("urlRetrive :  " + urlRetrive);
                HttpURLConnection conRetrive = (HttpURLConnection) urlRetrive.openConnection();
                conRetrive.setRequestMethod("GET");
                conRetrive.setRequestProperty("Content-Type", "application/json; utf-8");
                conRetrive.setRequestProperty("Accept", "application/json");
                conRetrive.setDoOutput(true);
                conRetrive.setRequestProperty("Authorization", "Bearer " + session.getAttribute("token"));
                if (conRetrive.getResponseCode() != 200) {
                    System.out.println("RETRIVE FALSE");
                } else {
                    System.out.println("RETRIVE true");
                    try {

                        InputStream inputStream = conRetrive.getInputStream();
                        String json = new String();
                        BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream), 1);
                        String line;
                        while ((line = bufferedReader.readLine()) != null) {
                            json = line;
                        }
                        inputStream.close();
                        bufferedReader.close();
//                    System.out.println("json ::: " + json);
                        JSONObject jsonObj = new JSONObject(json);

                        if (jsonObj.get("success").toString() == "true") {
                            if ("null" != jsonObj.get("Response").toString()) {

                                //System.out.println("::jsonObj.get(\"Response\").toString():: "+jsonObj.get("Response").toString());
                                JSONObject jsonObjloginresponse = new JSONObject(jsonObj.get("Response").toString());
                                String jsonObjloginresponseSTR = jsonObjloginresponse.toString();
                                System.out.println("jsonObjresponseSTR: " + jsonObjloginresponseSTR);

                                JSONObject jsondta = new JSONObject(jsonObjloginresponse.get("data").toString());
                                System.out.println("jsondta " + jsondta.toString());
                                JSONObject jsondtaresponse = new JSONObject(jsondta.get("response").toString());
                                System.out.println("jsondtaresponse " + jsondtaresponse.toString());
                                String jsondtaresponseacquirerCode = jsondtaresponse.get("acquirerCode").toString();
                                JSONObject jsonObjtransaction = new JSONObject(jsondta.get("transaction").toString());
                                String strtransaction = jsonObjtransaction.toString();
                                System.out.println("strtransaction: " + strtransaction);
                                strauthorizationCode = jsonObjtransaction.get("authorizationCode").toString();
                                System.out.println("jsondtaresponseacquirerCode: " + jsondtaresponseacquirerCode.toString());
                                if (jsondtaresponseacquirerCode.toString().equalsIgnoreCase("00")) {
                                    System.out.println("detectado jsondtaresponseacquirerCode: " + jsondtaresponseacquirerCode);

                                    System.out.println("strauthorizationCode : " + strauthorizationCode);
                                    i = 10;
                                } else {
                                    System.out.println("detectado jsondtaresponseacquirerCode: " + jsondtaresponseacquirerCode);

                                    parametro = strauthorizationCode;
                                }
                            }
                        } else {
                            i = 10;
                        }

                    } catch (IOException ioe) {

                    } catch (JSONException ex) {

                    }

                }
            }
            //SE CONSULTA RETRIVE

            int iter = 1;

            int longiter = 1;

            //ITERACIÖN DE LISTAS
            for (String n : listNisPagar) {

                for (ServicioNISDAO sn : lstServ) {

                    if (n.substring(0, 9).equalsIgnoreCase(sn.getV_nis_rad())) {

                        //SE ACTUALIZA SAP
                        System.out.println("try PAYMENTSAP NIS: " + sn.getV_nis_rad() + "/" + fechaactual + " / " + idReferece + " amount: " + sn.getV_importe());

                        String PAYMENTSAP = oProperties.getProperty("PAYMENTSAP");

                        URL urlinsertarServicioPago = new URL(PAYMENTSAP);
                        System.out.println("urlPaymentSap: " + PAYMENTSAP + "::: " + sn.getV_nis_rad() + "/" + fechaactual + " / " + idReferece);
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

                        String fconsecutivolongiter = "" + longiter;
                        for (int i = fconsecutivolongiter.length(); i < 4; i++) {
                            fconsecutivolongiter = "0" + fconsecutivolongiter;
                        }

//                        String IDMessageHeader = "PAY-" + dtIDMessageHeader + "-" + sn.getV_nis_rad().substring(0, 4) + fconsecutivo;//(Pay + fecha (ddMMyyyy) + nis5- consecutivo(00001))";
                        String IDMessageHeader = (String) objSession.getAttribute("IDMessageHeader");
                        String IDMessageHeader2 = IDMessageHeader + "-" + fconsecutivolongiter;

                        String DateCreationMessageHeader = DtCreationMessageHeader;//(formato: yyyy-MM-dd’T’HH:mm:ss’Z’).
                        String CashPointReferenceID = "E90";//(Caja)//Qbits code web eAyd??????
                        String CashPointOfficeReferenceID = "SADM_1BMX";//(Oficina)TODO
//                        String CashPointPaymentGroupReferenceID = "EAF-" + dtIDMessageHeader + "-001";//(Grupos del Pagos del Dia INT-ddMMyyyy- consecutivo).
                        String CashPointPaymentGroupReferenceID = "EBX-" + dtIDMessageHeader + "-001";//(Grupos del Pagos del Dia INT-ddMMyyyy- consecutivo).

                        String PaymentTransactionID = IDMessageHeader + "-" + fconsecutivolongiter;//(Igual que el parámetro “ID”).
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
                                + "  \"IDMessageHeader\": \"" + IDMessageHeader2 + "\",\n"
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
                            System.out.println("jsondata consumir PAYMENTSAP ::: " + sn.getV_nis_rad() + "/" + fechaactual + " / " + idReferece + jsondata);
                            inputStreamdata.close();
                            bufferedReaderdata.close();
                            JSONObject jsonObjdata = new JSONObject(jsondata);

                            if (jsonObjdata.get("success").toString() == "true") {
                                String msg = jsonObjdata.get("message").toString();
                                msg = msg.replace("Ã±", "ñ");
                                System.out.println("success service PAYMENTSAP TRUE:::::" + sn.getV_nis_rad() + "/" + fechaactual + " / " + idReferece);
                                longiter = longiter + 1;

                            } else {
                                System.out.println("success service PAYMENTSAP FALSE:::::" + sn.getV_nis_rad() + "/" + fechaactual + " / " + idReferece);

                            }
                        } catch (JSONException ex) {
                            System.out.println(idReferece + " PAYMENTSAP No posible recalcular el saldonsertar el pago response code: " + fechaactual + " / " + ex);
                        }
                        //SE ACTUALIZA SAP

                        //SE ACTUALIZA SQL
                        //INSERTAR PAGOSQL
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
                                + "  \"v_referencia\": \"" + idReferece + "\",\n"
                                + "  \"email\": \"" + session.getAttribute("usuario") + "\",\n"
                                + "  \"P_Direccion\": \"" + sn.getP_Direccion() + "\",\n"
                                + "  \"authorizationId\": \"" + strauthorizationCode + "\"\n"
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

                            } else {
                                System.out.println("success service coninsertarServicioPagoSQL FALSE:::::");

                            }
                        } catch (JSONException ex) {
                            ex.printStackTrace();
                        }
                        //INSERTAR PAGOSQL
                        //UPDTREFRENCE
                        //Notificacion UpdateReferencia
                        String UPDATEREFERENCIA = oProperties.getProperty("UPDATEREFERENCIA");
                        System.out.println("" + UPDATEREFERENCIA + " ::: " + idReferece);
                        URL urlUpdateReferencia = new URL(UPDATEREFERENCIA);
                        HttpURLConnection conUpdateReferencia = (HttpURLConnection) urlUpdateReferencia.openConnection();
                        conUpdateReferencia.setRequestMethod("POST");
                        conUpdateReferencia.setRequestProperty("Content-Type", "application/json; utf-8");
                        conUpdateReferencia.setDoOutput(true);
                        conUpdateReferencia.setRequestProperty("Authorization", "Bearer " + session.getAttribute("token"));

                        String jsonIStr = "{\n"
                                + "  \"Mensaje\": \"" + parametro + "\" ,\n"
                                + "  \"Referencia\": \"" + idReferece + "\",\n"
                                + "  \"Campo\": \"" + strauthorizationCode + "\",\n"
                                + "  \"InterlocutorComercial\": \"" + sn.getPartner() + "\",\n"
                                + "  \"CuentaContrato\": \"" + sn.getVkont() + "\"\n"
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
                                System.out.println("success service conUpdateReferencia TRUE::::: ::");

                            } else {
                                System.out.println("success service conUpdateReferencia FALSE:::::");

                            }
                        } catch (JSONException ex) {
                            System.out.println("JSONException service conUpdateReferencia FALSE:::::" + ex);
                        }
                        //Notificacion UpdateReferenciaSQL 
                        //UPDTREFERENCE

                    }
                }
            }

        } else if (parametro.equalsIgnoreCase("tt")) {
            mensajeParametro = "Se agotó el tiempo vuelva a intentar.";
            System.out.println("PAGO NO EXITOSO IDREFERENCE::: " + idReferece);
            //ITERACIÓN DE LISTAS
            for (String n : listNisPagar) {

                for (ServicioNISDAO sn : lstServ) {

                    if (n.substring(0, 9).equalsIgnoreCase(sn.getV_nis_rad())) {
                        //SU ACTUALIZA SQL
                        //Notificacion UpdateReferencia
                        String UPDATEREFERENCIA = oProperties.getProperty("UPDATEREFERENCIA");
                        System.out.println("" + UPDATEREFERENCIA + " ::: " + idReferece);
                        URL urlUpdateReferencia = new URL(UPDATEREFERENCIA);
                        HttpURLConnection conUpdateReferencia = (HttpURLConnection) urlUpdateReferencia.openConnection();
                        conUpdateReferencia.setRequestMethod("POST");
                        conUpdateReferencia.setRequestProperty("Content-Type", "application/json; utf-8");
                        conUpdateReferencia.setDoOutput(true);
                        conUpdateReferencia.setRequestProperty("Authorization", "Bearer " + session.getAttribute("token"));

                        String jsonIStr = "{\n"
                                + "  \"Mensaje\": \"" + parametro + "\" ,\n"
                                + "  \"Referencia\": \"" + idReferece + "\",\n"
                                + "  \"Campo\": \"-\",\n"
                                + "  \"InterlocutorComercial\": \"" + sn.getPartner() + "\",\n"
                                + "  \"CuentaContrato\": \"" + sn.getVkont() + "\"\n"
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
                                System.out.println("success service conUpdateReferencia TRUE::::: ::");

                            } else {
                                System.out.println("success service conUpdateReferencia FALSE:::::");

                            }
                        } catch (JSONException ex) {
                            System.out.println("JSONException service conUpdateReferencia FALSE:::::" + ex);
                        }
                        //Notificacion UpdateReferenciaSQL 

                    }
                }
            }
        } else {
            mensajeParametro = "No fue posible generar la transacción."
                    + "Vuelva a intentar más tarde";
            System.out.println("PAGO NO EXITOSO IDREFERENCE::: " + idReferece);
            //ITERACIÓN DE LISTAS
            for (String n : listNisPagar) {

                for (ServicioNISDAO sn : lstServ) {

                    if (n.substring(0, 9).equalsIgnoreCase(sn.getV_nis_rad())) {
                        //SU ACTUALIZA SQL
                        //Notificacion UpdateReferencia
                        String UPDATEREFERENCIA = oProperties.getProperty("UPDATEREFERENCIA");
                        System.out.println("" + UPDATEREFERENCIA + " ::: " + idReferece);
                        URL urlUpdateReferencia = new URL(UPDATEREFERENCIA);
                        HttpURLConnection conUpdateReferencia = (HttpURLConnection) urlUpdateReferencia.openConnection();
                        conUpdateReferencia.setRequestMethod("POST");
                        conUpdateReferencia.setRequestProperty("Content-Type", "application/json; utf-8");
                        conUpdateReferencia.setDoOutput(true);
                        conUpdateReferencia.setRequestProperty("Authorization", "Bearer " + session.getAttribute("token"));

                        String jsonIStr = "{\n"
                                + "  \"Mensaje\": \"x1\" ,\n"
                                + "  \"Referencia\": \"" + idReferece + "\",\n"
                                + "  \"Campo\": \"-\",\n"
                                + "  \"InterlocutorComercial\": \"" + sn.getPartner() + "\",\n"
                                + "  \"CuentaContrato\": \"" + sn.getVkont() + "\"\n"
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
                                System.out.println("success service conUpdateReferencia TRUE::::: ::");

                            } else {
                                System.out.println("success service conUpdateReferencia FALSE:::::");

                            }
                        } catch (JSONException ex) {
                            System.out.println("JSONException service conUpdateReferencia FALSE:::::" + ex);
                        }
                        //Notificacion UpdateReferenciaSQL 

                    }
                }
            }
        }


%>

<!DOCTYPE html>
<html>
    <head>
        <link href="imagenes/logo_transp.gif" rel="shortcut icon" type="image/x-icon" />
        <link href="imagenes/logo_transp.gif" rel="apple-touch-icon" />
        <meta name="tipo_contenido"  content="text/html;" http-equiv="content-type" charset="utf-8">
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <meta http-equiv="Content-Type" content="text/html charset=utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <%@ include file="HeaderOptions.jsp" %>
        <title>Pago de Servicios Agua y Drenaje de Monterrey</title>
        <link href="styles/webflow1.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow4.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow3.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" src="js/script.js"></script>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    </head>
    <body oncontextmenu="return false;" >
        <%@include file="Top.jsp" %>

        <div class="container-fluid my-4">

            <div class="row py2">

                <div class="container py2">

                    <div style="width: 100%;margin-left: 80px;">                            

                        <hr>

                        <h2 colspan="4">Datos de Respuesta de Transacción</h2>
                        <br>


                        <h6 >Estatus de Pago: <%=mensajeParametro%></h6>
                        <br>
                        <h6 >Código de Respuesta <%=parametro%> | <%=mensajeParametro%></h6>
                        <br>

                        <%
                            if (parametro.equalsIgnoreCase("00")) {
                        %>
                        <h6 >Autorización Bancaria <%=strauthorizationCode%></h6>
                        <%

                            }

                        %>

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
<%}%>