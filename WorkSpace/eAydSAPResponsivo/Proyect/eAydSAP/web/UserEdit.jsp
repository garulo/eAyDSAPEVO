<%@page import="java.io.FileInputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="com.ayd.servlet.Autenticacion"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.IOException"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.ayd.dao.MunicipioDAO"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
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
        ArrayList<MunicipioDAO> ListaMunicipios = new ArrayList<MunicipioDAO>();
        ArrayList<MunicipioDAO> ListaDistrits = new ArrayList<MunicipioDAO>();
        ArrayList<MunicipioDAO> ListaStreets = new ArrayList<MunicipioDAO>();
        InputStream isArchivo = new FileInputStream((String) objSession.getAttribute("urlProperties"));
        Properties oProperties = new Properties();
        oProperties.load(isArchivo);
        String INICIO = oProperties.getProperty("INICIO");

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "https://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta name="tipo_contenido"  content="text/html;" http-equiv="content-type" charset="utf-8">
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>

        <title>Edición de Usuarios</title>
        <%@ include file="HeaderOptions.jsp" %>



        <link href="styles/webflow1.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow4.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow3.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" src="js/jquery3.js"></script>
        <script language="JavaScript" src="js/script.js"></script>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous"/>
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>


    </head>
    <script language="JavaScript">
        function validateForm()
        {
             if (document.getElementById("cityinput").value !== "") {
            if (document.getElementById("district").value !== "") {
            if (document.getElementById("street").value !== "") {
                if (document.getElementById('userName').value !== "") {
                    if (document.getElementById('lastName').value !== "") {
                        if (document.getElementById('email').value !== "") {
                            if (document.getElementById('dtNacimiento').value !== "") {
                                if (document.getElementById('sexo').value !== "") {

                                    //    mostrarVerificar();
                                    $("#Formmodificarcuenta").submit();


                                } else {
                                    swal("Por favor inserte su sexo.");
                                    document.getElementById('sexo').value = "";
                                }

                            } else {
                                swal("Por favor inserte su fecha de nacimiento.");
                                document.getElementById('dtNacimiento').value = "";
                            }



                        } else {
                            swal('Por favor inserte su EMail.');
                            document.objectInfo.email.focus();
                            swal('No es posible cambiar su Email, pues es parte de la información de acceso al sistema.');
                            document.objectInfo.email.value = "";
                        }
                    } else {
                        swal('Por favor inserte su Apellido Paterno.');
                        document.objectInfo.lastName.focus();

                    }
                } else {
                    swal('Por favor inserte su nombre.');
                    document.objectInfo.userName.focus();
                }
            } else {
                
                swal('Por favor seleccionar su Calle.');
            }}else{
            swal('Por favor seleccionar su Colonia.');
            }}else{
            swal('Por favor seleccionar su Municipio.');
            }


        }


        function verifyPassword(passw, confirmPassw) {
            if (passw !== confirmPassw) {
                swal("El password que eligió no es igual que en la confimación.");
                confirmPassw.value = "";
                confirmPassw.focus();
                return false;
            } else {
                return true;
            }
        }

        function openNewWindow() {
            swal('Abrir ventana con la imagen!');
        }

        function NewWindow(mypage, myname, w, h, scroll) {
            var winl = (screen.width - w) / 2;
            var wint = (screen.height - h) / 2;
            winprops = 'height=' + h + ',width=' + w + ',top=' + wint + ',left=' + winl + ',scrollbars=' + scroll + ',resizable';
            win = window.open(mypage, myname, winprops)
            if (parseInt(navigator.appVersion) >= 4) {
                win.window.focus();
            }
        }

    </script>
    <body onload="llenarcamposformulario();" oncontextmenu="return false;">
        <%@include file="Top.jsp" %>

        <div id="content">
            <div class="container-fluid my-4">
                <div class="row py2">
                    <div class="container py2">
                      <%@include file="MenuServicios.jsp" %>
                        
                        <%
                            String GETUSUARIODATA = oProperties.getProperty("GETUSUARIODATA");
                           
                            URL url = new URL(GETUSUARIODATA + usuario);
                            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                            conn.setRequestMethod("GET");
                            conn.setRequestProperty("Accept", "application/json");
                            conn.setRequestProperty("Authorization", "Bearer " + token);

                            if (conn.getResponseCode() != 200) {
                                System.out.println("GETUSUARIODATA error code: " + conn.getResponseMessage());
                                response.sendRedirect(INICIO);
                                //throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());

                            } else {
                                //TODO
                                InputStream inputStreamUserdit = conn.getInputStream();
                                String jsonuseredit = new String();
                                BufferedReader bufferedReaderuseredit = new BufferedReader(new InputStreamReader(inputStreamUserdit), 1);
                                String lineuseredit;
                                while ((lineuseredit = bufferedReaderuseredit.readLine()) != null) {
                                    jsonuseredit = lineuseredit;
                                    System.out.println("jsonlogin ::: " + jsonuseredit);
                                }

                                inputStreamUserdit.close();
                                bufferedReaderuseredit.close();
                                JSONObject jsonObjuseredit = new JSONObject(jsonuseredit);

                                //System.out.println("jsonObjuseredit ::: " + jsonObjuseredit.getString("Response").toString());
                                JSONObject jsonObjusereditdata = new JSONObject(jsonObjuseredit.getString("Response").toString());
                                JSONObject jsonObjusereditdatacampos = new JSONObject(jsonObjusereditdata.getString("data").toString());
                                //System.out.println("jsonObjusereditdatacampos ::: " + jsonObjusereditdatacampos.toString());
                                String strName = jsonObjusereditdatacampos.getString("StrNombre").toString();
                                String userName = new String(strName.getBytes("ISO-8859-1"), "UTF-8");
                                String strApellidoPat = jsonObjusereditdatacampos.getString("StrApellidoPaterno").toString();
                                String lastName = new String(strApellidoPat.getBytes("ISO-8859-1"), "UTF-8");
                                String strApellidoMat = jsonObjusereditdatacampos.getString("StrApellidoMaterno").toString();
                                String secondLastName = new String(strApellidoMat.getBytes("ISO-8859-1"), "UTF-8");
                                String cityname = new String();
                                String districtname = new String();
                                String streetname = new String();
                                String strCalle = jsonObjusereditdatacampos.getString("StrCalle").toString();
                                String strstreet = new String(strCalle.getBytes("ISO-8859-1"), "UTF-8");
                                String strdistrict = jsonObjusereditdatacampos.getString("StrColonia").toString();
                                String district = new String(strdistrict.getBytes("ISO-8859-1"), "UTF-8");
                                String strciudad = jsonObjusereditdatacampos.getString("StrCiudad").toString();
                                String city = new String(strciudad.getBytes("ISO-8859-1"), "UTF-8");
                                String strEstado = jsonObjusereditdatacampos.getString("StrEstado").toString();
                                String state = new String(strEstado.getBytes("ISO-8859-1"), "UTF-8");
                        %>
                        <script>
                            
                            //
                            function llenarcamposformulario() {
                                document.getElementById("userName").value = "<%=userName%>";
                                document.getElementById("lastName").value = "<%=lastName%>";
                                document.getElementById("secondLastName").value = "<%=secondLastName%>";
                                document.getElementById("email2").value = "<%=usuario%>";
                                document.getElementById("homeNumber").value = "<%=jsonObjusereditdatacampos.getString("StrNumeroInterior").toString()%>";
                                document.getElementById("homeNumberext").value = "<%=jsonObjusereditdatacampos.getString("StrNumeroExterior").toString()%>";
                                
                                document.getElementById("state").value = "<%=state%>";
                                document.getElementById("postalCode").value = "<%=jsonObjusereditdatacampos.getString("IntCodigoPostal").toString()%>";
                                document.getElementById("phone").value = "<%=jsonObjusereditdatacampos.getString("StrTelefono").toString()%>";
                                document.getElementById("sexo").value = "<%=jsonObjusereditdatacampos.getString("StrSexo").toString()%>";
                                var date = "<%=jsonObjusereditdatacampos.getString("DtmFechaNacimiento").toString()%>";
                                document.getElementById("dtNacimiento").value = date.substring(0, 10);
                                
                                document.getElementById("cityinput").value = "<%=city%>";
                                document.getElementById("district").value = "<%=district%>";
                                document.getElementById("street").value = "<%=strstreet%>";
                            }
                            
                        </script> 


                        <div class="col-12 col-lg-9 float-left">
                            <form id="Formmodificarcuenta" name="Formmodificarcuenta" method="POST" action="modificarcuenta">
                                <div id="editarCuenta">

                                    <fieldset>
                                        <h4>Modificar cuenta de acceso</h4>
                                        <p class="text">
                                            Para modificar su cuenta de acceso inserte la nueva información en los campos que desee.&nbsp;
                                            Al finalizar, dé click sobre el botón <b>Modificar</b> para que el sistema actualice su información.&nbsp;
                                        </p>

                                    </fieldset>
                                    <table class="table table-responsive table-sm" border="0">
                                        <tbody>
                                            <tr>
                                                <td><a href="#passwordModal" id="dialog"  class="btn btn-info btn-sm"  data-toggle="modal" data-target="#passwordModal"><i class="fa fa-search" aria-hidden="true"></i>
                                                        Cambiar contraseña</a></td>
                                            </tr>
                                            <tr>
                                                <td><font class="text"><b>Nombre (*)</b></font></td>
                                                <td><input type="text" id="userName" name="userName" style="max-width: 75%" maxlength="100" onblur="valusernam();" class="text"></td>
                                            </tr>
                                        <script>
                                            function valusernam() {
                                                var cadenacp1 = document.getElementById("userName").value;

                                                var expregcp1 = /^[A-Za-z\sÀ-ÿ\u00f1\u00d1]+$/;

                                                if (expregcp1.test(cadenacp1)) {
                                                } else {
                                                    document.getElementById("userName").value = "";
                                                    swal("El Nombre es incorrecto, deben ser sólo letras y de mínimo 2 caracteres");
                                                }
                                            }
                                        </script>
                                        <tr>
                                            <td><font class="text"><b>Apellido Paterno (*)</b></font></td>
                                            <td><input type="text" id="lastName" name="lastName" style="max-width: 75%" maxlength="100" class="text" onblur="vallastName();"></td>
                                        </tr>
                                        <script>
                                            function vallastName() {
                                                var cadenacp1 = document.getElementById("lastName").value;

                                                var expregcp1 = /^[A-Za-z\sÀ-ÿ\u00f1\u00d1]+$/;

                                                if (expregcp1.test(cadenacp1)) {
                                                } else {
                                                    document.getElementById("lastName").value = "";
                                                    swal("El Apellido Paterno es incorrecto, deben ser sólo letras y de mínimo 2 caracteres");
                                                }
                                            }
                                        </script>
                                        <tr>
                                            <td><font class="text"><b>Apellido Materno</b></font></td>
                                            <td><input type="text" id="secondLastName" name="secondLastName" style="max-width: 75%" maxlength="100" class="text" onblur="valsecondLastName();"></td>
                                        </tr>
                                        <script>
                                            function valsecondLastName() {
                                                var cadenacp1 = document.getElementById("secondLastName").value;

                                                var expregcp1 = /^[A-Za-z\sÀ-ÿ\u00f1\u00d1]+$/;

                                                if (expregcp1.test(cadenacp1)) {
                                                } else {
                                                    document.getElementById("secondLastName").value = "";
                                                    swal("El Apellido Materno es incorrecto, deben ser sólo letras y de mínimo 2 caracteres");
                                                }
                                            }
                                        </script>
                                        <tr>
                                            <td><font class="text"><b>Email (*) </b></font></td>
                                            <td><input onblur="valemail2();" type="text" name="email2" id="email2" style="max-width: 75%" maxlength="100" class="text"></td>
                                        </tr>
                                        <script>
                                            function valemail2() {
                                                var cadenacp1 = document.getElementById("email2").value;

                                                var expregcp1 = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/;

                                                if (expregcp1.test(cadenacp1)) {
                                                } else {
                                                    document.getElementById("email2").value = "";
                                                    swal("El Email es incorrecto, ejemplo: texto@provedor.com");
                                                }
                                            }
                                        </script>
                                        <%
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
//                                                        System.out.println("json Municipios " + JSONMunicipios);
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
                                                        
                                                        for(MunicipioDAO m:ListaMunicipios){
                                                        
                                                            if(m.getCod_depto().equalsIgnoreCase("0000"+city)){
                                                            cityname=m.getNom_depto();
                                                           // System.out.println("Municipio: "+m.getNom_depto()+" / COdigo: "+m.getCod_depto());
                                                            }
                                                        
                                                        }

                                                    }

                                                } catch (IOException ioe) {
                                                    Logger.getLogger(Autenticacion.class.getName()).log(Level.SEVERE, null, ioe);
                                                } catch (JSONException ex) {
                                                    Logger.getLogger(Autenticacion.class.getName()).log(Level.SEVERE, null, ex);
                                                }
                                                

                                            }
                                            URL urlcolonias= new URL(SELCOLONIAS+city);
                                            HttpURLConnection conncolonias= (HttpURLConnection) urlcolonias.openConnection();
                                            conncolonias.setRequestMethod("GET");
                                            conncolonias.setRequestProperty("Accept", "application/json");
                                            if (conncolonias.getResponseCode() != 200) {
                                            } else {
                                                try {

                                                    InputStream inputStreamcolonias = conncolonias.getInputStream();
                                                    String jsoncolonias = new String();
                                                    BufferedReader bufferedReadercolonias = new BufferedReader(new InputStreamReader(inputStreamcolonias), 1);
                                                    String line;
                                                    while ((line = bufferedReadercolonias.readLine()) != null) {
                                                        jsoncolonias = line;
                                                    }
                                                    inputStreamcolonias.close();
                                                    bufferedReadercolonias.close();
                                                   // System.out.println("json colonias ::: " + jsoncolonias);
                                                    JSONObject jsonObj = new JSONObject(jsoncolonias);

                                                    if ("null" != jsonObj.get("Response").toString()) {
                                                        //System.out.println("::jsonObj.get(\"Response\").toString():: "+jsonObj.get("Response").toString());
                                                        JSONObject jsonObjloginresponse = new JSONObject(jsonObj.get("Response").toString());
                                                        String jsonObjloginresponseSTR = jsonObjloginresponse.toString();

                                                        JSONObject JSONMunicipios = new JSONObject(jsonObjloginresponseSTR);
//                                                        System.out.println("json Colonias " + JSONMunicipios);
                                                        JSONArray jsonMunicipiosArray = JSONMunicipios.getJSONArray("data");
                                                        
                                                        

                                                        for (int i = 0; i < jsonMunicipiosArray.length(); i++) {
                                                            try {
                                                                JSONObject municipiojson = jsonMunicipiosArray.getJSONObject(i);
                                                                MunicipioDAO mun = new MunicipioDAO();

                                                                byte[] bytes = municipiojson.getString("NOM_LOCAL").getBytes(StandardCharsets.ISO_8859_1);
                                                                String utf8EncodedString = new String(bytes, StandardCharsets.UTF_8);
                                                                mun.setNom_depto(utf8EncodedString);
                                                                mun.setCod_depto(municipiojson.getString("COD_LOCAL"));
                                                                ListaDistrits.add(mun);
                                                                //System.out.println("cod: "+municipiojson.getString("COD_DEPTO")+" mun :::" + utf8EncodedString);
                                                            } catch (JSONException e) {
                                                                e.printStackTrace();
                                                            }
                                                        }
                                                        
                                                        for(MunicipioDAO m:ListaDistrits){
                                                        
                                                            if(m.getCod_depto().equalsIgnoreCase(district)){
                                                            districtname=m.getNom_depto();
                                                          //System.out.println("Colonia: "+m.getNom_depto()+" / COdigo: "+m.getCod_depto());
                                                            }
                                                        
                                                        }

                                                    }

                                                } catch (IOException ioe) {
                                                    Logger.getLogger(Autenticacion.class.getName()).log(Level.SEVERE, null, ioe);
                                                } catch (JSONException ex) {
                                                    Logger.getLogger(Autenticacion.class.getName()).log(Level.SEVERE, null, ex);
                                                }
                                                

                                            }
                                            URL urlcalles= new URL(SELCALLES+district+"&citycode="+city);
