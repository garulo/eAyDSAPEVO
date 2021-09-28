<%@page import="java.io.FileInputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession objSession = request.getSession(false);
    String usuario = (String) objSession.getAttribute("usuario");
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

        String strNombreLegible = new String(nombreusuario.getBytes("ISO-8859-1"), "UTF-8");
        InputStream isArchivo = new FileInputStream((String) objSession.getAttribute("urlProperties"));
        Properties oProperties = new Properties();
        oProperties.load(isArchivo);
        String INICIO = oProperties.getProperty("INICIO");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <%@ include file="HeaderOptions.jsp" %>
        <title>Pago de Servicios - VPC</title>
        <link href="styles/webflow1.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow4.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow3.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100&display=swap" rel="stylesheet">
        <script type="text/javascript" async="" src="https://ssl.google-analytics.com/ga.js"></script>
    </head>
    <body oncontextmenu="return false;" >
        <!-- HEADER -->
        <%@include file="Top.jsp" %>

        <div class="container-fluid my-4">
            <div class="row py2">
                <div class="container py2">

                    <%@include file="MenuServicios.jsp" %>
                    <div id="informacion-alertas" class="col-12 col-lg-9 float-left">

                        <label style="font-family: 'Roboto', sans-serif;font-size: 16px;font-weight: 300;" >Seleccione el servicio que desee para que le llegue un aviso a su correo electrónico. Puede cambiar su selección cuando guste.</label>

                        <input type="hidden" name="email" value="garulo.trabajo@gmail.com">



                        <table class="table table-responsive table-striped table-sm" id="tabla_servicios2">
                            <tbody><tr id="servico_encabezado">
                                    <th width="10%">Contrato</th>
                                    <th width="50%">Direccion</th>

                                    <th width="15%" style="text-align: right;">Enviar factura electrónica</th>

                                    <th width="15%" style="text-align: right;">Enviar factura a domicilio</th>



                                </tr>

                                <%
                                    String SELSALDOS = oProperties.getProperty("SELSALDOS");

                                    URL url = new URL(SELSALDOS + usuario);
                                    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                                    conn.setRequestMethod("GET");
                                    conn.setRequestProperty("Accept", "application/json");
                                    conn.setRequestProperty("Authorization", "Bearer " + token);

                                    //System.out.println("conn.getResponseCode() :: "+conn.getResponseCode());
                                    if (conn.getResponseCode() != 200) {
                                        System.out.println("Failed login : HTTP error code : " + conn.getResponseCode());
                                        response.sendRedirect("Login.jsp");
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
                                            // System.out.println("SELSALDOS json ::: " + json);
                                            JSONObject jsonObj = new JSONObject(json);

                                            JSONObject jsonObjservresponse = new JSONObject(jsonObj.get("Response").toString());
                                            //System.out.println("SELSALDOS strjsonObjservresponsedata :: " +jsonObjservresponse.toString());
                                            String strjsonObjservresponsedata = jsonObjservresponse.get("data").toString();

                                            strjsonObjservresponsedata = strjsonObjservresponsedata.replace("[", "");
                                            strjsonObjservresponsedata = strjsonObjservresponsedata.replace("]", "");

                                            // System.out.println("strjsonObjservresponsedata :: " + strjsonObjservresponsedata);
                                            JSONObject jsonObjservresponsedata = new JSONObject(strjsonObjservresponsedata);
                                            //System.out.println("jsonObjservresponsedata :: " + jsonObjservresponsedata.toString());

                                            JSONArray results = new JSONArray(jsonObjservresponse.get("data").toString());
                                            //System.out.println("result:: " + results.length());
                                            for (int i = 0; i < results.length(); i++) {
                                                JSONObject aux = results.getJSONObject(i);
                                                //System.out.println("aux" + aux.toString());


                                %> 
                                <tr id="servicio_detalle<%=aux.get("NIS").toString()%>">
                                    <%

                                        //System.out.println("NIS: " + aux.get("NIS").toString());
//                                                 System.out.println("Direccion: "+aux.get("Direccion").toString());
//                                                 System.out.println("Total "+aux.get("v_totaladeu").toString());

                                        String strDomicilio = "" + aux.get("Direccion").toString() + " ";
                                        String strdomicilioLegible = new String(strDomicilio.getBytes("ISO-8859-1"), "UTF-8");

                                        String SELESTATUSENVIO = oProperties.getProperty("SELESTATUSENVIO");
                                        String EnvioDomicilio = new String();
                                        String EnvioCorreo = new String();
                                        String correo = new String();
                                        String domicilio = new String();

                                        URL urlestatus = new URL(SELESTATUSENVIO + aux.get("NIS").toString());
                                        System.out.println("urlestatusenvio :" +urlestatus);
                                        HttpURLConnection connestatus = (HttpURLConnection) urlestatus.openConnection();
                                        connestatus.setRequestMethod("GET");
                                        connestatus.setRequestProperty("Accept", "application/json");
                                        connestatus.setRequestProperty("Authorization", "Bearer " + token);
                                       // System.out.println("connestatus.getResponseCode() :: " + aux.get("NIS").toString() + " / " + conn.getResponseCode());
                                        if (connestatus.getResponseCode() != 200) {
                                           System.out.println("Failed SELESTATUSENVIO : HTTP error code : " + connestatus.getResponseCode());
                                            response.sendRedirect("Login.jsp");
                                            //throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
                                        } else {
                                            try {

                                                InputStream inputS = connestatus.getInputStream();
                                                String jsn = new String();
                                                BufferedReader bufferedR = new BufferedReader(new InputStreamReader(inputS), 1);
                                                String lin;
                                                while ((lin = bufferedR.readLine()) != null) {
                                                    jsn = lin;
                                                }
                                                inputS.close();
                                                bufferedR.close();
                                                System.out.println("SELESTATUSENVIO json ::: " + jsn);
                                                JSONObject jsonO = new JSONObject(jsn);

                                                JSONObject jsonObjresponse = new JSONObject(jsonO.get("Response").toString());
                                                //System.out.println("SELESTATUSENVIO jsonObjresponse :: " + jsonObjresponse.toString());
                                                String strjsonObjresponsedata = jsonObjresponse.get("data").toString();
                                                //System.out.println("SELESTATUSENVIO strjsonObjresponsedata :: " + strjsonObjresponsedata.toString());
                                                JSONObject jsonObjdata = new JSONObject(strjsonObjresponsedata);

                                                EnvioDomicilio = jsonObjdata.get("EnvioDomicilio").toString();
                                                EnvioCorreo = jsonObjdata.get("EnvioCorreo").toString();
                                                //System.out.println("EnvioDomicilio: " + EnvioDomicilio + " EnvioCorreo: " + EnvioCorreo);
                                                if (EnvioDomicilio.equalsIgnoreCase("true")) {
                                                    domicilio = "checked";
                                                } else {
                                                    domicilio = "";
                                                }
                                                if (EnvioCorreo.equalsIgnoreCase("true")) {
                                                    correo = "checked";
                                                } else {
                                                    correo = "";
                                                }

                                            } catch (IOException ioe) {
                                                ioe.printStackTrace();
                                            } catch (JSONException ex) {
                                                ex.printStackTrace();
                                            }
                                        }
                                    %>


                                    <td><%=aux.get("NIS").toString()%></td>
                                    <td><%=strdomicilioLegible%></td>

                                    <td style="text-align: center;"><input type="checkbox" <%=correo%> name="SM001" id="chk1<%=aux.get("NIS").toString()%>" onchange="validationFactura<%=aux.get("NIS").toString()%>()" >

                                    </td><td style="text-align: center;"><input type="checkbox" <%=domicilio%> id="chk2<%=aux.get("NIS").toString()%>" name="chk2<%=aux.get("NIS").toString()%>"  onchange="validationFactura<%=aux.get("NIS").toString()%>()"></td>

                            <script>
                                function validationFactura<%=aux.get("NIS").toString()%>() {
                                    if (document.getElementById("chk1<%=aux.get("NIS").toString()%>").checked === true && document.getElementById("chk2<%=aux.get("NIS").toString()%>").checked === true) {
                                        //alert("Se envía correo y domicilio 2 chk1 true :: chk2 true");
                                        var niss = '2<%=aux.get("NIS").toString()%>';
                                        //alert('::: ' + niss);
                                        var nis = document.getElementById("nisalert").value;
                                        nis = nis.replace("///" + niss, "");
                                        nis = nis + "///" + niss;

                                        document.getElementById("nisalert").value = nis;

                                        document.getElementById("btnAplicar").hidden = false;

                                    } else if (document.getElementById("chk1<%=aux.get("NIS").toString()%>").checked === false && document.getElementById("chk2<%=aux.get("NIS").toString()%>").checked === true) {
                                        //alert("Solo se envía domicilio  chk1 false :: chk2 true");
                                        document.getElementById("chk2<%=aux.get("NIS").toString()%>").checked = true;
                                        document.getElementById("chk1<%=aux.get("NIS").toString()%>").checked = false;
                                        var niss = '0<%=aux.get("NIS").toString()%>';
                                        //alert('::: ' + niss);
                                        var nis = document.getElementById("nisalert").value;
                                        nis = nis + "///" + niss;
                                        document.getElementById("nisalert").value = nis;

                                        document.getElementById("btnAplicar").hidden = false;

                                    } else if (document.getElementById("chk1<%=aux.get("NIS").toString()%>").checked === true && document.getElementById("chk2<%=aux.get("NIS").toString()%>").checked === false) {
                                        //alert("se se envia por correo 1 chk1 true :: chk2 false");
                                        var niss = '1<%=aux.get("NIS").toString()%>';
                                        //alert('::: ' + niss);
                                        var nis = document.getElementById("nisalert").value;
                                        nis = nis + "///" + niss;
                                        document.getElementById("nisalert").value = nis;

                                        document.getElementById("btnAplicar").hidden = false;

                                    } else if (document.getElementById("chk1<%=aux.get("NIS").toString()%>").checked === false && document.getElementById("chk2<%=aux.get("NIS").toString()%>").checked === false) {
                                        //alert("se envia por correo  chk1 false :: chk2 false");
                                        document.getElementById("chk1<%=aux.get("NIS").toString()%>").checked = true;
                                        document.getElementById("chk2<%=aux.get("NIS").toString()%>").checked = false;
                                        var niss = '1<%=aux.get("NIS").toString()%>';
                                        //alert('::: ' + niss);
                                        var nis = document.getElementById("nisalert").value;
                                        nis = nis + "///" + niss;
                                        document.getElementById("nisalert").value = nis;
                                        document.getElementById("btnAplicar").hidden = false;
                                    }

                                }

                            </script>


                            </td></tr>
                            <%
                                        }

                                    } catch (IOException ioe) {
                                        ioe.printStackTrace();
                                    } catch (JSONException ex) {
                                        ex.printStackTrace();
                                    }
                                }

                            %>

                            </tbody>

                        </table>


                        <p style="text-align: center;">
                            <input hidden  class="btn btn-outline-secondary" type="button" onclick="document.editAlertForm.submit();" name="btnAplicar" id="btnAplicar" value="Aplicar Notificaciones" )> 
                            <input  class="btn btn-outline-secondary" type="button" value="Cancelar" onclick="location.href = 'Inicio.jsp';">
                        </p>
                    </div>

                </div></div></div><div >
            <form name="editAlertForm" method="POST" action="servicealert">
                <input id="nisalert" name="nisalert"  hidden>
                <input id="Email" name="Email" value='<%=usuario%>' hidden>
                <input id="token" name="token" value='<%=token%>' hidden>

            </form>
        </div> 




        <!-- ********** ANALYTICS ********** -->

        <script type="text/javascript">

            var _gaq = _gaq || [];
            _gaq.push(['_setAccount', 'UA-21967627-1']);
            _gaq.push(['_trackPageview']);

            (function () {
                var ga = document.createElement('script');
                ga.type = 'text/javascript';
                ga.async = true;
                ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'https://www') + '.google-analytics.com/ga.js';
                var s = document.getElementsByTagName('script')[0];
                s.parentNode.insertBefore(ga, s);
            })();

        </script>
        <!--Bootstrap-->
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <script language="JavaScript" src="js/script.js"></script>
        <script language="JavaScript" src="js/bootstrap.js"></script>
        <script src="https://uploads-ssl.webflow.com/5ad759a356a64144486fd75f/js/webflow.d69d0ec41.js" type="text/javascript"></script>

        <script src="https://code.jquery.com/ui/1.11.2/jquery-ui.js"></script>

    </body>
</html>
<%}%>