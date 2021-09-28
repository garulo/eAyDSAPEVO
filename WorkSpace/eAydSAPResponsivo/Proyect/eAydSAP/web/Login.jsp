<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@ include file="HeaderOptions.jsp" %>
        <title>Pago de Servicios en L&iacute;nea (Login)</title>

    </head>
    <body>
    <center>
        <script language="Javascript">

            function validateForm() {
                if (document.loginForm.email.value !== "") {

                    if (document.loginForm.password.value !== "") {
                        expr = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                        if (!expr.test(document.loginForm.email.value)) {
                            swal("Email es inválido!", "Error: La dirección de correo : " + document.loginForm.email.value + " : no es válido.", "error").then((value) => {
                                window.parent.location.href = 'https://ayd.sadm.gob.mx/eAyd/'
                            });


                            document.loginForm.email.value = "";

                        } else {
                            document.loginForm.submit();
                        }

                    } else {
                        swal("Password es inválido!", "Por favor inserte el password.", "error").then((value) => {
                            window.parent.location.href = 'https://ayd.sadm.gob.mx/eAyd/'
                        });

                        document.loginForm.password.focus();
                    }
                } else {
                    swal("Email es inválido!", "Por favor inserte el email.", "error").then((value) => {
                        window.parent.location.href = 'https://ayd.sadm.gob.mx/eAyd/'
                    });
                    document.loginForm.email.focus();
                }
            }





        </script>
        <style>
            a {
                text-decoration: none !important;
            }
            a:hover {
                color: #0056b3;
                text-decoration: none !important;
            }
        </style>
        <%@include file="Top.jsp" %>

        <div id="content" style="width: 80%">
            <div class="container-fluid my-4" ">
                <div   class="row py-2"">
                    <div class="container py-2" >
                        <!--                        <div hidden class="login-container col-12 col-lg-10 float-centre py-4" style="margin-left: 5%;">
                                                    <h2 class="text-center mt-1 mb-3">Disculpe las molestias, por el momento no le podemos atender en este medio.</h2>
                                                    <h3 class="text-center mt-1 mb-3">Lo invitamos a ingresar a través de nuestra APP.</h3> 
                                                    <label>Encuentranos como AYD en Google Play y App Store.</label>
                                                    <br>
                                                    <img src="imagenes/AyDqr.png" onclick="window.parent.location.href = 'https://www.sadm.gob.mx/SADM/qr.html';" style="width: 50%;margin: 5px;"/>
                                                    <br>
                                                </div>-->
                        <div style="text-align: left;" class="login-container col-12 col-lg-5 float-left py-4">
                            <form name="loginForm" method="POST" action="autenticacione">

                                <input hidden  name="command" value="">   

                                <h3 class="text-center mt-1 mb-3">Ingreso a Servicio en Línea</h3>
                                <label for="email">E-Mail:</label>
                                <input type="text" name="email" size="30" class="form-control" value=""><br>

                                <label for="password">Contraseña:</label>
                                <input type="password" name="password" size="30" class="form-control" value=""><br>

                                <label>&nbsp;</label>
                                <input   type="button" value="Continuar" onClick="validateForm();" class="btn btn-outline-secondary"><br>

                                <hr>
                            </form>
                            <div class="text-right">
                                <a href="GetPassword.jsp"><font class="pass"><b>¿Olvidó su password?</b></font></a><br>
                                <a href="UserRegistration.jsp"><font class="pass"><b>No estoy Registrado</b></font></a>
                            </div>
                        </div>
                        
                        <div  id="no-registrado" class=" col-12 offset-lg-1 col-lg-6 float-left py-4">

                            <div class="row text-center"><h3 class="text-center mt-1 mb-3  pl-3 pr-3 mx-auto pb-2">No estoy Registrado.</h3></div>
                            <div class="mt-3">
                                <p>Con el Servicio en Línea de Servicios de Agua y Drenaje de Monterrey podrás obtener:<br></p>
                                <ul>
                                    <li>Descarga de Facturas Electronicas de tus servicos</li>
                                    <!--<li>Envío de Facturas Electronicas por EMail</li>
                                    <li>Te notificamos si hay alguna falta de Suministro de Agua</li>
                                    <li>Recordatorios de Pagos</li>
                                    <li>Te avisamos cuando se haya generado una orden de corte o reducción</li>
                                    <li>Además, podrás decidir si deseas que no te llegue tu Factura a Domicilio.</li>-->
                                </ul>
                                <br>
                                 

                                    <a  href="UserRegistration.jsp?userEmail=1" class="btn btn-outline-secondary" >Regístrate aquí</a>
                                   <br>
                                   
                                <div class="text-center">
                                </div>
                            </div>
                        </div>
                         <div   class=" col-12 offset-lg-1 col-lg-6 float-left py-4" style="margin-left: 5%;">
                                        
                                         <label>Encuentranos como AYD en Google Play y App Store.</label>
                                        <br>
                                        <img src="imagenes/AyDqr.png" onclick="window.parent.location.href = 'https://www.sadm.gob.mx/SADM/qr.html';" style="width: 50%;margin: 5px;"/>
                                        <br>
                                    </div>
                    </div>

                </div>
            </div>
            <div class="container-fluid">
                <div class="container text-center">
                    <img class="img-fluid" src="images/veri_sign.gif" style="max-width: 300px;">
                </div>
            </div>
        </div>
        <%@include file="Bottom.jsp" %>
    </center>
</body>
</html>
