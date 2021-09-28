<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "https://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <META HTTP-EQUIV="PRAGMA" CONTENT="NO-CACHE">
        <META HTTP-EQUIV="Expires" CONTENT="-1">
        <title>Recuperar Password</title>
        <%@ include file="HeaderOptions.jsp" %>
        <script language="JavaScript" src="js/infoVal.js"></script>
        <link href="styles/webflow1.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow4.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow3.css" rel="stylesheet" type="text/css" />
        <link href="imagenes/logo_transp.gif" rel="shortcut icon" type="image/x-icon" />
        <link href="imagenes/logo_transp.gif" rel="apple-touch-icon" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="tipo_contenido"  content="text/html;" http-equiv="content-type" charset="utf-8">
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <script language="Javascript">

            function validateForm() {
                if (document.getElementById("email").value === '') {
            swal("El email es requerido!", "Capture el email para continuar.", "error").then((value) => {window.parent.location.href='GetPassword.jsp'});
        
                    document.getElementById("email").value = ''
                } else {

                    expr = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                    if (!expr.test(document.getElementById("email").value)) {
                        swal("Formato de email inválido.!", "Error: La dirección de correo ::: " + document.getElementById("email").value + " ::: no es válido.", "error").then((value) => {window.parent.location.href='GetPassword.jsp'});
        
                        document.getElementById("email").value = "";

                    } else {
                        document.Formrecuperarpass.submit();
                    }

                }

            }



        </script>
    </head>
    <body oncontextmenu="return false;" >

        <div class="container-fluid">
            <div class="row">
                <div id="header2" class="container">
                    <%@include file="Top.jsp" %>
                </div>
            </div>
        </div>

        <div class="container-fluid my-4">
            <div class="container ">

                <form id="Formrecuperarpass" name="Formrecuperarpass" method="POST" action="recuperarpassword">
                    <input type="hidden" name="command" value="">

                    <h1><b>Recuperar password</b></h1>
                    <p>Por favor inserte su dirección de correo electrónico :</p>
                    <input type="text" id="email" name="email" class="default" size="30">

                    <div class="d-block my-2">
                        <input type="button" value="Continuar" onClick="validateForm();" class="btn btn-outline-secondary2">

                        <input type="button" onclick="redi()" value="Cancelar" onClick="" class="btn btn-outline-danger">
                    </div>
                    <script>
                        function redi() {
                            top.location.href = "Login.jsp";
                        }
                    </script>
                </form>

            </div>
        </div>
        <div id="clearRow" style="height: 50px;"></div>
<%@include file="Bottom.jsp" %>
    </body>
    <head>
        <META HTTP-EQUIV="PRAGMA" CONTENT="NO-CACHE">
    </head>
</html>
