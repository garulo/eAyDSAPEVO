<%@page import="java.io.FileInputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.util.Random"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.io.IOException"%>
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
        ArrayList<String> lstnis = new ArrayList<String>();
        String strNombreLegible = new String(nombreusuario.getBytes("ISO-8859-1"), "UTF-8");
        InputStream isArchivo = new FileInputStream((String) objSession.getAttribute("urlProperties"));
        Properties oProperties = new Properties();
        oProperties.load(isArchivo);
         String INICIO = oProperties.getProperty("INICIO");

%>
<!DOCTYPE html>
<html>
    <head>

        <meta http-equiv="Content-Type" content="text/html charset=utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <%@ include file="HeaderOptions.jsp" %>
        <title>Pago de Servicios - VPC</title>
        <link href="styles/webflow1.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow4.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow3.css" rel="stylesheet" type="text/css" />
        <link href="styles/web.css" rel="stylesheet" type="text/css" />
        <link href="styles/bootstrap-grid.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    </head>
    <body onload="numcol()" oncontextmenu="return false;">
        <!-- HEADER -->
        <div id="content">
            <%@include file="Top.jsp" %>

            <br>


            <div class="container-fluid my-4">
                <div class="row py2">
                    <div class="container py2">

                        <%@include file="MenuServicios.jsp" %>
                        <!--<h4 id="h4Table2" class="mb-3" style="color:#3c4858;" ></h4><h6 id="h6Table2" title="Agregar un servicio">Para agregar un servicio presiona <a href="AgregarServicio.jsp">Aquí</a></h6>-->
                        <div id="tblServicios" class="col-12 col-lg-9 float-left">
                            <div id="contenido_informacion1" >
                                <script>
                                    function numcol() {
                                        let params = new URLSearchParams(location.search);
                                        var cartamsj = params.get('cartamsj');

                                        if ("null" === cartamsj) {
                                            document.getElementById("AvisoCNATrue").hidden = false;
                                            document.getElementById("AvisoCNAFalse").hidden = false;
                                        } else if (cartamsj === "0") {

                                            var cmsj = params.get('cmsj');
                                            cmsj = cmsj.replace('�?', 'Á');

                                            document.getElementById("AvisoCNATrue").hidden = true;
                                            document.getElementById("AvisoCNAFalse").hidden = false;
                                            document.getElementById("cmsj").innerHTML = cmsj;
                                        } else if (cartamsj === "1") {
                                            document.getElementById("AvisoCNATrue").hidden = false;
                                            document.getElementById("AvisoCNAFalse").hidden = true;

                                        }
                                        var rows = document.getElementById('tabla_servicios1').getElementsByTagName('tbody')[0].getElementsByTagName('tr').length - 2;
                                        if (rows !== 0) {
                                            var colum = "Tiene " + rows + " servicios asignados a su Cuenta en Línea:";
                                            document.getElementById("h4Table").innerHTML = colum;
                                            document.getElementById("Total").value = "0.00";
                                            document.getElementById("tblServicios").hidden = false;
                                            document.getElementById("h4Table2").hidden = true;
                                            document.getElementById("h6Table2").hidden = true;
                                        } else {
                                            var colum = "No tiene servicios asignados en tu Línea. ";
                                            document.getElementById("h4Table2").innerHTML = colum;

                                            document.getElementById("tblServicios").hidden = true;
                                            document.getElementById("h4Table2").hidden = false;
                                            document.getElementById("h6Table2").hidden = false;
                                        }
                                    }
                                </script>

                                <!-- <label id="h4Table" style="font-family: 'Roboto', sans-serif;font-size: 16px;font-weight: 300;color:#3c4858;" >Seleccione el servicio que desee para que le llegue un aviso a su correo electrónico. Puede cambiar su selección cuando guste.</label>-->



                                <table  class="table table-sm table-responsive table-striped" id="tabla_servicios1">
                                    <tbody>
                                        <tr class="encabezado" id="servico_encabezado">
                                            <th align="center" width="10%"><b>Contrato</b></th>
                                            <th align="center" width="30%"><b>Dirección</b></th>
                                            <th align="center" width="20%"><b>Saldo</b></th>
                                            <th align="center"  width="25%"><b>Carta de No Adeudo</b></th>

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
                                        %>
                                        <tr>
                                            <%
                                                 JSONObject aux = results.getJSONObject(i);
//                                                System.out.println("NIS: "+aux.get("NIS").toString());
//                                                 System.out.println("Direccion: "+aux.get("Direccion").toString());
//                                                 System.out.println("Total "+aux.get("v_totaladeu").toString());
                                                String nisfact = aux.get("NIS").toString();
                                                lstnis.add(nisfact);
                                                String strDomicilio = "" + aux.get("Direccion").toString() + " ";
                                                String strdomicilioLegible = new String(strDomicilio.getBytes("ISO-8859-1"), "UTF-8");

                                            %>
                                            <td align="center" width="10%"><%=aux.get("NIS").toString()%>&nbsp;</td>

                                            <td width="50%"><%=strdomicilioLegible%> </td>

                                            <td width="8%"><%=aux.get("v_totaladeu".toString())%>&nbsp;</td>
                                            <%
                                                if (aux.get("v_totaladeu").toString().equalsIgnoreCase("0.00")) {
                                            %>

                                            <td style="text-align: center;" ><input class="btn btn-outline-secondary2" type="button" value="Solicitar" onclick="solicitarCarta('<%=aux.get("NIS").toString()%>', '<%=usuario%>')"></td>                                  
                                                <%
                                                } else {
                                                %>
                                            <td style="text-align: center;" width="5%"> <a href="<%=INICIO%>"><i class="fa fa-address-card-o" aria-hidden="true"></i>Pagar</a></td>

                                            <%}%>

                                        </tr>
                                        <tr>
                                            <td align="center" width="10%"></td>

                                            <td width="50%"></td>

                                            <td width="8%"></td>
                                            <td style="text-align: center;" width="5%"> </td>

                                        </tr>
                                        <%
                                                    }

                                                } catch (IOException ioe) {

                                                } catch (JSONException ex) {

                                                }
                                            }

                                        %>


                                    </tbody></table>
                                <hr>
                                <div class="text-right" >

                                    Para generar la Carta de No Adeudo, se debe cubrir el saldo en el servicio.&nbsp;&nbsp;&nbsp;

                                </div>
                                <hr>
                                <div hidden id="AvisoCNATrue" class="alert alert-success text-center alert-link" role="alert"> <i class="fas fa-check-circle fa-lg"></i> Carta de No Adeudos enviada con éxito.  <label>Por Favor revise su correo en un momento.</label></div>
                                <div hidden id="AvisoCNAFalse" class="alert alert-danger text-center alert-link" role="alert"> <i class="fas fa-check-circle fa-lg"></i> Carta no enviada. <label id="cmsj"></label></div>

                                <script>
                                    function solicitarCarta(nis, correo) {

                                        document.getElementById("niscarta").value = nis;
                                        document.getElementById("emailcarta").value = correo;
                                        document.getElementById("solicitarCartaFrom").submit();
                                    }
                                </script> 
                            </div>
                        </div>
                    </div>
                </div>
            </div>



            <div>
                <form id="solicitarCartaFrom" name="solicitarCartaFrom" method="POST" action="solicitarcarta">
                    <input id="niscarta" name="niscarta" hidden >
                    <input id="emailcarta" name="emailcarta" hidden >
                </form>
            </div></div>
                                        
    </body>
</html>
<%}%>