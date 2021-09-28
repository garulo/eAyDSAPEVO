<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="com.ayd.dao.MunicipioDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.io.IOException"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.io.IOException"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="java.io.FileInputStream"%>
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
        <title>Generar reporte</title>
        <link href="styles/webflow1.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow4.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow3.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" src="js/script.js"></script>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>

    </head>
    <body oncontextmenu="return false;"  >

        <%@include file="Top.jsp" %>
        <div id="content">
            <div class="container-fluid my-4">
                <div class="row py2">
                    <div class="container py2">
                        <%@include file="MenuServicios.jsp" %>
                        <form id="FormGenerarReporte" name="FormGenerarReporte" method="post" action="generarReporte" enctype="multipart/form-data"> 
                            <div class="float-left" style="width: 75%;float: left;" >
                                <div style="width: 100%;text-align:  center;" >

                                    <div  class="alert alert-light" role="alert" style="text-align: left;" >
                                        <fieldset>
                                            <h4>Generar un reporte</h4>
                                            <p class="text">
                                                Genera reportes por fallas en el suministro de agua o fugas

                                        </fieldset>
                                        <input id="Sub_Cat" name="Sub_Cat" hidden >
                                        <input id="Email" name="Email"  value="<%=usuario%>" hidden />
                                        <input id="Contrato" name="Contrato" hidden> 
                                        <input id="token" name="token" value="<%=token%>" hidden>

                                        <table class="table table-responsive table-sm" border="0">
                                            <tbody>
                                                <tr>
                                                    <td><font class="text"><b>Descripción del reporte (*)</b></font></td>
                                                    <td><input  id="Comentario" name="Comentario" style="width: 100%;float: left;" placeholder="Descripción del reporte"/></td>
                                                </tr>
                                                <tr>
                                                    <td><font class="text"><b>Selecciona el tipo de reporte: (*)</b></font></td>
                                                    <td>
                                                        <div style="float: left;">
                                                            <select id="slctTipoReporte" style="width: 100%" onchange="valSlectTipoReporte()" >
                                                                <option disabled selected></option>
                                                                <option value="FFF"  >Fuga de agua potable</option>
                                                                <option value="RT07"  >Baja presión de Agua</option>
                                                                <option value="RT08"  >Fuga de drenaje</option>
                                                            </select></div>
                                                        <div id="tipoFuga" class="alert alert-light" style="float: left;" hidden>
                                                            <select id="slctTipoFuga" style="width: 100%" onchange="valSlctTipoFuga()" >
                                                                <option disabled selected>Selecciona el tipo de fuga: (*)</option>
                                                                <option value="RT04"  >Fuga en medidor</option>
                                                                <option value="RT05"  >Fuga de agua en la banqueta</option>
                                                                <option value="RT06"  >Fuga de agua en la calle</option>
                                                            </select>

                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><font class="text"><b>Número Exterior: </b></font></td>
                                                    <td><input id="Puerta"  name="Puerta" style="width: 100%;float: left;margin-left: 5px;" placeholder="Número"/></td>
                                                </tr>
                                                <tr>
                                                    <td><font class="text"><b>Código Postal: </b></font></td>
                                                    <td><input id="CP" type="text" onblur="cpvali();" maxlength="5" name="CP" style="width: 100%;float: left;margin-left: 5px;" placeholder="C.P."/></td>
                                                </tr>
                                                <tr>
                                                    <td><font class="text"><b>Referencias: </b></font></td>
                                                    <td><input id="Referencia"  name="Referencia" style="width: 100%;float: left;margin-left: 5px;" placeholder="Referencias"/></ 5px;" placeholder="C.P.td>
                                                </tr>

                                            </tbody>
                                            <script>
                                                function cpvali() {
                                                    var cadenacp = document.getElementById("CP").value;
                                                    var expregcp = /^(?:0[0-9]|[0-9]\d|9[0-9])\d{3}$/;

                                                    if (expregcp.test(cadenacp)) {

                                                    } else {
                                                        document.getElementById("CP").value = "";
                                                        swal("El Código postal es incorrecto, debe ser numérico y de 5 dígitos.");
                                                    }
                                                }
                                            </script>
                                        </table></div>

                                    <script>
                                        function valSlectTipoReporte() {
                                            if (document.getElementById('slctTipoReporte').value === 'FFF') {
                                                document.getElementById('tipoFuga').hidden = false;

                                            } else {
                                                document.getElementById('tipoFuga').hidden = true;
                                                document.getElementById('Sub_Cat').value = document.getElementById('slctTipoReporte').value;

                                            }
                                        }
                                    </script>

                                    <script>
                                        function valSlctTipoFuga() {
                                            document.getElementById('Sub_Cat').value = document.getElementById('slctTipoFuga').value;
                                        }
                                    </script>
                                    
                                    <div  class="alert alert-light" role="alert" style="width: 100%;text-align: left;float: left;" >
                                        <table class="table table-responsive table-sm" style="width: 60%" border="0">
                                            <thead>
                                            <ul class="nav nav-tabs" id="pills-tab" role="tablist">
                                                <li class="nav-item" style="width: 50%" id="liContrato" onclick="document.getElementById('navdomicilio').hidden = true;document.getElementById('navcontrato').hidden = false;document.getElementById('fontdom').hidden = true;">
                                                    <a class="nav-link active" id="pills-home-tab" data-toggle="pill" href="#pills-home" role="tab" aria-controls="pills-home" aria-selected="true">Contrato</a>
                                                </li>
                                                <li class="nav-item" style="width: 50%" id="liDireccion" onclick="document.getElementById('navcontrato').hidden = true;
                                                        document.getElementById('navdomicilio').hidden = false;
                                                        document.getElementById('fontdom').hidden = false;">
                                                    <a class="nav-link" id="pills-profile-tab" data-toggle="pill" href="#pills-profile" role="tab" aria-controls="pills-profile" aria-selected="false">Dirección</a>
                                                </li>
                                            </ul>
                                            </thead>
                                            <tbody>

                                                <tr id="navcontrato">

                                                    <td>
                                                        <div class="tab-content" id="pills-tabContent">
                                                            <div class="tab-pane fade show active" id="pills-home" role="tabpanel" aria-labelledby="pills-home-tab">
                                                                <div  class="alert alert-light" role="alert">
                                                                    <font class="text"><b>Selecciona el Contrato: </b></font>
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
                                                                                System.out.println("SELSALDOS json ::: " + json);
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
                                                                    %><select id="slctContrato"  name="slctContrato" style="width: 100%" onchange="document.getElementById('liDireccion').hidden = true;
                                                                            document.getElementById('Contrato').value = document.getElementById('slctContrato').value;" >
                                                                        <option disabled value="00"  selected>Selecciona el Contrato</option>
                                                                        <%
                                                                            for (int i = 0; i < results.length(); i++) {
                                                                                JSONObject aux = results.getJSONObject(i);
                                                                                String nis = aux.get("NIS").toString();
                                                                                String strDomicilio = "" + aux.get("Direccion").toString() + " ";
                                                                                String strdomicilioLegible = new String(strDomicilio.getBytes("ISO-8859-1"), "UTF-8");

                                                                        %>

                                                                        <option value="<%=nis%> | <%=strdomicilioLegible%>"><%=nis%> - <%=strdomicilioLegible%></option>

                                                                        <%}%>
                                                                    </select>
                                                                    <%

                                                                            } catch (IOException ioe) {

                                                                            } catch (JSONException ex) {

                                                                            }
                                                                        }

                                                                    %>
                                                                </div>
                                                            </div></div>
                                                    </td>
                                                </tr>
                                                <tr id="navdomicilio">

                                                    <td>
                                                        <div class="tab-pane fade" id="pills-profile" role="tabpanel" aria-labelledby="pills-profile-tab">
                                                            <%  ArrayList<MunicipioDAO> ListaMunicipios = new ArrayList<MunicipioDAO>();
                                                                String SELMUNICIPIOS = oProperties.getProperty("SELMUNICIPIOS");
                                                                String SELCOLONIAS = oProperties.getProperty("SELCOLONIAS");
                                                                String SELCALLES = oProperties.getProperty("SELCALLES");
                                                                URL urlmunicipio = new URL(SELMUNICIPIOS);
                                                                HttpURLConnection connmunicipio = (HttpURLConnection) urlmunicipio.openConnection();
                                                                connmunicipio.setRequestMethod("GET");
                                                                connmunicipio.setRequestProperty("Accept", "application/json");
                                                                if (connmunicipio.getResponseCode() != 200) {
                                                                } else {
                                                                    try {

                                                                        InputStream inputStream = connmunicipio.getInputStream();
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

                                                                        if ("null" != jsonObj.get("Response").toString()) {
                                                                            //System.out.println("::jsonObj.get(\"Response\").toString():: "+jsonObj.get("Response").toString());
                                                                            JSONObject jsonObjloginresponse = new JSONObject(jsonObj.get("Response").toString());
                                                                            String jsonObjloginresponseSTR = jsonObjloginresponse.toString();

                                                                            JSONObject JSONMunicipios = new JSONObject(jsonObjloginresponseSTR);
                                                                            //System.out.println("json Municipios " + JSONMunicipios);
                                                                            JSONArray jsonMunicipiosArray = JSONMunicipios.getJSONArray("data");

                                                                            for (int i = 0; i < jsonMunicipiosArray.length(); i++) {
                                                                                try {
                                                                                    JSONObject municipiojson = jsonMunicipiosArray.getJSONObject(i);
                                                                                    MunicipioDAO mun = new MunicipioDAO();

                                                                                    byte[] bytes = municipiojson.getString("NOM_DEPTO").getBytes(StandardCharsets.ISO_8859_1);
                                                                                    String utf8EncodedString = new String(bytes, StandardCharsets.UTF_8);
                                                                                    mun.setNom_depto(utf8EncodedString);
                                                                                    mun.setCod_depto(municipiojson.getString("COD_DEPTO"));
                                                                                    ListaMunicipios.add(mun);
                                                                                    //System.out.println("cod: "+municipiojson.getString("COD_DEPTO")+" mun :::" + utf8EncodedString);
                                                                                } catch (JSONException e) {
                                                                                    e.printStackTrace();
                                                                                }
                                                                            }

                                                                        }

                                                                    } catch (IOException ioe) {

                                                                    } catch (JSONException ex) {

                                                                    }

                                                                }

                                                            %>
                                                            <div hidden id="fontdom"  class="alert alert-light" role="alert" >
                                                                <font class="text"><b>Selecciona un Domicilio: </b></font><br>
                                                                <select id="Municipio" name="Municipio"  style="width: 100%" onchange="calculaColonias();"   >
                                                                    <option value="00" disabled selected>Selecciona el Municipio</option>
                                                                    <%for (MunicipioDAO m : ListaMunicipios) {%>
                                                                    <option value="<%=m.getCod_depto()%>_<%=m.getNom_depto()%>"><%=m.getNom_depto()%></option>
                                                                    <%}%>
                                                                </select>
                                                                <script>
                                                                    //                                                        function limpiacolcall(){
                                                                    //                                                            for (let i = $('#Colonia').options.length; i >= 0; i--) {
                                                                    //                                                                $('#Colonia').remove(i);
                                                                    //                                                            }
                                                                    //                                                        }
                                                                    function calculaColonias() {
                                                                        document.getElementById('Contrato').value = "00";

                                                                        $('#Colonia').empty();
                                                                        $('#Calle').empty();

                                                                        var txt = document.getElementById("Municipio").value;
                                                                        var codcol = txt.split("_", 1);

                                                                        const url = '<%=SELCOLONIAS%>' + codcol;
                                                                        //alert(url.toString());
                                                                        const http = new XMLHttpRequest();
                                                                        http.open("GET", url);
                                                                        //                                            alert(http.onreadystatechange);
                                                                        http.onreadystatechange = function () {

                                                                            if (this.readyState === 4 && this.status === 200) {
                                                                                var str = this.responseText;

                                                                                str = str.substring(70, str.length - 2);
                                                                                //alert(str);
                                                                                var resultado = JSON.parse(str);
                                                                                var $select = $('#Colonia');

                                                                                $.each(resultado, function (id, name) {
                                                                                    $select.append('<option value=' + name.COD_LOCAL + "_" + name.NOM_LOCAL.replaceAll(" ", "/") + '>' + name.NOM_LOCAL + '</option>');
                                                                                });

                                                                            }
                                                                        }
                                                                        http.send();

                                                                    }
                                                                </script>

                                                                <select id="Colonia" name="Colonia"  style="width: 100%" onchange="cargardistrict();" >
                                                                    <option value="00" disabled selected>Selecciona una Colonia</option>
                                                                </select>
                                                                <script>
                                                                    function cargardistrict() {
                                                                        $('#Calle').empty();

                                                                        var txtcalle = document.getElementById("Colonia").value;
                                                                        var codcalle = txtcalle.split("_", 1);
                                                                        var nomcalle = txtcalle.replaceAll("/", " ");
                                                                        nomcalle = nomcalle.replaceAll(txtcalle.split("_", 1), "");
                                                                        nomcalle = nomcalle.replaceAll("_", "");

                                                                        var txt = document.getElementById("Municipio").value;
                                                                        var codcol = txt.split("_", 1);
                                                                        const url = '<%=SELCALLES%>' + codcalle + "&citycode=" + codcol;
                                                                        const http = new XMLHttpRequest();
                                                                        http.open("GET", url)
                                                                        http.onreadystatechange = function () {

                                                                            if (this.readyState == 4 && this.status == 200) {
                                                                                var str = this.responseText;

                                                                                str = str.substring(70, str.length - 2);
                                                                                var resultado = JSON.parse(str);
                                                                                var $select = $('#Calle');

                                                                                $.each(resultado, function (id, name) {
                                                                                    $select.append('<option value=' + name.NOM_CALLE.replaceAll(" ", "/") + '>' + name.NOM_CALLE + '</option>');
                                                                                });

                                                                            }
                                                                        }
                                                                        http.send();
                                                                    }
                                                                </script>

                                                                <select id="Calle" name="Calle" style="width: 100%" >
                                                                    <option value="00" disabled selected>Selecciona una Calle</option>
                                                                </select>

                                                            </div>


                                                        </div><td>
                                                </tr>
                                            </tbody>

                                        </table>



                                    </div>
                                    <hr >
                                    <input  class="btn btn-outline-secondary" type="button" data-toggle="modal" data-target="#ModalFotos" value="FOTO" style="margin: 10px;" />

                                    <input  class="btn btn-outline-secondary" type="button" onclick="validaForm()" value="ENVIAR" style="margin: 10px;" />

                                    <script>
                                        function validaForm() {
                                            if (document.getElementById("Comentario").value === '') {
                                                swal('Por favor capture una descripción del reporte.');
                                                document.getElementById("Comentario").focus();
                                            } else {
                                                if (document.getElementById("Sub_Cat").value === '') {
                                                    swal('Por favor seleccione tipo de reporte ó tipo de fuga');
                                                    document.getElementById("slctTipoReporte").focus();
                                                } else {
                                                    if (document.getElementById("Contrato").value === '00') {
                                                        if (document.getElementById("Colonia").value === '') {
                                                            swal("Selecciona una Colonia");
                                                        } else {
                                                            if (document.getElementById("Calle").value === '') {
                                                                swal("Selecciona una Calle");
                                                                document.getElementById("Calle").focus();
                                                            } else {

                                                                if (document.getElementById("Puerta").value === '') {
                                                                    swal('Por favor capture Número');
                                                                    document.getElementById("Puerta").focus();
                                                                } else {
                                                                    if (document.getElementById("CP").value === '') {
                                                                        swal('Por favor capture Código Postal');
                                                                        document.getElementById("CP").focus();
                                                                    } else {
                                                                        if (document.getElementById("Referencia").value === '') {
                                                                            swal('Por favor capture Referencias');
                                                                            document.getElementById("Referencia").focus();
                                                                        } else {
                                                                            $("#FormGenerarReporte").submit();
                                                                        }
                                                                    }
                                                                }

                                                            }
                                                        }
                                                    } else {
                                                        if (document.getElementById("Contrato").value === '') {
                                                            swal('Por favor seleccione un Contrato ó Dirección');
                                                            document.getElementById("slctContrato").focus();
                                                        } else {
                                                            if (document.getElementById("Puerta").value === '') {
                                                                swal('Por favor capture Número');
                                                                document.getElementById("Puerta").focus();
                                                            } else {
                                                                if (document.getElementById("CP").value === '') {
                                                                    swal('Por favor capture Código Postal');
                                                                    document.getElementById("CP").focus();
                                                                } else {
                                                                    if (document.getElementById("Referencia").value === '') {
                                                                        swal('Por favor capture Referencias');
                                                                        document.getElementById("Referencia").focus();
                                                                    } else {
                                                                        $("#FormGenerarReporte").submit();
                                                                    }
                                                                }
                                                            }

                                                        }
                                                    }

                                                }
                                            }
                                        }


                                    </script>
                                </div>
                            </div>
                    </div>

                </div>

            </div>
            <div class="modal fade" style="margin-top: 150px;width: 99%;alignment-adjust: central;" id="ModalFotos" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="false">
                <div class="modal-dialog custom-class">
                    <div class="modal-content">

                        <div class="modal-header">

                            <h5 class="modal-title" id="myModalLabel">Ingresa las fotos </h5>
                            <button type="button" class="close" data-dismiss="modal" style="float:right;" aria-hidden="true">&times;</button>
                        </div>
                        <div class="modal-body" style="text-align: center;">
                            <input id="pic1" name="pic1" type="file" capture="camera">
                            <hr >
                            <input id="pic2" name="pic2" type="file" capture="camera">
                            <hr >
                            <input id="pic3" name="pic3" type="file" capture="camera">
                            <hr >
                            <input id="pic4" name="pic4" type="file" capture="camera">
                            
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Continuar</button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div></div></div>

</div>

<%@include file="Bottom.jsp" %>
</body >
</html>
<%}%>