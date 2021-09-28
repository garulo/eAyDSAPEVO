<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.util.Date"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="com.ayd.dao.RutaProperties"%>
<%@page import="com.ayd.dao.RutaProperties"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% HttpSession objSession = request.getSession(false);
    String usuario = (String) objSession.getAttribute("usuario");
//    System.out.println("usuario inicio sesion:: " + usuario);
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
        RutaProperties rp = new RutaProperties();
        String urlProperties = rp.getRuta();
        objSession.setAttribute("urlProperties", urlProperties);
        InputStream isArchivo = new FileInputStream((String) objSession.getAttribute("urlProperties"));
        Properties oProperties = new Properties();
        oProperties.load(isArchivo);
        String INICIO = oProperties.getProperty("INICIO");
        if (INICIO.equalsIgnoreCase("InicioControl.jsp")) {
            System.out.println("Inicio redirecciona a InicioCOntrol por Properties detectado");
            response.sendRedirect(INICIO);
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
        <title>Consulta de reporte</title>
        <link href="styles/webflow1.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow4.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow3.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" src="js/script.js"></script>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>

    </head>
    <body oncontextmenu="return false;" >
     <%@include file="Top.jsp" %>    
   
        <div id="content" >
        <center>
            <div class="container-fluid my-4">
                <div class="row py2">
                 <div class="container py2">   
                    <%@include file="MenuServicios.jsp" %>
                    <div class="col-12 col-lg-6 float-left" >
                    
                        <div style="min-width: 100%;text-align:  left;" >
                            <div  class="alert alert-light" role="alert" >
                                <fieldset>
                                    <h4>Consulta estatus de solicitud</h4>
                                    <p class="text">
                                        Consulta estatus de solicitudes iniciadas

                                </fieldset>
                            </div>
                            <div  class="alert alert-light" role="alert" style="text-align: left;">
                                <div id="listado" style="text-align: center;width: 100%;">
                                    <style>
                                        /* LIST #4 */
                                        #listado { width:360px; font-family:Georgia, Times, serif; font-size:15px; }
                                        #listado ul { list-style: none; }
                                        #listado ul li { }
                                        #listado ul li a { display:block; text-decoration:none; color:#000000; background-color:#FFFFFF; line-height:30px;
                                                           border-bottom-style:solid; border-bottom-width:1px; border-bottom-color:#CCCCCC; padding-left:2px; cursor:pointer; }
                                        #listado ul li a:hover { color:#FFFFFF; background-image:url(images/hover.png); background-repeat:repeat-x; }
                                        #listado ul li a strong { margin-right:5px; }
                                    </style>
                                    <%                                            //GETORDENESSQL
                                        oProperties.load(isArchivo);
                                        String GETORDENESSQL = oProperties.getProperty("GETORDENESSQL");
                                        String SATATUSAVISOSAP = oProperties.getProperty("SATATUSAVISOSAP");
                                        //URL url = new URL(GETORDENESSQL + "smarleny267@gmail.com");
                                        URL url = new URL(GETORDENESSQL + usuario);
                                        System.out.println("URL GETORDENESSQL " + url.toString());
                                        HttpURLConnection con = (HttpURLConnection) url.openConnection();
                                        con.setRequestMethod("GET");
                                        con.setRequestProperty("Accept", "application/json");
                                        con.setRequestProperty("Authorization", "Bearer " + token);
                                        Date dat = new Date();
                                        if (con.getResponseCode() != 200) {
                                            System.out.println(dat + "GETORDENESSQL Failed login : HTTP error code : " + con.getResponseCode());
                                            response.sendRedirect("Reportes.jsp");
                                        } else {
                                            System.out.println("GETORDENESSQL:: TRUE");

                                            InputStream inputStream = con.getInputStream();
                                            String json = new String();
                                            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream), 1);
                                            String line;
                                            while ((line = bufferedReader.readLine()) != null) {
                                                json = line;
                                            }
                                            inputStream.close();
                                            bufferedReader.close();
                                            System.out.println("GETORDENESSQL:: json ::: " + json);
                                            JSONObject jsonObj = new JSONObject(json);

                                            JSONObject jsonObjordenresponse = new JSONObject(jsonObj.get("Response").toString());
                                            //System.out.println("GETORDENESSQL:: strjsonObjservresponsedata :: " +jsonObjordenresponse.toString());
                                            String strjsonObjordenresponsedata = jsonObjordenresponse.get("data").toString();
                                            System.out.println("GETORDENESSQL:: strjsonObjordenresponsedata :: " + strjsonObjordenresponsedata.toString());
                                            if(!jsonObjordenresponse.get("data").toString().equalsIgnoreCase(null)){
                                            JSONArray results = new JSONArray(jsonObjordenresponse.get("data").toString());
                                            System.out.println("result:: " + results.length());
                                    %>
                                    <table class="table table-responsive table-striped table-sm" style="width: 100%;">
                                       
                                        <tbody>

                                            <tr>

                                                <th scope="col">Fecha </th>
                                                <th scope="col"># de Orden</th>
                                                <th scope="col">Estatus</th>

                                            </tr>

                                            <%
                                                for (int i = 0; i < results.length(); i++) {
                                                    JSONObject aux = results.getJSONObject(i);
                                                    String dtmFechaRegistro = aux.get("Fecha_de_Registro").toString();
                                                    dtmFechaRegistro = new String(dtmFechaRegistro.getBytes("ISO-8859-1"), "UTF-8");
                                                    dtmFechaRegistro = dtmFechaRegistro.replace("T", "  ");
                                                    String NumOS = aux.get("NumOS").toString();
                                                    NumOS = new String(NumOS.getBytes("ISO-8859-1"), "UTF-8");

                                            %>
                                            <tr >

                                                <td><%=dtmFechaRegistro%></td>
                                                <td "><%=NumOS%></td>
                                                <td><button id="btn<%=NumOS%>" type="button" title="Presiona para ver el estatus del reporte."   onclick="detalleOrden('<%=NumOS%>');" class="btn btn-outline-secondary" >Consultar</button>
                                                </td>

                                            </tr>
                                            <%
                                                }}else{
%>
                                        <center><h2>No hay solicitudes para mostrar</h2></center>
                                            <%
                                            }
                                            %>
                                        </tbody>
                                    </table>
                                    <script>
                                        function detalleOrden(p1) {
                                            //SATATUSAVISOSAP
                                            const url = '<%=SATATUSAVISOSAP%>' + p1;
                                            const http = new XMLHttpRequest();
                                            http.open("GET", url);
                                            http.onreadystatechange = function () {

                                                if (this.readyState === 4 && this.status === 200) {
                                                    var str = this.responseText;

                                                    str = str.substring(70, str.length - 2);

                                                    str = str.replace('{"e_ESTATUSField":"', '');
                                                    str = str.replace('"}', '');

                                                    if (str === 'G') {

                                                        swal('Reporte: ' + p1, ' Estatus: Generada');
                                                    } else if (str === 'A') {
                                                        swal('Reporte: ' + p1, ' Estatus: Anulada');

                                                    } else if (str === 'T') {
                                                        swal('Reporte: ' + p1, ' Estatus: Tratamiento');

                                                    } else if (str === 'R') {
                                                        swal('Reporte: ' + p1, ' Estatus: Resuelta');

                                                    } else if (str === 'B') {
                                                        swal('Reporte: ' + p1, ' Estatus: Bloqueada');

                                                    } else {
                                                        swal('Reporte: ' + p1, ' Estatus: Indefinido');
                                                    }
                                                }
                                            }
                                            http.send();
                                        }
                                    </script>

                                </div>
                            </div>

                        </div>

                    </div></div></div></div></center></div>

    <%@include file="Bottom.jsp" %>
</body>
</html>
<%}
    }%>