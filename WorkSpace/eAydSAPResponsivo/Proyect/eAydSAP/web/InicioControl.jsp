<%@page import="com.ayd.dao.RutaProperties"%>
<%@page import="java.util.Properties"%>
<%@page import="java.io.FileInputStream"%>
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
        ArrayList<String> lstnis = new ArrayList<String>();
        String strNombreLegible = new String(nombreusuario.getBytes("ISO-8859-1"), "UTF-8");
        RutaProperties rp = new RutaProperties();
        String urlProperties = rp.getRuta();
        objSession.setAttribute("urlProperties", urlProperties);
        InputStream isArchivo = new FileInputStream((String) objSession.getAttribute("urlProperties"));
        System.out.println("emailvalido json :: " + usuario + " / " + objSession.getAttribute("emailvalido"));
        Properties oProperties = new Properties();
        oProperties.load(isArchivo);
        String INICIO = oProperties.getProperty("INICIO");
        if (INICIO.equalsIgnoreCase("Inicio.jsp")) {
            System.out.println("InicioControl redirecciona a Inicio por Properties detectado");
            response.sendRedirect(INICIO);
        }
        if (objSession.getAttribute("emailvalido").equals("true")) {

            oProperties.load(isArchivo);

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
        <title>Pago de Servicios - VPC</title>
        <link href="styles/webflow1.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow4.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow3.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" src="js/script.js"></script>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
    </head>
    <body onload="numcol()" oncontextmenu="return false;">
        <SCRIPT LANGUAGE="JavaScript">
            history.forward()
        </SCRIPT>
        <%@include file="Top.jsp" %>
        <!-- HEADER -->
        <div id="content">
            <div class="container-fluid my-4">
                <div class="row py2">
                    <div class="container py2">

                        <%@include file="MenuServicios.jsp" %>
                        <h4 id="h4Table2" class="mb-3" style="color:#3c4858;" ></h4><h6 id="h6Table2" title="Agregar un servicio">Para agregar un servicio presiona <a href="AgregarServicio.jsp">Aquí</a></h6>
                        <div id="tblServicios" class="col-12 col-lg-9 float-left">
                            <div id="contenido_informacion1" >
                                <script>
                                    function numcol() {
                                        var rows = document.getElementById('tabla_servicios1').getElementsByTagName('tbody')[0].getElementsByTagName('tr').length - 2;



                                        if (rows !== 0) {
                                            var colum = "Tiene " + rows + " servicios asignados a su Cuenta en Línea:";
                                            document.getElementById("h4Table").innerHTML = colum;
                                            document.getElementById("Total").value = "0";
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

                                <label id="h4Table" style="font-family: 'Roboto', sans-serif;font-size: 16px;font-weight: 300;color:#3c4858;" >Seleccione el servicio que desee para que le llegue un aviso a su correo electrónico. Pude cambiar su selección cuando guste.</label>



                                <table  class="table table-sm table-responsive table-striped" id="tabla_servicios1">
                                    <tbody>
                                        <tr class="encabezado" id="servico_encabezado">
                                            <th style="text-align: center" align="center" width="7%">Eliminar</th>
                                            <th style="text-align: center" align="center" width="10%"><b>Contrato</b></th>
                                            <th align="center" width="7%"><b>Consultar Recibo</b></th>
                                            <th style="text-align: center" align="center" width="50%"><b>Dirección</b></th>
                                            <th style="text-align: center" align="center" width="8%"><b>Fecha de Vencimiento</b></th>
                                            <th style="text-align: center" align="center" width="8%"><b>Importe</b></th>

                                            <th style="text-align: center"  align="center" width="5%">&nbsp;$&nbsp;</th>

                                        </tr>

                                        <%                                            String SELSALDOS = oProperties.getProperty("SELSALDOS");

                                            URL url = new URL(SELSALDOS + usuario);
                                            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                                            conn.setRequestMethod("GET");
                                            conn.setRequestProperty("Accept", "application/json");
                                            conn.setRequestProperty("Authorization", "Bearer " + token);

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
                                                    System.out.println("json ::: " + json);
                                                    JSONObject jsonObj = new JSONObject(json);

                                                    JSONObject jsonObjservresponse = new JSONObject(jsonObj.get("Response").toString());
                                                    // System.out.println("strjsonObjservresponsedata :: " +jsonObjservresponse.toString());
                                                    String strjsonObjservresponsedata = jsonObjservresponse.get("data").toString();

                                                    strjsonObjservresponsedata = strjsonObjservresponsedata.replace("[", "");
                                                    strjsonObjservresponsedata = strjsonObjservresponsedata.replace("]", "");

                                                    // System.out.println("strjsonObjservresponsedata :: " + strjsonObjservresponsedata);
                                                    JSONObject jsonObjservresponsedata = new JSONObject(strjsonObjservresponsedata);
                                                    //System.out.println("jsonObjservresponsedata :: " + jsonObjservresponsedata.toString());

                                                    JSONArray results = new JSONArray(jsonObjservresponse.get("data").toString());
                                                    // System.out.println("result:: " + results.length());
                                                    for (int i = 0; i < results.length(); i++) {
                                        %>
                                        <tr>
                                            <%
                                                JSONObject aux = results.getJSONObject(i);
                                                System.out.println("NIS: " + aux.get("NIS").toString());
//                                                 System.out.println("Direccion: "+aux.get("Direccion").toString());
//                                                 System.out.println("Total "+aux.get("v_totaladeu").toString());
                                                String nisfact = aux.get("NIS").toString();
                                                lstnis.add(nisfact);
                                                String strDomicilio = "" + aux.get("Direccion").toString() + " ";
                                                String strdomicilioLegible = new String(strDomicilio.getBytes("ISO-8859-1"), "UTF-8");
                                                double dbtotal = Double.parseDouble(aux.get("v_totaladeu").toString());
                                            %>
                                            <td  align="center" width="7%"><input type="image" name="EliminaServicio" onclick="eliminarServicio('<%=aux.get("NIS").toString()%>');" src="imagenes/eliminar.png" style="width: 25px; height: 25px;" title="Eliminar Servicio" ></td>
                                            <td align="center" width="10%"><%=aux.get("NIS").toString()%>&nbsp;</td>
                                            <td align="center" width="7%">
                                                <a href="#facturaModal<%=aux.get("NIS").toString()%>" id="dialog"  class="btn btn-info btn-sm"  data-toggle="modal" data-target="#facturaModal<%=aux.get("NIS").toString()%>"><i class="fa fa-search" aria-hidden="true"></i>
                                                    Ver Facturas</a>
                                            </td>
                                            <td width="50%"><%=strdomicilioLegible%> </td>
                                            <td align="center" width="8%"><%=aux.get("Fecha_Venc").toString()%>&nbsp;</td>

                                            <td width="8%"><%=dbtotal%>&nbsp;</td>

                                            <%
                                                if (aux.get("v_totaladeu").toString().equalsIgnoreCase("0") || aux.get("v_totaladeu").toString().equalsIgnoreCase("0.00")) {
                                            %>
                                            <td align="center" width="5%"><font class="comment">Sin adeudos</font></td>
                                                <%
                                                } else {
                                                %>
                                            <td   align="center"  width="5%"><input id="<%=aux.get("NIS").toString()%>" onclick="agregarmonto('<%=aux.get("v_totaladeu".toString())%>', '<%=aux.get("NIS".toString())%>', '<%=aux.get("Vencimiento").toString()%>', '<%=aux.get("Fecha_Venc").toString()%>')" type="checkbox" class="only-one"></td>

                                            <%}%>

                                        </tr>
                                        <%
                                                    }

                                                } catch (IOException ioe) {

                                                } catch (JSONException ex) {

                                                }
                                            }


                                        %>
                                    <script>
                                        function agregarmonto(p1, p2, p3, p4) {


                                            if (document.getElementById(p2).checked) {
                                                document.getElementById("nispagar").value = document.getElementById("nispagar").value + p2 + "nis";
                                                document.getElementById("nispagardt").value = document.getElementById("nispagardt").value + p2 + "_" + p3 + "_" + p4 + "_" + p1 + "nis";
                                                var montochk = new Number(p1);
                                                montototal = 0;
                                                var montototal = new Number(document.getElementById("Total").value);
                                                document.getElementById("Total").value = "";
                                                var montototal = montototal + montochk;
                                                document.getElementById("Total").value = montototal + "";
                                                document.getElementById("checkactive").value = document.getElementById("checkactive").value + 1;

                                            } else {
                                                if (document.getElementById("Total").value !== "0") {
                                                    var nis = document.getElementById("nispagar").value;
                                                    nis = nis.replace(p2 + "nis", "");
                                                    document.getElementById("nispagar").value = nis;
                                                    var nisdt = document.getElementById("nispagardt").value;
                                                    nisdt = nisdt.replace(p2 + "_" + p3 + "_" + p4 + "_" + p1 + "nis", "");
                                                    document.getElementById("nispagardt").value = nisdt;


                                                    var montochk = new Number(p1);
                                                    montototal = 0;
                                                    var montototal = new Number(document.getElementById("Total").value);
                                                    document.getElementById("Total").value = "";
                                                    var montototal = montototal - montochk;
                                                    document.getElementById("Total").value = montototal + "";
                                                    document.getElementById("checkactive").value = document.getElementById("checkactive").value - 1;
                                                } else {
                                                    document.getElementById("montopagar").value = "0";
                                                }
                                            }


                                        }
                                        function eliminarServicio(p1) {
                                            document.getElementById("v_nis_rad").value = p1;
                                            swal({
                                                title: "¿Desea eliminar el NIS?",
                                                text: "Se eliminara de la lista de tus servicios.",
                                                icon: "warning",
                                                buttons: true,
                                                dangerMode: true,
                                            })
                                                    .then((willDelete) => {
                                                        if (willDelete) {
                                                            swal("Eliminado! El NIS fue eliminado!", {
                                                                icon: "success",
                                                            });
                                                            document.deleteServForm.submit();
                                                        } else {
                                                            swal("El nis no fué eliminado!");
                                                            document.getElementById("v_nis_rad").value = "";
                                                        }
                                                    });
                                        }


                                    </script>

                                    <tr  class="trtotal" id="trtotal">
                                        <td align="right" colspan="5"><font class="text"><b>Total a pagar :&nbsp;</b></font></td>

                                        <td colspan="2"><input readonly  type="text"  id="Total" name="Total" class="default" size="12" ></td>

                                    </tr>

                                    </tbody></table>
                                <div class="text-center">

                                    <input  class="btn btn-outline-secondary2" id="btn_submit" type="button" value="Pagar Servicios" onclick="pagarServcicios();">&nbsp;&nbsp;&nbsp;

                                    <div hidden  class="login-container col-12 col-lg-10 float-centre py-4" style="margin-left: 5%;">
                                        <h2 class="text-center mt-1 mb-3">Para el pago de servicios</h2>
                                        <h3 class="text-center mt-1 mb-3">lo invitamos a ingresar a través de nuestra APP.</h3> 
                                        <label>Encuentranos como AYD en Google Play y App Store.</label>
                                        <br>
                                        <img src="imagenes/AyDqr.png" onclick="window.parent.location.href = 'https://www.sadm.gob.mx/SADM/qr.html';" style="width: 50%;margin: 5px;"/>
                                        <br>
                                    </div>

                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div >
                <form name="deleteServForm" method="POST" action="servicedelete">

                    <input id="v_nis_rad" name="v_nis_rad" hidden>
                    <input id="Email" name="Email" value='<%=usuario%>' hidden>
                    <input id="token" name="token" value='<%=token%>' hidden>

                </form>
            </div>                       


            <%for (String s : lstnis) {%>
            <div class="modal fade" id="facturaModal<%=s%>" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" style="margin-top: 150px;">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="facturaModalLabel">Facturas</h5>
                            <input id="nisfacturas" hidden >
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div id="listado">
                                <style>
                                    /* LIST #4 */
                                    #listado { width:360px; font-family:Georgia, Times, serif; font-size:15px; }
                                    #listado ul { list-style: none; }
                                    #listado ul li { }
                                    #listado ul li a { display:block; text-decoration:none; color:#000000; background-color:#FFFFFF; line-height:30px;
                                                       border-bottom-style:solid; border-bottom-width:1px; border-bottom-color:#CCCCCC; padding-left:10px; cursor:pointer; }
                                    #listado ul li a:hover { color:#FFFFFF; background-image:url(images/hover.png); background-repeat:repeat-x; }
                                    #listado ul li a strong { margin-right:10px; }
                                </style>

                                <%
                                    String SELFACTURAS = oProperties.getProperty("SELFACTURAS");
//                                   
                                    URL urlfacturas = new URL(SELFACTURAS + s);
                                    HttpURLConnection connfacturas = (HttpURLConnection) urlfacturas.openConnection();
                                    connfacturas.setRequestMethod("GET");
                                    connfacturas.setRequestProperty("Accept", "application/json");
                                    connfacturas.setRequestProperty("Authorization", "Bearer " + token);
                                    // System.out.println("connfacturas.getResponseCode() :: "+connfacturas.getResponseCode());
                                    if (connfacturas.getResponseCode() != 200) {

                                        System.out.println("SELFACTURAS RESPOSE CODE: " + connfacturas.getResponseCode());
                                        response.sendRedirect(INICIO);

                                        //throw new RuntimeException("Failed : HTTP error code : " + connfacturas.getResponseCode());
                                    } else {
                                        InputStream inputStreamfactura = connfacturas.getInputStream();
                                        String jsonfacturas = new String();
                                        BufferedReader bufferedReaderfactura = new BufferedReader(new InputStreamReader(inputStreamfactura), 1);
                                        String linefacturas;
                                        while ((linefacturas = bufferedReaderfactura.readLine()) != null) {
                                            jsonfacturas = linefacturas;
                                            //System.out.println("jsonfacturas " + s + "::: " + jsonfacturas);
                                        }
                                        inputStreamfactura.close();
                                        bufferedReaderfactura.close();
                                        JSONObject jsonObjfacturas = new JSONObject(jsonfacturas);
                                        System.out.println("jsonfacturas " + s + "::: " + jsonfacturas.toString());
                                        //success
                                        if (jsonObjfacturas.get("success").toString().equalsIgnoreCase("true")) {
                                            JSONObject jsonObjfacturasresponse = new JSONObject(jsonObjfacturas.get("Response").toString());
                                            String strjsonObjfactresponsedata = jsonObjfacturasresponse.get("data").toString();

                                            strjsonObjfactresponsedata = strjsonObjfactresponsedata.replace("[", "");
                                            strjsonObjfactresponsedata = strjsonObjfactresponsedata.replace("]", "");

                                            //System.out.println("strjsonObjservresponsedata :: " + strjsonObjfactresponsedata);
                                            JSONArray results = new JSONArray(jsonObjfacturasresponse.get("data").toString());
                                            //System.out.println("result fact:: " + results.length());
                                %>
                                <ul>
                                    <%
                                        for (int i = 0; i < results.length(); i++) {
                                            JSONObject fact = results.getJSONObject(i);
//                                            System.out.println("fact ::" + fact.getString("PDF").toString());
//                                            System.out.println("fact ::" + fact.getString("XML").toString());
//                                            System.out.println("fact ::" + fact.getString("TO_CHAR").toString());
                                    %>
                                    <li><a href="<%=fact.getString("PDF").toString()%>" target="_blank"><%=fact.getString("TO_CHAR").toString()%>&nbsp; (pdf)</a></li>
                                    <li><a href="<%=fact.getString("XML").toString()%>" target="_blank"><%=fact.getString("TO_CHAR").toString()%>&nbsp; (xml)</a></li>



                                    <%
                                        }%>
                                </ul>
                                <%
                                } else {
                                    System.out.println("SELFACTURAS con success false, se invita a volver a intentarlo mas tarde en modal para permitir continuar reaizar pagos");
                                %>
                                <h3>Este servicio no está disponible en este momento.</h3>
                                <h5>Ya estamos trabajando para mejorar la consulta de sus facturas.</h5>
                                <h6>Agradecemos su comprensión. Vuelva a intentar más tarde.</h6>

                                <%
                                        }
                                    }
                                %>

                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <% }%>

            <script>
                function pagarServcicios() {
                    if (document.getElementById("checkactive").value < 1) {
                        swal("No ha seleccionado servicios a pagar.!", "Seleccione algún servicio para continuar.", "error").then((value) => {
                            window.parent.location.href = '<%=INICIO%>'
                        });

                        document.getElementById("montopagar").value = "";

                    } else {
                        document.getElementById('btn_submit').hidden = true;
                        var total = document.getElementById("Total").value;
                        total = total.replace(".00", "");
                        document.getElementById("montopagar").value = total;

                        document.pagarServForm.submit();
                    }
                }
            </script>
            <div>
                <form name="pagarServForm" method="POST" action="pagarserviciosQB">
                    <input id="nispagar" name="nispagar" hidden  >
                    <input id="nispagardt" name="nispagardt"  hidden >
                    <input id="montopagar" name="montopagar" hidden >
                    <input  name="emailpago" value="<%=usuario%>" hidden >
                    <input  name="token" value="<%=token%>" hidden >
                    <input id="checkactive"  hidden>


                </form>
            </div></div>
            <%@include file="Bottom.jsp" %>
    </body>
</html>
<%} else {

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
        <title>Pago de Servicios - VPC</title>
        <link href="styles/webflow1.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow4.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow3.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" src="js/script.js"></script>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
    </head>
    <body onload="numcol()" oncontextmenu="return false;">
        <SCRIPT LANGUAGE="JavaScript">
            history.forward()
        </SCRIPT>
        <%@include file="Top.jsp" %>
        <!-- HEADER -->
        <div id="content">
            <div class="container-fluid my-4">
                <div class="row py2">
                    <div class="container py2">
                        <%@include file="MenuServicios.jsp" %>
                        <h4 id="h4Table2" class="mb-3" style="color:#3c4858;" ></h4><h6 id="h6Table2" title="Agregar un servicio">Para agregar un servicio presiona <a href="AgregarServicio.jsp">Aquí</a></h6>
                        <div id="tblServicios" class="col-12 col-lg-9 float-left">
                            <div id="contenido_informacion1" >
                                <script>
                                    function numcol() {
                                        var rows = document.getElementById('tabla_servicios1').getElementsByTagName('tbody')[0].getElementsByTagName('tr').length - 2;



                                        if (rows !== 0) {
                                            var colum = "Tiene " + rows + " servicios asignados a su Cuenta en Línea:";
                                            document.getElementById("h4Table").innerHTML = colum;
                                            document.getElementById("Total").value = "0";
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

                                <label id="h4Table" style="font-family: 'Roboto', sans-serif;font-size: 16px;font-weight: 300;color:#3c4858;" >Seleccione el servicio que desee para que le llegue un aviso a su correo electrónico. Pude cambiar su selección cuando guste.</label>



                                <table  class="table table-sm table-responsive table-striped" id="tabla_servicios1">
                                    <tbody>
                                        <tr class="encabezado" id="servico_encabezado">
                                            <th align="center" width="7%">&nbsp;</th>
                                            <th align="center" width="10%"><b>NIS</b></th>
                                            <th align="center" width="7%"><b>Consultar Recibo</b></th>
                                            <th align="center" width="50%"><b>Dirección</b></th>
                                            <th align="center" width="8%"><b>Fecha de Vencimiento</b></th>
                                            <th align="center" width="8%"><b>Importe</b></th>

                                            <th  align="center" width="5%">&nbsp;$&nbsp;</th>

                                        </tr>

                                        <%                                            oProperties.load(isArchivo);
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
                                                double dbtotal = Double.parseDouble(aux.get("v_totaladeu").toString());
                                            %>
                                            <td  align="center" width="7%"><input type="image" name="EliminaServicio" onclick="eliminarServicio('<%=aux.get("NIS").toString()%>');" src="imagenes/eliminar.png" style="width: 25px; height: 25px;" title="Eliminar Servicio" ></td>
                                            <td align="center" width="10%"><%=aux.get("NIS").toString()%>&nbsp;</td>
                                            <td align="center" width="7%">
                                                <a href="#facturaModal<%=aux.get("NIS").toString()%>" id="dialog"  class="btn btn-info btn-sm"  data-toggle="modal" data-target="#facturaModal<%=aux.get("NIS").toString()%>"><i class="fa fa-search" aria-hidden="true"></i>
                                                    Ver Facturas</a>
                                            </td>
                                            <td width="50%"><%=strdomicilioLegible%> </td>
                                            <td align="center" width="8%"><%=aux.get("Fecha_Venc").toString()%>&nbsp;</td>

                                            <td width="8%"><%=dbtotal%>&nbsp;</td>

                                            <%
                                                if (aux.get("v_totaladeu").toString().equalsIgnoreCase("0") || aux.get("v_totaladeu").toString().equalsIgnoreCase("0.00")) {
                                            %>
                                            <td align="center" width="5%"><font class="comment">Sin adeudos</font></td>
                                                <%
                                                } else {
                                                %>
                                            <td   align="center"  width="5%"><input id="<%=aux.get("NIS").toString()%>" onclick="agregarmonto('<%=aux.get("v_totaladeu".toString())%>', '<%=aux.get("NIS".toString())%>', '<%=aux.get("Vencimiento").toString().substring(0, 9)%>', '<%=aux.get("Fecha_Venc").toString()%>')" type="checkbox" class="only-one"></td>

                                            <%}%>

                                        </tr>
                                        <%
                                                    }

                                                } catch (IOException ioe) {

                                                } catch (JSONException ex) {

                                                }
                                            }


                                        %>
                                    <script>
                                        function agregarmonto(p1, p2, p3, p4) {


                                            if (document.getElementById(p2).checked) {
                                                document.getElementById("nispagar").value = document.getElementById("nispagar").value + p2 + "nis";
                                                document.getElementById("nispagardt").value = document.getElementById("nispagardt").value + p2 + "_" + p3 + "_" + p4 + "_" + p1 + "nis";
                                                var montochk = new Number(p1);
                                                montototal = 0;
                                                var montototal = new Number(document.getElementById("Total").value);
                                                document.getElementById("Total").value = "";
                                                var montototal = montototal + montochk;
                                                document.getElementById("Total").value = montototal + "";
                                                document.getElementById("checkactive").value = document.getElementById("checkactive").value + 1;

                                            } else {
                                                if (document.getElementById("Total").value !== "0") {
                                                    var nis = document.getElementById("nispagar").value;
                                                    nis = nis.replace(p2 + "nis", "");
                                                    document.getElementById("nispagar").value = nis;
                                                    var nisdt = document.getElementById("nispagardt").value;
                                                    nisdt = nisdt.replace(p2 + "_" + p3 + "_" + p4 + "_" + p1 + "nis", "");
                                                    document.getElementById("nispagardt").value = nisdt;


                                                    var montochk = new Number(p1);
                                                    montototal = 0;
                                                    var montototal = new Number(document.getElementById("Total").value);
                                                    document.getElementById("Total").value = "";
                                                    var montototal = montototal - montochk;
                                                    document.getElementById("Total").value = montototal + "";
                                                    document.getElementById("checkactive").value = document.getElementById("checkactive").value - 1;
                                                } else {
                                                    document.getElementById("montopagar").value = "0";
                                                }
                                            }


                                        }
                                        function eliminarServicio(p1) {
                                            document.getElementById("v_nis_rad").value = p1;
                                            swal({
                                                title: "¿Desea eliminar el NIS?",
                                                text: "Se eliminara de la lista de tus servicios.",
                                                icon: "warning",
                                                buttons: true,
                                                dangerMode: true,
                                            })
                                                    .then((willDelete) => {
                                                        if (willDelete) {
                                                            swal("Eliminado! El NIS fue eliminado!", {
                                                                icon: "success",
                                                            });
                                                            document.deleteServForm.submit();
                                                        } else {
                                                            swal("El nis no fué eliminado!");
                                                            document.getElementById("v_nis_rad").value = "";
                                                        }
                                                    });
                                        }


                                    </script>

                                    <tr hidden class="trtotal" id="trtotal">
                                        <td align="right" colspan="5"><font class="text"><b>Total a pagar :&nbsp;</b></font></td>

                                        <td colspan="2"><input readonly  type="text"  id="Total" name="Total" class="default" size="12" ></td>

                                    </tr>

                                    </tbody></table>
                                <div class="text-center">

                                    <input hidden class="btn btn-outline-secondary2" id="btn_submit" type="button" value="Pagar Servicios" onclick="pagarServcicios();">&nbsp;&nbsp;&nbsp;

                                    <div  class="login-container col-12 col-lg-10 float-centre py-4" style="margin-left: 5%;">
                                        <h2 class="text-center mt-1 mb-3">Para el pago de servicios</h2>
                                        <h3 class="text-center mt-1 mb-3">lo invitamos a ingresar a través de nuestra APP.</h3> 
                                        <label>Encuentranos como AYD en Google Play y App Store.</label>
                                        <br>
                                        <img src="imagenes/AyDqr.png" onclick="window.parent.location.href = 'https://www.sadm.gob.mx/SADM/qr.html';" style="width: 50%;margin: 5px;"/>
                                        <br>
                                    </div>

                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div >
                <form name="deleteServForm" method="POST" action="servicedelete">

                    <input id="v_nis_rad" name="v_nis_rad" hidden>
                    <input id="Email" name="Email" value='<%=usuario%>' hidden>
                    <input id="token" name="token" value='<%=token%>' hidden>

                </form>
            </div>                       


            <%for (String s : lstnis) {%>
            <div class="modal fade" id="facturaModal<%=s%>" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" style="margin-top: 150px;">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="facturaModalLabel">Facturas</h5>
                            <input id="nisfacturas" hidden >
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div id="listado">
                                <style>
                                    /* LIST #4 */
                                    #listado { width:360px; font-family:Georgia, Times, serif; font-size:15px; }
                                    #listado ul { list-style: none; }
                                    #listado ul li { }
                                    #listado ul li a { display:block; text-decoration:none; color:#000000; background-color:#FFFFFF; line-height:30px;
                                                       border-bottom-style:solid; border-bottom-width:1px; border-bottom-color:#CCCCCC; padding-left:10px; cursor:pointer; }
                                    #listado ul li a:hover { color:#FFFFFF; background-image:url(images/hover.png); background-repeat:repeat-x; }
                                    #listado ul li a strong { margin-right:10px; }
                                </style>

                                <%
                                    String SELFACTURAS = oProperties.getProperty("SELFACTURAS");

                                    URL urlfacturas = new URL(SELFACTURAS + s);
                                    HttpURLConnection connfacturas = (HttpURLConnection) urlfacturas.openConnection();
                                    connfacturas.setRequestMethod("GET");
                                    connfacturas.setRequestProperty("Accept", "application/json");
                                    connfacturas.setRequestProperty("Authorization", "Bearer " + token);
                                    // System.out.println("connfacturas.getResponseCode() :: "+connfacturas.getResponseCode());
                                    if (connfacturas.getResponseCode() != 200) {

                                        System.out.println("SELFACTURAS RESPOSE CODE: " + connfacturas.getResponseCode());
                                        response.sendRedirect(INICIO);

                                        //throw new RuntimeException("Failed : HTTP error code : " + connfacturas.getResponseCode());
                                    } else {
                                        InputStream inputStreamfactura = connfacturas.getInputStream();
                                        String jsonfacturas = new String();
                                        BufferedReader bufferedReaderfactura = new BufferedReader(new InputStreamReader(inputStreamfactura), 1);
                                        String linefacturas;
                                        while ((linefacturas = bufferedReaderfactura.readLine()) != null) {
                                            jsonfacturas = linefacturas;
                                            //System.out.println("jsonfacturas " + s + "::: " + jsonfacturas);
                                        }
                                        inputStreamfactura.close();
                                        bufferedReaderfactura.close();
                                        JSONObject jsonObjfacturas = new JSONObject(jsonfacturas);
                                        System.out.println("jsonfacturas " + s + "::: " + jsonfacturas.toString());
                                        //success
                                        if (jsonObjfacturas.get("success").toString().equalsIgnoreCase("true")) {
                                            JSONObject jsonObjfacturasresponse = new JSONObject(jsonObjfacturas.get("Response").toString());
                                            String strjsonObjfactresponsedata = jsonObjfacturasresponse.get("data").toString();

                                            strjsonObjfactresponsedata = strjsonObjfactresponsedata.replace("[", "");
                                            strjsonObjfactresponsedata = strjsonObjfactresponsedata.replace("]", "");

                                            //System.out.println("strjsonObjservresponsedata :: " + strjsonObjfactresponsedata);
                                            JSONArray results = new JSONArray(jsonObjfacturasresponse.get("data").toString());
                                            //System.out.println("result fact:: " + results.length());
                                %>
                                <ul>
                                    <%
                                        for (int i = 0; i < results.length(); i++) {
                                            JSONObject fact = results.getJSONObject(i);
//                                            System.out.println("fact ::" + fact.getString("PDF").toString());
//                                            System.out.println("fact ::" + fact.getString("XML").toString());
//                                            System.out.println("fact ::" + fact.getString("TO_CHAR").toString());
                                    %>
                                    <li><a href="<%=fact.getString("PDF").toString()%>" target="_blank"><%=fact.getString("TO_CHAR").toString()%>&nbsp; (pdf)</a></li>
                                    <li><a href="<%=fact.getString("XML").toString()%>" target="_blank"><%=fact.getString("TO_CHAR").toString()%>&nbsp; (xml)</a></li>



                                    <%
                                        }%>
                                </ul>
                                <%
                                } else {
                                    System.out.println("SELFACTURAS con success false, se invita a volver a intentarlo mas tarde en modal para permitir continuar reaizar pagos");
                                %>
                                <h3>Este servicio no está disponible en este momento.</h3>
                                <h5>Ya estamos trabajando para mejorar la consulta de sus facturas.</h5>
                                <h6>Agradecemos su comprensión. Vuelva a intentar más tarde.</h6>

                                <%
                                        }
                                    }
                                %>

                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <% }%>

            <script>
                function pagarServcicios() {
                    if (document.getElementById("checkactive").value < 1) {
                        swal("No ha seleccionado servicios a pagar.!", "Seleccione algún servicio para continuar.", "error").then((value) => {
                            window.parent.location.href = '<%=INICIO%>'
                        });

                        document.getElementById("montopagar").value = "";

                    } else {
                        document.getElementById('btn_submit').hidden = true;
                        var total = document.getElementById("Total").value;
                        total = total.replace(".00", "");
                        document.getElementById("montopagar").value = total;

                        document.pagarServForm.submit();
                    }
                }
            </script>
        </div>
        <%@include file="Bottom.jsp" %>
    </body>
</html>
<%

            System.out.println("::: NO : ");
        }
    }%>