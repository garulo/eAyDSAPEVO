<%@page import="java.io.OutputStream"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.io.IOException"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="com.ayd.dao.ServicioNISDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Properties"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="com.ayd.dao.RutaProperties"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    HttpSession objSession = request.getSession();
    String usuario = (String) objSession.getAttribute("usuario");
    System.out.println("usuario inicio sesion:: " + usuario);

    if (null == usuario) {
        
    } else if (usuario.equals("")) {
     
    } else {
        String parametro = request.getParameter("parametro");
        String nispagardt = (String) objSession.getAttribute("nispagardt");
        String[] listNisPagar = nispagardt.split("nis");
        String mensajeParametro = new String();
        String idReferece = (String) objSession.getAttribute("idReferece");
        
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
        
        if (parametro.equalsIgnoreCase("c1")) {
            mensajeParametro = "Pago Cancelado";
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
            } //ITERACION LISTAS

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


                        <h6 >Estatus de Pago: c1 </h6>
                        <br>
                        <h6 >Código de Respuesta c1 | Pago cancelado</h6>
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