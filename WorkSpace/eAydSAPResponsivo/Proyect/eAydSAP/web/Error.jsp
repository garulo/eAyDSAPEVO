<%@ page language="java" import="java.util.*"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "https://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="tipo_contenido"  content="text/html;" http-equiv="content-type" charset="utf-8">
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <link href="imagenes/logo_transp.gif" rel="shortcut icon" type="image/x-icon" />
        <link href="imagenes/logo_transp.gif" rel="apple-touch-icon" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <%@ include file="HeaderOptions.jsp" %>
        <title>Error</title>
        <script src="https://ajax.googleapis.com/ajax/libs/webfont/1.4.7/webfont.js" type="text/javascript"></script>
        <link href="styles/webflow1.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow4.css" rel="stylesheet" type="text/css" />
        <link href="styles/webflow3.css" rel="stylesheet" type="text/css" />
              
        <style>
            a {
                text-decoration: none !important;
            }
            a:hover {
                color: #0056b3;
                text-decoration: none !important;
            }
        </style>
    </head>
    <body oncontextmenu="return false;" onLoad="goToTop();">
 <%@include file="Top.jsp" %>

        <!-- HEADER -->
<div id="content">

        <div class="container-fluid my-4">
            <div class="row py-2">
                <div class="container py-2">
                    <div class="login-container col-12 col-lg-5 float-left py-4">
                        
                        <h1>Página no encontada!!</h1>
                       
                    </div>


                    <div id="no-registrado" class=" col-12 offset-lg-1 col-lg-6 float-left py-4">
                    
                       
                    </div>
                </div>

            </div>
        </div>
        <div class="container-fluid">
            
        </div>
      
    </div>
          <%@include file="Bottom.jsp" %>
    </body>
</html>