//                                            System.out.println("urlcalles :: "+urlcalles);
                                            HttpURLConnection conncalles= (HttpURLConnection) urlcalles.openConnection();
                                            conncalles.setRequestMethod("GET");
                                            conncalles.setRequestProperty("Accept", "application/json");
                                            if (conncalles.getResponseCode() != 200) {
                                            } else {
                                                try {

                                                    InputStream inputStreamcalles = conncalles.getInputStream();
                                                    String jsoncalles = new String();
                                                    BufferedReader bufferedReadercalles = new BufferedReader(new InputStreamReader(inputStreamcalles), 1);
                                                    String line;
                                                    while ((line = bufferedReadercalles.readLine()) != null) {
                                                        jsoncalles = line;
                                                    }
                                                    inputStreamcalles.close();
                                                    bufferedReadercalles.close();
//                                                   System.out.println("json calles ::: " + jsoncalles);
                                                    JSONObject jsonObj = new JSONObject(jsoncalles);

                                                    if ("null" != jsonObj.get("Response").toString()) {
                                                        //System.out.println("::jsonObj.get(\"Response\").toString():: "+jsonObj.get("Response").toString());
                                                        JSONObject jsonObjloginresponse = new JSONObject(jsonObj.get("Response").toString());
                                                        String jsonObjloginresponseSTR = jsonObjloginresponse.toString();

                                                        JSONObject JSONCalles = new JSONObject(jsonObjloginresponseSTR);
//                                                        System.out.println("json Calles " + JSONCalles);
                                                        JSONArray jsonMunicipiosArray = JSONCalles.getJSONArray("data");
                                                        
                                                        

                                                        for (int i = 0; i < jsonMunicipiosArray.length(); i++) {
                                                            try {
                                                                JSONObject municipiojson = jsonMunicipiosArray.getJSONObject(i);
                                                                MunicipioDAO mun = new MunicipioDAO();

                                                                byte[] bytes = municipiojson.getString("NOM_CALLE").getBytes(StandardCharsets.ISO_8859_1);
                                                                String utf8EncodedString = new String(bytes, StandardCharsets.UTF_8);
                                                                mun.setNom_depto(utf8EncodedString);
                                                                mun.setCod_depto(municipiojson.getString("COD_CALLE"));
                                                                ListaStreets.add(mun);
//                                                                System.out.println("cod: "+municipiojson.getString("COD_CALLE")+" mun :::" + utf8EncodedString);
                                                            } catch (JSONException e) {
                                                                e.printStackTrace();
                                                            }
                                                        }
                                                        
                                                        for(MunicipioDAO m:  ListaStreets){
                                                        
                                                            if(m.getCod_depto().equalsIgnoreCase("0000"+strstreet)){
                                                            streetname=m.getNom_depto();
//                                                          System.out.println("Calle "+m.getNom_depto()+" / COdigo: "+m.getCod_depto());
                                                            }
                                                        
                                                        }

                                                    }

                                                } catch (IOException ioe) {
                                                    Logger.getLogger(Autenticacion.class.getName()).log(Level.SEVERE, null, ioe);
                                                } catch (JSONException ex) {
                                                    Logger.getLogger(Autenticacion.class.getName()).log(Level.SEVERE, null, ex);
                                                }
                                                

                                            }


                                        %>
                                        <tr><td><font class="text"><b>Estado</b></font></td>
                                            <td><input value="Nuevo León"id="state" placeholder="Nuevo León"  type="text"  name="state" style="max-width: 75%" maxlength="100" class="text" readonly></td>
                                        </tr>
                                        <tr>
                                            <td><font class="text"><b>Ciudad</b></font></td>
                                            <td>
                                                <input id="cityinputname" name="cityinputname" onclick="mostrarselects();" value="<%=cityname%>" style="max-width: 75%" readonly >
                                                <input id="cityinput" name="cityinput"  style="max-width: 75%" readonly hidden>
                                                <select id="city" name="city" class="form-select" style="max-width: 75%" aria-label="Default select example" onchange="calculaColnias();" hidden >
                                                    <option disabled selected>Municipio</option>
                                                    <%for (MunicipioDAO m : ListaMunicipios) {%>
                                                    <option value="<%=m.getCod_depto()%>_<%=m.getNom_depto()%>"><%=m.getNom_depto()%></option>
                                                    <%}%>
                                                </select>
                                            </td>
                                        </tr>
                                        <script>
                                            function mostrarselects() {
                                                
                                                document.getElementById("cityinputname").hidden=true;
                                                document.getElementById("districtname").hidden=true;
                                                document.getElementById("streetname").hidden=true;
                                                document.getElementById("city").hidden=false;
                                                document.getElementById("districtselect").hidden=false;
                                                document.getElementById("streetselect").hidden=false;

                                            }
                                            function calculaColnias() {
                                                $('#districtselect').empty();
                                                
                                                document.getElementById("district").value = "";
                                                document.getElementById("street").value = "";
                                                var txt = document.getElementById("city").value;
                                                var codcol = txt.split("_", 1);

                                                var nomcol = txt.replace(txt.split("_", 1), "");
                                                nomcol = nomcol.replaceAll("_", "");
                                                document.getElementById("cityinput").value = codcol;
                                                const url = '<%=SELCOLONIAS%>' + codcol;
                                                //alert(url.toString());
                                                const http = new XMLHttpRequest();
                                                http.open("GET", url, true);
//                                                http.setRequestHeader('Access-Control-Allow-Headers', '*');
//                                                http.setRequestHeader('Content-type', 'application/ecmascript');
//                                                http.setRequestHeader('Access-Control-Allow-Origin', '*');
//                                                alert('ok');

                                                //                                            alert(http.onreadystatechange);
                                                http.onreadystatechange = function () {

                                                    if (this.readyState === 4 && this.status === 200) {
                                                        var str = this.responseText;

                                                        str = str.substring(70, str.length - 2);
//                                                        alert(str);
                                                        var resultado = JSON.parse(str);
                                                        var $select = $('#districtselect');

                                                        $.each(resultado, function (id, name) {
                                                            $select.append('<option value=' + name.COD_LOCAL + "_" + name.NOM_LOCAL.replaceAll(" ", "/") + '>' + name.NOM_LOCAL + '</option>');
                                                        });

                                                    }
                                                }
                                                http.send();

                                            }
                                        </script>
                                        <tr><td><font class="text"><b>Colonia</b></font></td>
                                            <td><input id="districtname" type="text" name="districtname" style="max-width: 75%" value="<%=districtname%>" class="text" onclick="mostrarselectsdistricts();"  readonly >
                                                <input id="district" type="text" name="district" style="max-width: 75%"  class="text" onclick="mostrarselectsdistricts();"  readonly hidden  >
                                                <select id="districtselect" name="districtselect" style="max-width: 75%" class="form-select" aria-label="Default select example" onchange="cargardistrict();" hidden  >
                                                    <option disabled selected>Colonia</option>
                                                </select>
                                            </td>
                                        <script>
                                            function mostrarselectsdistricts(){
                                                document.getElementById("cityinputname").hidden=true;
                                                document.getElementById("districtname").hidden=true;
                                                document.getElementById("streetname").hidden=true;
                                                document.getElementById("city").hidden=false;
                                                document.getElementById("districtselect").hidden=false;
                                                document.getElementById("streetselect").hidden=false;
                                            }
                                            function cargardistrict() {
                                                $('#streetselect').empty();

                                                document.getElementById("district").value = document.getElementById("districtselect").value;

                                                document.getElementById("street").value = "";
                                                var txtcalle = document.getElementById("district").value;
                                                var codcalle = txtcalle.split("_", 1);
                                                var nomcalle = txtcalle.replaceAll("/", " ");
                                                nomcalle = nomcalle.replaceAll(txtcalle.split("_", 1), "");
                                                nomcalle = nomcalle.replaceAll("_", "");
                                                document.getElementById("district").value = codcalle;
                                                var txt = document.getElementById("city").value;
                                                var codcol = txt.split("_", 1);
                                                const url = '<%=SELCALLES%>' + codcalle + "&citycode=" + codcol;
                                                const http = new XMLHttpRequest();
                                                http.open("GET", url)
                                                http.onreadystatechange = function () {

                                                    if (this.readyState == 4 && this.status == 200) {
                                                        var str = this.responseText;

                                                        str = str.substring(70, str.length - 2);
                                                        var resultado = JSON.parse(str);
                                                        var $select = $('#streetselect');

                                                        $.each(resultado, function (id, name) {
                                                            $select.append('<option value=' + name.COD_CALLE + '>' + name.NOM_CALLE + '</option>');
                                                        });

                                                    }
                                                }
                                                http.send();
                                            }
                                        </script>
                                        </tr>
                                        <tr>
                                            <td><font class="text"><b>Calle</b></font></td>
                                            <td><input id="streetname" type="text" name="streetname" style="max-width: 75%" value="<%=streetname%>" class="text" onclick="mostrarselectsstreets();"  readonly >
                                                <input id="street" type="text" name="street" style="max-width: 75%" class="text"   readonly hidden>
                                                <select id="streetselect" name="streetselect" style="max-width: 75%" class="form-select" aria-label="Default select example"  onchange="cargarcalle();" hidden>
                                                    <option disabled selected>Calle</option>
                                                </select>

                                            </td>
                                        <script>
                                            function mostrarselectsstreets(){
                                                document.getElementById("cityinputname").hidden=true;
                                                document.getElementById("districtname").hidden=true;
                                                document.getElementById("streetname").hidden=true;
                                                document.getElementById("city").hidden=false;
                                                document.getElementById("districtselect").hidden=false;
                                                document.getElementById("streetselect").hidden=false;
                                            }
                                            function cargarcalle() {

                                                var txtc = document.getElementById("streetselect").value;

                                                txtc = txtc.replaceAll("/", " ");
                                                document.getElementById("street").value = txtc;
                                            }
                                        </script>
                                        </tr>
                                        <tr>
                                            <td><font class="text"><b>Número</b></font></td>
                                            <td><input id="homeNumber" type="text" name="homeNumber" style="max-width: 75%" maxlength="20" class="text"></td>
                                        </tr>
                                        <tr>
                                            <td><font class="text"><b>Número Exterior</b></font></td>
                                            <td><input id="homeNumberext" type="text" name="homeNumberext" style="max-width: 75%" maxlength="20" class="text"></td>
                                        </tr>
                                        <tr>
                                            <td><font class="text"><b>Código Postal</b></font></td>
                                            <td><input <input type="text" id="postalCode" name="postalCode" maxlength="5" style="max-width: 75%" class="default" onblur="cpvali();" ></td>
                                        </tr>
                                        <script>
                                            function cpvali() {
                                                var cadenacp = document.getElementById("postalCode").value;
                                                var expregcp = /^(?:0[0-9]|[0-9]\d|9[0-9])\d{3}$/;

                                                if (expregcp.test(cadenacp)) {

                                                } else {
                                                    document.getElementById("postalCode").value = "";
                                                    swal("El Código postal es incorrecto, debe ser numérico y de 5 dígitos.");
                                                }
                                            }
                                        </script>
                                        <tr><td><font class="text"><b>Teléfono</b></font></td>
                                            <td><input type="text" id="phone" name="phone" style="max-width: 75%" maxlength="10" class="text" onblur="valphone();"></td>
                                        </tr>
                                        <script>
                                            function valphone() {
                                                var cadenacp = document.getElementById("phone").value;
                                                var expregcp = /^\D*\d{10}$/;

                                                if (expregcp.test(cadenacp)) {

                                                } else {
                                                    document.getElementById("phone").value = "";
                                                    swal("El Teléfono es incorrecto, debe ser numérico y a 10 dígitos.");
                                                }
                                            }
                                        </script>
                                        <tr>
                                            <td><font class="text"><b>¿Cuál es su fecha de nacimiemto? (*)</b></font></td>
                                            <td><input type="date" id="dtNacimiento" name="dtNacimiento" style="max-width: 100%" maxlength="100" class="text" required></td>
                                        </tr>
                                        <tr>
                                            <td><font class="text"><b>¿Cuál es su sexo? (*)</b></font></td>
                                            <td><select type="text" id="sexo" style="max-width: 75%"  name="sexo"  >
                                                    <option value="">Selecciona un sexo</option>
                                                    <option value="Masculino">Masculino</option>
                                                    <option value="Femenino">Femenino</option>
                                                </select></td>
                                        <input hidden id="token" name="token" value="<%=token%>">
                                        </tr>
                                        </tbody></table>   <%}%>
                                    <p><b>Nota : </b>Los campos marcados con <b>(*)</b> deber&aacute;n ser llenados forzosamente, el resto son opcional.</p>

                                    <input class="btn btn-outline-secondary" type="button" value="Modificar" onclick="validateForm();">
                                    &nbsp;&nbsp;&nbsp;
                                    <input class="btn btn-danger" type="button" value="Cancelar" onclick="location.href = 'Inicio.jsp';">
                                </div>

                            </form>
                        </div>

                    </div>
                </div>
            </div>
        </div>
        <%@include file="Bottom.jsp" %>
    </div>


    <div class="modal fade" id="passwordModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" style="margin-top: 150px;">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="facturaModalLabel">Cambiar contraseña</h5>
                    <input id="nisfacturas" hidden >
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <form id="Formmodificarpass" name="Formmodificarpass" method="POST" action="modificarpassword">
                    <div class="modal-body">
                        <table>
                            <script>
                                function validarpss() {
                                    if (document.getElementById('passwordactual').value !== "") {

                                        if (document.getElementById('password').value !== "") {
                                            if (document.getElementById('passwordConfirm').value !== "") {
                                                if (document.getElementById('passwordConfirm').value === document.getElementById('password').value) {

                                                    $("#Formmodificarpass").submit();
                                                } else {
                                                    swal("La contraseña y su confirmación no son iguales");
                                                    document.getElementById('password').value = "";
                                                }
                                            } else {
                                                swal("Por favor escriba la confirmación de la contraseña.");
                                                document.getElementById('passwordConfirm').value = "";
                                            }
                                        } else {
                                            swal("Por favor escriba la contraseña que desea.");
                                            document.getElementById('password').value = "";
                                        }


                                    } else {
                                        swal("Por favor escriba la contraseña actual.");
                                        document.getElementById('passwordactual').value = "";
                                    }

                                }
                            </script>
                            <tbody>
                                <tr><td ><font class="text"><b>Indique la contraseña actual (*)</b></font></td>
                                    <td ><input type="password" id="passwordactual" name="passwordactual" style="max-width: 100%" maxlength="50" class="default"></td>
                                </tr>
                                <tr><td ><font style="margin-top: 10px;" class="text"><b>Indique la contraseña que desea (*)</b></font></td>
                                    <td ><input style="margin-top: 10px;" type="password" id="password" name="password" style="max-width: 90%" onblur="valpass();" maxlength="50" class="default"></td>
                                </tr>
                            <script>
                                function valpass() {

                                    var cadena = document.getElementById("password").value;
                                    var expreg = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$-_<.>!%*?.<>?:;}={+&])[A-Za-z\d$@$-_<.>!%*?&]{8,20}$/;

                                    if (expreg.test(cadena)) {
                                    } else {
                                        document.getElementById("password").value = "";
                                        swal("Contraseña NO es correcta. Debe contener Mayusculas, minusculas, números,  mínimo uno de estos signos -_<.>!$%&?*   y de almenos 8 caracteres de longitud.");
                                    }
                                }

                            </script>
                            <tr>
                                <td><font style="margin-top: 10px;" class="text"><b>Confirmar nueva contraseña (*)</b></font></td>
                                <td><input style="margin-top: 10px;" type="password" id="passwordConfirm" name="passwordConfirm" style="max-width: 90%" maxlength="50" class="default"></td>
                            </tr> 
                            <tr>
                                <td><input style="margin-top: 10px;" class="btn btn-outline-secondary" type="button" value="Cambiar" onclick="validarpss()"></td>
                                <td><input style="margin-top: 10px;" class="btn btn-outline-danger" type="button" value="Cancelar" onclick="location.href = 'UserEdit.jsp';"></td>
                            </tr>
                            <input hidden name="token" value="<%=token%>">
                            <input hidden name="email" value="<%=usuario%>">
                            </tbody>
                        </table>


                    </div>
                </form>
                <div>
                </div></div></div>
    </div>
</body> 
</html>
<%}%>