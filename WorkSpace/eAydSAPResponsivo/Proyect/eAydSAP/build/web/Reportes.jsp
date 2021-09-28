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
        <title>Reportes Operativos</title>
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
        <div id="content">
            <div class="container-fluid my-4">
                <div class="row py2">
                    <div class="container py2">
                        <%@include file="MenuServicios.jsp" %>
                        <div class="float-left">
                            <div style="min-width: 90%;text-align:  left;" >
                                <div onclick="goGenRepo();"  class="alert alert-light" role="alert"  >
                                    <img id="reportespng" src="imagenes/12345.png" class="img-fluid"  style="width: 15%;" >
                                   
                                    <fieldset>
                                            <h4>Generar un reporte</h4>
                                            <p class="text">
                                                Presiona aquí, para genera reportes por fallas en el suministro de agua o fugas

                                        </fieldset>
                                    <script>
                                        function  goGenRepo(){
                                            window.location = "GenerarReportes.jsp";
                                        }
                                    </script>
                                </div>
                                <div onclick="consulRepo();" class="alert alert-light" role="alert">
                                    <img id="consultapng"  src="imagenes/Consulta.PNG" class="img-fluid" style="width: 10%;">
                                    <fieldset>
                                            <h4>Consulta estatus de solicitud</h4>
                                            <p class="text">
                                               Presiona aquí, para consultar estatus de solicitudes iniciadas

                                        </fieldset>
                                    
                                    <script>
                                        function  consulRepo(){
                                            window.location = "ConsultaReportes.jsp";
                                        }
                                    </script>
                                </div>
                                
                            </div>

                        </div>
                    </div>


                </div></div></div>
                <%@include file="Bottom.jsp" %>
    </body>
</html>
<%}%>