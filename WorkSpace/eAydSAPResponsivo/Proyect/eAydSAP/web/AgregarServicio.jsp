<%@page import="java.io.FileInputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.io.IOException"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.util.Random"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.InputStream"%>
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
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <%@ include file="HeaderOptions.jsp" %>
        <title>Asignacion de Servicios</title>
        <link href="styles/webflow1.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow4.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow3.css" rel="stylesheet" type="text/css" />
        <meta name="tipo_contenido"  content="text/html;" http-equiv="content-type" charset="utf-8">
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
    </head>
    <body onload="numcol()" oncontextmenu="return false;">
    <center>
        <!-- HEADER -->
        <%@include file="Top.jsp" %>


        <div  id="content" style="width: 85%;text-align: left;">
            <div class="container-fluid my-4">
                <div class="row py2">
                    <div class="container py2">

                        <%@include file="MenuServicios.jsp" %>
                        
                        <h4 id="h4Table" class="mb-3" style="color:#3c4858;"></h4>
                        <div class="col-12 col-lg-9 float-left">
                            <script>
                                function numcol() {
                                    var rows = document.getElementById('tabla_servicios1').getElementsByTagName('tbody')[0].getElementsByTagName('tr').length - 1;
                                    var colum = "Tiene " + rows + " servicios asignados a su Cuenta en Línea:";
                                    document.getElementById("h4Table").innerHTML = colum;
                                    document.getElementById("Total").value = "0.00";
                                }
                            </script>




                            <table class="table table-responsive table-striped table-sm" id="tabla_servicios1" disabled>
                                <tbody>
                                    <tr class="encabezado" id="servico_encabezado">
                                        <th align="center" width="10%"><b>Contrato</b></th>
                                        <th align="center" width="50%"><b>Dirección</b></th>

                                    </tr>

                                    <%

                                        String SELSALDOS = oProperties.getProperty("SELSALDOS");
                                        URL url = new URL(SELSALDOS + usuario);
                                        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                                        conn.setRequestMethod("GET");
                                        conn.setRequestProperty("Accept", "application/json");
                                        conn.setRequestProperty("Authorization", "Bearer " + token);

                                        if (conn.getResponseCode() != 200) {

                                            response.sendRedirect("Login.jsp");
                                            throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());

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
                                                System.out.println("json ::: " + json);
                                                JSONObject jsonObj = new JSONObject(json);

                                                JSONObject jsonObjservresponse = new JSONObject(jsonObj.get("Response").toString());
                                                // System.out.println("strjsonObjservresponsedata :: " +jsonObjservresponse.toString());
                                                String strjsonObjservresponsedata = jsonObjservresponse.get("data").toString();
                                                Random r = new Random();

                                                strjsonObjservresponsedata = strjsonObjservresponsedata.replace("[", "");
                                                strjsonObjservresponsedata = strjsonObjservresponsedata.replace("]", "");

                                                //System.out.println("strjsonObjservresponsedata :: " +strjsonObjservresponsedata);
                                                JSONObject jsonObjservresponsedata = new JSONObject(strjsonObjservresponsedata);
                                                //System.out.println("jsonObjservresponsedata :: " + jsonObjservresponsedata.toString());

                                                JSONArray results = new JSONArray(jsonObjservresponse.get("data").toString());
                                                // System.out.println("result:: " + results.length());
                                                for (int i = 0; i < results.length(); i++) {
                                    %>
                                    <tr>
                                        <%
                                            JSONObject aux = results.getJSONObject(i);
                                            //System.out.println("NIS: "+aux.get("NIS").toString());
                                            //                                                 System.out.println("Direccion: "+aux.get("Direccion").toString());
                                            //                                                 System.out.println("Total "+aux.get("v_totaladeu").toString());
                                            String nisfact = aux.get("NIS").toString();
                                            String strDomicilio = "" + aux.get("Direccion").toString() + " ";
                                            String strdomicilioLegible = new String(strDomicilio.getBytes("ISO-8859-1"), "UTF-8");
                                        %>
                                        <td align="center" width="10%"><%=aux.get("NIS").toString()%>&nbsp;</td>

                                        <td width="50%"><%=strdomicilioLegible%> </td>


                                    </tr>
                                    <%
                                                }

                                            } catch (IOException ioe) {

                                            } catch (JSONException ex) {

                                            }
                                        }
                                    %>




                                </tbody></table>
                                    <div id="informacion-req" class="clearx">
                            <div class="col-12 col-lg-6 float-left  my-4 mp-4">
                                <p><b>Para agregar un servicio, es necesario que inserte los datos de un recibo de agua.</b></p>

                                <p><b>Los datos que necesita son:</b></p>
                                <ul>
                                    <li>Contrato (Número de contrato), ejemplo: 536979599</li>
                                </ul>
                                <b>Para ver la localización de estos datos dentro de su recibo de Agua y Drenaje de click <a href="javascript:window.open('example.html', 'name', '690', '450', 'yes');">Aquí</a></b>

                            </div>
                        </div>

                        
                            <div class="col-12 col-lg-6 float-left card py-4">
                                <form id="FormNir" name="FormNir" method="POST" action="registrarservicio">
                                    <label for="NIR1" id="nir"><b>CONTRATO:</b></label>
                                    <input type="text" id="NIR1" name="NIR1" onblur="validarNir();"  size="9" maxlength="9" minlength="9" class="form-control">
                                    <script>
                                        function validarNir() {
                                            var longitucadena = document.getElementById("NIR1").value;
                                            var patt = new RegExp(/^[0-9]{2}[0-9]{7}$/g);
                                            var res = patt.test(longitucadena);
                                            if (res === true) {
                                                if (longitucadena.length === 9) {

                                                } else {
                                                    swal("El número de Contrato no es válido.!", "Longitud inválida. Debe ser numerico de 9 dígitos", "error").then((value) => {
                                                        document.getElementById("NIR1").value = "";
                                                    });
                                                    document.getElementById("NIR1").value = "";
                                                }
                                            } else {

                                                swal("El número de Contrato no es válido.!", " No use letras y debe contener 9 dígitos numericos. Ejemplo: 546756789", "error").then((value) => {
                                                    document.getElementById("NIR1").value = "";
                                                });
                                                document.getElementById("NIR1").value = "";
                                            }
                                        }
                                    </script>
                                    <label hidden for="lecturaAnterior" id="lecturaAnteriorlbl"><b>Lectura Anterior:</b></label>
                                    <input hidden type="number" id="lecturaAnterior" name="lecturaAnterior" value="0" size="10" maxlength="10" class="form-control">
                                    <label id="Asignar">&nbsp;</label>
                                    <input class="btn btn-outline-secondary btn-lg btn-block " type="button" value="Agregar Servicio" onclick="validateForm();">
                                    <input hidden name="token" value="<%=token%>">
                                    <input hidden name="email" value="<%=usuario%>">
                                </form>
                                <script language="JavaScript">
                                    function validateForm() {
                                        if (document.getElementById("NIR1").value !== "") {
                                            if (document.getElementById("lecturaAnterior").value !== "") {
                                                $("#FormNir").submit();
                                            } else {
                                                swal("Lectura Anterior es requerida", "No puede estar vacia", "error").then((value) => {
                                                    window.parent.location.href = 'AgregarServicio.jsp'
                                                });

                                                document.getElementById("lecturaAnterior").value = '';
                                            }

                                        } else {
                                            swal("El número de contrato es requerido", "No puede estar vacío", "error").then((value) => {
                                                window.parent.location.href = 'AgregarServicio.jsp'
                                            });

                                            document.getElementById("NIR1").value = '';
                                        }

                                    }
                                </script>
                            </div>
                        </div>
                    </div>
                </div>  
            </div>

        </div>
        <%@include file="Bottom.jsp" %>  
    </center>

</body>
</html>
<%}%>