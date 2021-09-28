<%@ page language="java" import="java.util.*"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "https://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta charset="UTF-8">
        <link href="imagenes/logo_transp.gif" rel="shortcut icon" type="image/x-icon" />
        <link href="imagenes/logo_transp.gif" rel="apple-touch-icon" />
        
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <%@ include file="HeaderOptions.jsp" %>
        <title>Pago de Servicios en L&iacute;nea (Login)</title>
        <script src="https://ajax.googleapis.com/ajax/libs/webfont/1.4.7/webfont.js" type="text/javascript"></script>
        <link href="styles/webflow1.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow4.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow3.css" rel="stylesheet" type="text/css" />
        
        <script language="Javascript">
            
    function validateForm() {
        if (document.loginFormFrame.email.value !== "") {
         
            if (document.loginFormFrame.password.value !== "") {
                expr = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                                    if (!expr.test(document.loginFormFrame.email.value)){
                                        swal("Error: La dirección de correo ::: " + document.loginFormFrame.email.value + " ::: no es válido.");
                                    document.loginFormFrame.email.value = "";
                                
                                }else{document.loginFormFrame.submit();}
                
            } else {
                swal("Por favor inserte el password.");
                document.loginFormFrame.password.focus();
            }
        } else {
            swal("Por favor inserte el email.");
            document.loginFormFrame.email.focus();
        }
    }

 


    

        </script>
    
    </head>
    <body >
        <!-- HEADER -->
        
        <div style="vertical-align: top;position:absolute; top:0; left:0;" class="login-container col-lg-5 float-left py-4">
                        <form name="loginFormFrame" method="POST" action="autframe">
 

                            <h2 class="text-center mt-1 mb-3"><strong>Ingreso a Servicio en Línea</strong></h2>
                            <label for="email">E-Mail:
                            <input type="text" name="email" size="30" class="form-control"  value=""></label>
                         
                            <label for="password">Contraseña:
                            <input type="password" name="password" size="30" class="form-control"  value=""></label>
                            
                            <input  type="button" value="Continuar" onclick="validateForm();" class="btn btn-outline-secondary"><br>

                            
                       </form>
                    </div>

      
   
    </body>
</html>
