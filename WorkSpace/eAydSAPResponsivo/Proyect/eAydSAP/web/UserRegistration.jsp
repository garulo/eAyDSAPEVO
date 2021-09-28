
<%@page import="java.util.Collections"%>
<%@page import="java.io.IOException"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="com.ayd.dao.RutaProperties"%>
<%@page import="java.util.Properties"%>
<%@page import="java.util.Properties"%>
<%@page import="com.ayd.dao.MunicipioDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%

    String userEmail;

    userEmail = (String) request.getAttribute("userEmail");

    if (userEmail == null) {
        userEmail = "1";
    }
    ArrayList<MunicipioDAO> ListaMunicipios = new ArrayList<MunicipioDAO>();
    Properties oProperties = new Properties();
     RutaProperties rp = new RutaProperties();
    InputStream isArchivo = new FileInputStream(rp.getRuta());
    oProperties.load(isArchivo);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "https://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta name="tipo_contenido"  content="text/html;" http-equiv="content-type" charset="utf-8">
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <META HTTP-EQUIV="PRAGMA" CONTENT="NO-CACHE">
        <META HTTP-EQUIV="Expires" CONTENT="-1">
        <meta http-equiv="Content-Type" content="text/html charset=utf-8">
        <script language="JavaScript" src="js/jquery3.js"></script>
        <title>Registro de Usuarios</title>
        <%@ include file="HeaderOptions.jsp" %>
        <script language="JavaScript">
            function validateForm()
            {
                if (document.getElementById('userName').value !== "") {
                    if (document.getElementById('lastName').value !== "") {
                        if (document.getElementById('emails').value !== "") {
                            if (document.getElementById('password').value !== "") {
                                if (document.getElementById('dtNacimiento').value !== "") {
                                    if (document.getElementById('sexo').value !== "") {
                                        if (document.getElementById('password').value !== document.getElementById('passwordConfirm').value) {
                                            swal("Las contraseñas son diferentes");
                                        } else {
                                            //    mostrarVerificar();
                                            $("#objectInfo").submit();
                                        }

                                    } else {
                                        ("Por favor inserte su sexo.");
                                        document.objectInfo.sexo.focus();
                                    }

                                } else {
                                    swal("Por favor inserte su fecha de nacimiento.");
                                    document.objectInfo.dtNacimiento.focus();
                                }

                            } else {
                                swal("Por favor inserte su clave de acceso.");
                                document.objectInfo.password.focus();
                            }

                        } else {
                            swal('Por favor inserte su Email.');
                            document.objectInfo.emails.focus();
                        }
                    } else {
                        swal('Por favor inserte su Apellido Paterno.');
                        document.objectInfo.lastName.focus();

                    }
                } else {
                    swal('Por favor inserte su nombre.');
                    document.objectInfo.userName.focus();
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
                winprops = 'height=' + h + ',width=' + w + ',top=' + wint + ',left=' + winl + ',scrollbars=' + scroll + ',resizable'
                win = window.open(mypage, myname, winprops)
                if (parseInt(navigator.appVersion) >= 4) {
                    win.window.focus();
                }
            }

        </script>
        <link href="imagenes/logo_transp.gif" rel="shortcut icon" type="image/x-icon" />
        <link href="imagenes/logo_transp.gif" rel="apple-touch-icon" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="styles/webflow1.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow4.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow3.css" rel="stylesheet" type="text/css" />

    </head>
    <body oncontextmenu="return false;">
        <!-- HEADER -->
        <%@include file="Top.jsp" %>


        <div class="container-fluid my-4">
            <div class="row py2">
                <div class="container py2">

                    <div class="col-12 col-lg-3 float-left">
                        <div id="datos_usuario2">
                            <img id="imgLogo" src="imagenes/logo_transp.gif" style="margin-left: 5%;" border="0">

                        </div>
                    </div>
                    <div class="col-12 col-lg-9 float-left">
                        <form id="objectInfo" name="objectInfo" method="POST" action="registrarcuenta">
                            <div id="crearCuenta">
                                <fieldset>
                                    <h4>Crear nueva cuenta de acceso</h4>
                                    <p  >
                                        Por el momento este servicio solo esta disponible para usuarios del Área Metropolitana
                                        Para crear una nueva cuenta de acceso al sistema de pagos en l&iacute;nea, es necesario que inserte la informaci&oacute;n requerida.

                                        Al finalizar, d&eacute; click sobre el bot&oacute;n <b>Registrar</b> para que el sistema verifique su informaci&oacute;n.


                                    </p>

                                </fieldset>
                                <table class="table table-responsive table-sm" border="0">
                                    <tbody>
                                        <tr>
                                            <td><font class="text"><b>Nombre (*)</b></font></td>
                                            <td><input onblur="valusernam();" type="text" id="userName" name="userName" style="max-width: 90%" maxlength="50" class="text"></td>
                                        </tr>
                                    <script>
                                        function valusernam() {
                                            document.getElementById('nombre2').value = document.getElementById('userName').value;
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
                                        <td><input type="text" id="lastName" name="lastName" style="max-width: 90%" maxlength="100" class="text" onblur="vallastName();"></td>
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
                                        <td><input type="text" id="secondLastName" name="secondLastName" style="max-width: 90%" maxlength="100" class="text" onblur="valsecondLastName();"></td>
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
                                        <td><input onblur="valemail2();" type="text" name="emails" id="emails" style="max-width: 90%" maxlength="100" class="text"></td>
                                    </tr>
                                    <script>
                                        function valemail2() {

                                            var cadenacp1 = document.getElementById("emails").value;
                                            var expregcp1 = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/;

                                            if (expregcp1.test(cadenacp1)) {
                                            } else {
                                                document.getElementById("emails").value = "";
                                                swal("El Email es incorrecto, ejemplo: texto@provedor.com");
                                            }
                                        }
                                    </script>

                                    <%
                                        String SELMUNICIPIOS = oProperties.getProperty("SELMUNICIPIOS");
//                                        String SELMUNICIPIOS ="https://ayd.sadm.gob.mx/api/SelMunicipiosProd";
                                        URL url = new URL(SELMUNICIPIOS);
                                        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                                        conn.setRequestMethod("GET");
                                        conn.setRequestProperty("Accept", "application/json");
                                        if (conn.getResponseCode() != 200) {
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

                                                if ("null" != jsonObj.get("Response").toString()) {
                                                    //System.out.println("::jsonObj.get(\"Response\").toString():: "+jsonObj.get("Response").toString());
                                                    JSONObject jsonObjloginresponse = new JSONObject(jsonObj.get("Response").toString());
                                                    String jsonObjloginresponseSTR = jsonObjloginresponse.toString();

                                                    JSONObject JSONMunicipios = new JSONObject(jsonObjloginresponseSTR);
                                                    //System.out.println("Municipios " + JSONMunicipios);
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
                                                            // System.out.println("mun :::" + utf8EncodedString);
                                                        } catch (JSONException e) {
                                                            e.printStackTrace();
                                                        }
                                                    }

                                                }

                                            } catch (IOException ioe) {
                                                ioe.printStackTrace();
                                            } catch (JSONException ex) {
                                               ex.printStackTrace();
                                            }

                                        }
                                  // Collections.sort(ListaMunicipios, (o1, o2) -> o1.getNom_depto().compareTo(o2.getNom_depto()));
                                    %>
                                    <tr><td><font class="text"><b>Estado</b></font></td>
                                        <td><input value="Nuevo León"id="state" type="text" name="state" style="max-width: 90%" maxlength="100" class="text" readonly></td>
                                    </tr>
                                    <tr>
                                        <td><font class="text"><b>Ciudad</b></font></td>
                                        <td>
                                            <input id="cityinput" name="cityinput" hidden >
                                            <select id="city" name="city" class="form-select" style="max-width: 90%" aria-label="Default select example" onchange="calculaColnias();">
                                                <%for (MunicipioDAO m : ListaMunicipios) {%>
                                                <option value="<%=m.getCod_depto()%>_<%=m.getNom_depto()%>"><%=m.getNom_depto()%></option>
                                                <%}%>
                                            </select></td></td>
                                    </tr>

                                    <script>
                                        var col ;
                                        function calculaColnias() {
                                            $('#districtselect').empty();
                                            $('#streetselect').empty();
                                            document.getElementById("district").value = "";
                                            document.getElementById("street").value = "";
                                            var txt = document.getElementById("city").value;
                                            var codcol = txt.split("_", 1);
                                            var nomcol = txt.replace(txt.split("_", 1), "");
                                            nomcol = nomcol.replaceAll("_", "");
                                            document.getElementById("cityinput").value = codcol;
//                                            const url = 'https://ayd.sadm.gob.mx/api/SelColoniasProd?municipio=' + codcol;
                                            const url = 'https://ayd.sadm.gob.mx/appiV3/SelColonias_SAP700?municipio=' + codcol;
                                            col = codcol;
                                            const http = new XMLHttpRequest();
                                            http.open("GET", url);
                                            
                                       
                                            
                                            http.onreadystatechange = function () {

                                                if (this.readyState == 4 && this.status == 200) {
                                                    var str = this.responseText;
                                                    
                                                    str = str.substring(70, str.length - 2);
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
                                        <td><input id="district" type="text" name="district"  class="text" hidden>
                                            <select id="districtselect" name="districtselect" style="max-width: 90%" class="form-select" aria-label="Default select example" onchange="cargardistrict();"  ></select>
                                        </td>
                                    <script>
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
//                                            const url = 'https://ayd.sadm.gob.mx/api/SelCallesProd?colonia=' + codcalle;
                                            const url = 'https://ayd.sadm.gob.mx/appiV3/SelCalles_SAP700?colonia=' + codcalle+"&citycode="+col;
                                            const http = new XMLHttpRequest();
                                            http.open("GET", url)
                                            http.onreadystatechange = function () {

                                                if (this.readyState == 4 && this.status == 200) {
                                                    var str = this.responseText;

                                                    str = str.substring(70, str.length - 2);
                                                    var resultado = JSON.parse(str);
                                                    var $select = $('#streetselect');

                                                    $.each(resultado, function (id, name) {
                                                        $select.append('<option value=' + name.COD_CALLE.replaceAll(" ", "/") + '>' + name.NOM_CALLE + '</option>');
                                                    });

                                                }
                                            }
                                            http.send();
                                        }
                                    </script>
                                    </tr>
                                    <tr>
                                        <td><font class="text"><b>Calle</b></font></td>
                                        <td><input id="street" type="text" name="street" class="text" hidden>
                                            <select id="streetselect" name="streetselect" style="max-width: 90%" class="form-select" aria-label="Default select example" onchange="cargarcalle();"  ></select>

                                        </td>
                                    <script>
                                        function cargarcalle() {

                                            var txtc = document.getElementById("streetselect").value;
                                            txtc = txtc.replaceAll("/", " ");
                                            document.getElementById("street").value = txtc;
                                        }
                                    </script>
                                    </tr>
                                    <tr>
                                        <td><font class="text"><b>Número</b></font></td>
                                        <td><input id="homeNumber" type="text" name="homeNumber" style="max-width: 90%" maxlength="30" class="text"></td>
                                    </tr>
                                    <tr>
                                        <td><font class="text"><b>Número Exterior</b></font></td>
                                        <td><input id="homeNumberext" type="text" name="homeNumberext" style="max-width: 90%" maxlength="30" class="text"></td>
                                    </tr>

                                    <tr>
                                        <td><font class="text"><b>Código Postal</b></font></td>
                                        <td><input type="text" id="postalCode" name="postalCode" maxlength="5" style="max-width: 90%" class="default" onblur="cpvali();" ></td>
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
                                    </tr>
                                    <tr><td><font class="text"><b>Teléfono</b></font></td>
                                        <td><input type="text" id="phone" name="phone" style="max-width: 90%" maxlength="10" class="text" onblur="valphone();"></td>
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
                                    <tr><td><font class="text"><b>Indique la contraseña que desea (*)</b></font></td>
                                        <td><input type="password" id="password" name="password" onblur="validarpass();" style="max-width: 90%" maxlength="50" class="default"></td>
                                    </tr>
                                    <script>
                                        function validarpass() {

                                            var cadena = document.getElementById("password").value;
                                            var expreg = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$-_<.>!%*?.<>?:;}={+&])[A-Za-z\d$@$-_<.>!%*?&]{8,20}$/;

                                            if (expreg.test(cadena)) {
                                            } else {
                                                document.getElementById("password").value = "";
                                                swal("Contraseña NO es correcta. Debe contener Mayusculas, minusculas, números, mínimo uno de estos signos -_<.>!$%&?*  y de almenos 8 caracteres de longitud.");
                                            }
                                        }

                                    </script>
                                    <tr>
                                        <td><font class="text"><b>Confirmar Contraseña (*)</b></font></td>
                                        <td><input  type="password" id="passwordConfirm" name="passwordConfirm" style="max-width: 90%" maxlength="50" class="default"></td>

                                    </tr>
                                    <tr>
                                        <td><font class="text"><b>¿Cuál es su fecha de nacimiemto? (*)</b></font></td>
                                        <td><input type="date" id="dtNacimiento" name="dtNacimiento" style="max-width: 100%" maxlength="100" class="text" required></td>
                                    </tr>
                                    <tr>
                                        <td><font class="text"><b>¿Cuál es su sexo? (*)</b></font></td>
                                        <td><select type="text" id="sexo" style="max-width: 100%" name="sexo"  >
                                                <option value="">Selecciona un sexo</option>
                                                <option value="Masculino">Masculino</option>
                                                <option value="Femenino">Femenino</option>
                                            </select></td>
                                    </tr>
                                    </tbody></table>
                                <p><b>Nota : </b>Los campos marcados con <b>(*)</b> deber&aacute;n ser llenados forzosamente, el resto son opcional.</p>
                                <input class="btn btn-outline-secondary" type="button" value="Registrar" onclick="validateForm();">
                            </div>

                            
                        </form>
                    </div>

                </div>
            </div>
        </div>
<div id="clearRow" style="height: 20px;"></div>
</div>

<%@include file="Bottom.jsp" %>
</body>

</html>