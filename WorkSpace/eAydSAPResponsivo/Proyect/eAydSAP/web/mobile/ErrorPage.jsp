<%-- 
    Document   : new_client
    Created on : 10/08/2012, 04:31:02 PM
    Author     : jcantu
--%>

<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>Mobile AyD Mty.</title>
        <link rel="stylesheet" href="mobile/jquery.mobile-1.0a2.min.css" />
        <script src="mobile/jquery-1.4.4.min.js"></script>
        <script src="mobile/jquery.mobile-1.0a2.min.js"></script>
        <style>
        .ui-grid-b img {
            width  : 100%;
            height : auto;
        }
        #Top {
            background-color: #F8F8F8;
        }
        .full {
            width: 100%;
        }

        </style>
    </head>
    <body>
        <div data-role="page" id="page" data-theme="c">

            <div data-role="header" data-position="fixed" id="Top">
                <img src="mobile/images/banner.jpg" class="full" />
            </div><!-- /header -->

            <div data-role="content">
                <br><br>
                <%
                if(request.getAttribute("msg")!=null){
                    out.println(request.getAttribute("msg"));
                } else {
                    out.println("Error Interno de Aplicación.");
                }
                %>
                <br><br>
            </div><!-- /content -->

            <div data-role="footer">
                <img src="mobile/images/registra_mail.jpg" class="full" />
            </div><!-- /footer -->
        </div><!-- /page -->
    </body>
</html>
